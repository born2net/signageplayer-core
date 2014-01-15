package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	public class CampaignBoardPlayer implements IEventHandleHost
	{
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_catalogService:CatalogService;
		protected var m_debugLog:IDebugLog;
		protected var m_playerEventService:IPlayerEventService;
		
		
		protected var m_playerStatus:String = "Ready";
		protected var m_playMode:String;
		protected var m_mouseX:int = 0;
		
		protected var m_timelineManager:TimelineManager;
		protected var m_playlistPlayer:PlaylistPlayer;
		
		protected var m_campaignChannles:Object = new Object();
		
		protected var m_beginTime:Number;
		
		protected var m_previewTimeline:TimelinePlayer;
		
		protected var m_campaignEventTimeline:TimelinePlayer;
		protected var m_autoResume:Boolean = false;
		
		
		
		
		protected var m_viewerService:IViewerService;
		
		
		protected var m_hCampaignBoard:int = -1;
		protected var m_hCampaign:int = -1;
		protected var m_hBoard:int = -1;
		
		
		
		public function CampaignBoardPlayer(i_framework:IFramework)
		{
			m_framework = i_framework;
			
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_viewerService = m_framework.ServiceBroker.QueryService("ViewerService") as IViewerService;
		}
		
		

		
		public function get framework():IFramework
		{
			return m_framework;
		}
		
		public function get hCampaignBoard():int
		{
			return m_hCampaignBoard;
		}
		
		
		
		public function init():void
		{
			var businessDomain:String = m_framework.StateBroker.GetState("businessDomain") as String;
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_catalogService = m_framework.ServiceBroker.QueryService("CatalogService") as CatalogService;
			
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			
			m_playerEventService = m_framework.ServiceBroker.QueryService("PlayerEventService") as IPlayerEventService;
			
			m_debugLog.addInfo("CampaignBoardPlayer.init()");
			
			FlexGlobals.topLevelApplication.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		} 
		
		
		public function onCommand(i_eventHandler:IEventHandler, i_eventParam:Object):void
		{
			var campaignEventHandler:CampaignEventHandler = i_eventHandler as CampaignEventHandler;
			if (campaignEventHandler==null)
				return;
			
			
			if (campaignEventHandler.commandName=="select")
			{
				m_playMode==PlayMode.CAMPAIGN_INTERUPT;
				m_campaignEventTimeline = campaignEventHandler.timelinePlayer;
				m_autoResume = (campaignEventHandler.finishAction=="autoResume");
				
				if (m_playlistPlayer!=null)
				{
					m_playlistPlayer.stop();
				}
				
				m_playMode = PlayMode.CAMPAIGN_INTERUPT;
				
				if (m_campaignEventTimeline!=null)
				{
					m_campaignEventTimeline.play();
				}
			}
			else if (campaignEventHandler.commandName=="resume")
			{
				if (m_playMode == PlayMode.CAMPAIGN_INTERUPT && m_playerStatus=="Playing")
				{
					if (m_campaignEventTimeline!=null)
					{
						m_campaignEventTimeline.stop();
						m_campaignEventTimeline = null;
					}
					
					m_playMode = PlayMode.PRESENTATION;
					
					if (m_playlistPlayer!=null)
					{
						m_playlistPlayer.start();
					}
				}				
			}
			else if (campaignEventHandler.commandName=="post")
			{
				var urlVar:URLVariables = new URLVariables();
				var urlPair:Array = campaignEventHandler.postUrl.split('?');
				if (urlPair.length==2)
				{
 					urlVar.decode(urlPair[1]);
				}
				
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				var urlRequest:URLRequest = new URLRequest(urlPair[0]);
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.data = urlVar; 
				loader.load(urlRequest);
			}
		}
		
		
		
		public function setSignageParams(i_hCampaignBoard:int):void
		{
			var recCampaignBoard:Rec_campaign_board = m_dataBaseManager.table_campaign_boards.getRecord(i_hCampaignBoard);
			if (recCampaignBoard==null)
				return;
			m_hCampaignBoard = i_hCampaignBoard;
			m_hCampaign = recCampaignBoard.campaign_id;
			m_hBoard = recCampaignBoard.board_id;
		}
		
		

		public function initTableData():void
		{
			if (m_catalogService!=null)
			{
				m_catalogService.sync();
			}
			
			
			initCampaignChannels();
			
			m_timelineManager = new BoardTimelineManager(m_framework, m_hCampaign, m_hBoard, m_hCampaignBoard);
			m_timelineManager.init(m_campaignChannles);
			
			
			var recCampaign:Rec_campaign = m_dataBaseManager.table_campaigns.getRecord(m_hCampaign);
			
			if (recCampaign.campaign_playlist_mode==0)
			{
				m_playlistPlayer = new SequencePlaylistPlayer(m_framework, m_timelineManager, m_hCampaign);
			}
			else
			{
				m_playlistPlayer = new SchedulePlaylistPlayer(m_framework, m_timelineManager, m_hCampaign);
			}
			
			var recBoard:Rec_board = m_dataBaseManager.table_boards.getRecord(m_hBoard);
			var orientationEnabled:Boolean = recBoard.monitor_orientation_enabled;
			orientationEnabled = false; //??? M??? this will effect Android.  was desable to prevent bug
			m_viewerService.updateScale(recBoard.board_pixel_width, recBoard.board_pixel_height, orientationEnabled);
			
			
			initCampaignEvents();
			updatePlayMode(recCampaign);
		}
		
		
		protected function initCampaignEvents():void
		{
			var keys:Array = m_dataBaseManager.table_campaign_events.getAllPrimaryKeys();
			var xmlParams:XML;
			for each(var hCampaignEvent:int in keys)
			{
				var recCampaignEvent:Rec_campaign_event = m_dataBaseManager.table_campaign_events.getRecord(hCampaignEvent);
				if (recCampaignEvent.campaign_id!=m_hCampaign)
					continue;
				
				var campaignEventHandler:CampaignEventHandler = new CampaignEventHandler(m_playerEventService, this);
				campaignEventHandler.senderName = recCampaignEvent.sender_name;
				var xmlCondition:XML = new XML(recCampaignEvent.event_condition);
				campaignEventHandler.eventCondition = xmlCondition.toString();
				campaignEventHandler.commandName = recCampaignEvent.command_name;
				if (recCampaignEvent.command_name=="select")
				{
					campaignEventHandler.timelinePlayer = m_timelineManager.getTimeline(recCampaignEvent.campaign_timeline_id);
					xmlParams = new XML(recCampaignEvent.command_params);
					campaignEventHandler.finishAction = String(xmlParams.Param[0].@action);
				}
				else if (recCampaignEvent.command_name=="post")
				{
					xmlParams = new XML(recCampaignEvent.command_params);
					campaignEventHandler.postUrl = String(xmlParams.Param[0].@url);
				}
				
				m_playerEventService.registerEventHandler(campaignEventHandler);
			}
		}
		
		
		protected function updatePlayMode(i_recCampaign:Rec_campaign):void
		{
			m_framework.StateBroker.SetState(this, "kioskMode", false);
			m_playMode = PlayMode.PRESENTATION;
		}
			
		
		
		public function previewTimeline(i_hCampaignTimeline:int):void
		{
			m_previewTimeline = m_timelineManager.getTimeline(i_hCampaignTimeline);
			m_playMode = PlayMode.PERVIEW_TIMELINE;
		}
		
		
		private function initCampaignChannels():void
		{
			var recCampaign:Rec_campaign;
			var recCampaignChannel:Rec_campaign_channel;
			
			var channel:Channel;
			
			var campaignChannleKeys:Array = m_dataBaseManager.table_campaign_channels.getAllPrimaryKeys();
			for each(var hCampaignChannel:int in campaignChannleKeys) 
			{
				recCampaignChannel = m_dataBaseManager.table_campaign_channels.getRecord(hCampaignChannel);
				recCampaign = m_dataBaseManager.table_campaigns.getRecord(recCampaignChannel.campaign_id);
				if (recCampaign!=null && recCampaign.campaign_id==m_hCampaign)
				{
					addCampaignChannel(hCampaignChannel);
				}
			}
			
			var playerKeys:Array = m_dataBaseManager.table_campaign_channel_players.getAllPrimaryKeys();
			for each(var hPlayer:int in playerKeys)
			{
				var recCampaignChannelPlayer:Rec_campaign_channel_player = m_dataBaseManager.table_campaign_channel_players.getRecord(hPlayer);
				recCampaignChannel = m_dataBaseManager.table_campaign_channels.getRecord(recCampaignChannelPlayer.campaign_channel_id);
				recCampaign = m_dataBaseManager.table_campaigns.getRecord(recCampaignChannel.campaign_id);
				if (recCampaign!=null && recCampaign.campaign_id==m_hCampaign)
				{
					channel = m_campaignChannles[recCampaignChannelPlayer.campaign_channel_id];
					
					var adLocalEnabled:Boolean = false;
					var hAdLocalContent:int = -1;
					if (recCampaignChannelPlayer.ad_local_content_id!=-1)
					{
						var recAdLocalContent:Rec_ad_local_content = m_dataBaseManager.table_ad_local_contents.getRecord(recCampaignChannelPlayer.ad_local_content_id);
						if (recAdLocalContent!=null)  // is null in Web Player
						{
							adLocalEnabled = recAdLocalContent.enabled;
							hAdLocalContent = recCampaignChannelPlayer.ad_local_content_id;
						}
					}					
					
					channel.addPlayer(  recCampaignChannelPlayer.campaign_channel_player_id,
						recCampaignChannelPlayer.mouse_children,
						recCampaignChannelPlayer.player_offset_time,
						recCampaignChannelPlayer.player_duration,
						recCampaignChannelPlayer.player_data,
						adLocalEnabled,
						hAdLocalContent);
				}
			}
			
			for each(channel in m_campaignChannles)
			{
				channel.sort();
			}
		}
		
		private function addCampaignChannel(i_hCampaignChannel:int):void
		{
			if (m_campaignChannles[i_hCampaignChannel]==null)
			{
				var channel:Channel = new CampaignChannel(m_framework);
				channel.init(i_hCampaignChannel);
				m_campaignChannles[i_hCampaignChannel] = channel;
			}
		}
		
		
		
		
		public function start():void
		{
			m_debugLog.addInfo("CampaignBoardPlayer.start()");
			
			m_playerStatus="Playing";
			
			m_beginTime = new Date().time;
			for each(var channle:Channel in m_campaignChannles)
			{
				channle.start();
			}
			
			if (m_playMode==PlayMode.PRESENTATION)
			{
				if (m_playlistPlayer!=null)
				{
					m_framework.EventBroker.dispatchEvent( new Event("showDesktop") );
					m_playlistPlayer.start();
				}
			}
			else if (m_playMode==PlayMode.PERVIEW_TIMELINE) 
			{
				if (m_previewTimeline!=null)
				{
					m_previewTimeline.play();
				}
			}
		}
		
		public function stop():void
		{
			m_viewerService.cleanChanels(true);
			
			
			m_playerStatus="Ready";
			
			for each(var channle:Channel in m_campaignChannles)
			{
				channle.stop();
			}
			
			if (m_playMode==PlayMode.PRESENTATION)
			{
				if (m_playlistPlayer!=null)
				{
					m_playlistPlayer.stop();
				}
			}
			else if (m_playMode==PlayMode.PERVIEW_TIMELINE)
			{
				if (m_previewTimeline!=null)
				{
					m_previewTimeline.stop();
				}
			}			
		}
		
		
		protected function onEnterFrame(event:Event):void
		{
			try
			{
				if (m_playerStatus!="Playing")
					return;
				var date:Date = new Date();
				
				var offsetTime:Number = date.time - m_beginTime;
				for each(var channle:Channel in m_campaignChannles)
				{
					channle.tick(offsetTime);
				}
				
				tick(date.time);
			}
			catch(error:Error)
			{
				m_debugLog.addInfo("CampaignBoardPlayer.onEnterFrame()");
				m_debugLog.addException(error);
				FlexGlobals.topLevelApplication.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		protected function tick(i_time:Number):void
		{
			try
			{
				if (m_playMode==PlayMode.PRESENTATION)
				{
					m_playlistPlayer.tick(i_time);	
				}
				else if (m_playMode==PlayMode.PERVIEW_TIMELINE)
				{
					if (m_previewTimeline!=null)
					{
						m_framework.StateBroker.SetState(this, "playPreviewTime", (i_time-m_beginTime)/1000);
						if (m_previewTimeline.tick(i_time)==false)
						{
							m_previewTimeline.stop();
							m_framework.StateBroker.SetState(this, "playPreviewMode", null);
						}
					}
				}
				else if (m_playMode==PlayMode.CAMPAIGN_INTERUPT)
				{
					if (m_campaignEventTimeline!=null)
					{
						try
						{
							if (m_campaignEventTimeline.tick(i_time)==false)
							{
								if (m_autoResume)
								{
									if (m_playMode == PlayMode.CAMPAIGN_INTERUPT)
									{
										if (m_campaignEventTimeline!=null)
										{
											m_campaignEventTimeline.stop();
											m_campaignEventTimeline = null;
										}
										
										m_playMode = PlayMode.PRESENTATION;
										
										if (m_playlistPlayer!=null)
										{
											m_playlistPlayer.start();
										}
									}				
								}
								else
								{
									m_campaignEventTimeline.play();
								}
							}
						}
						catch(error:Error)
						{
							m_debugLog.addInfo("CampaignBoardPlayerAir.tick()");
							m_debugLog.addException(error);
							FlexGlobals.topLevelApplication.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
						}
					}
				}
			}
			catch(error:Error)
			{
				m_debugLog.addInfo("CampaignBoardPlayer.tick()");
				m_debugLog.addException(error);
			}
		}
		
		
		public function getPlayerStatus():String
		{
			return m_playerStatus;
		}

		
		
		public function dispose():void
		{
			stop();
			if (m_timelineManager!=null)
			{
				m_timelineManager.dispose();
				m_timelineManager = null;
			}
			
			m_playlistPlayer.dispose();
			
			FlexGlobals.topLevelApplication.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}
}