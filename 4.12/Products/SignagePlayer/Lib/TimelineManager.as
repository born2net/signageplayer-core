package
{
	public class TimelineManager
	{
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_timelines:Object;
		protected var m_hCampaign:int;
				
		public function TimelineManager(i_framework:IFramework, i_hCampaign:int)
		{
			m_framework = i_framework;
			m_hCampaign = i_hCampaign;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			clear();
		}


		public function clear():void
		{
			m_timelines = new Object();
		}
		
		public function init(i_campaignChannles:Object):void
		{
			var timeline:TimelinePlayer;
			var recChanel:Rec_campaign_timeline_chanel;
			var recCampaignTimeline:Rec_campaign_timeline;
			var chanleKeys:Array = m_dataBaseManager.table_campaign_timeline_chanels.getAllPrimaryKeys();
			for each(var hChanel:int in chanleKeys) 
			{
				recChanel = m_dataBaseManager.table_campaign_timeline_chanels.getRecord(hChanel);
				
				
				recCampaignTimeline = m_dataBaseManager.table_campaign_timelines.getRecord(recChanel.campaign_timeline_id);
				if (recCampaignTimeline==null)
					continue;
				
				if (recCampaignTimeline.campaign_id!=m_hCampaign)
					continue;
				
				
				timeline = m_timelines[recChanel.campaign_timeline_id];
				if (timeline!=null) //???
				{
					timeline.addChanel(hChanel);
				}
			}
			
			var playerKeys:Array = m_dataBaseManager.table_campaign_timeline_chanel_players.getAllPrimaryKeys();
			for each(var hPlayer:int in playerKeys)
			{
				var recCampaignTimelineChanelPlayer:Rec_campaign_timeline_chanel_player = m_dataBaseManager.table_campaign_timeline_chanel_players.getRecord(hPlayer);
				recChanel = m_dataBaseManager.table_campaign_timeline_chanels.getRecord(recCampaignTimelineChanelPlayer.campaign_timeline_chanel_id);
				
				recCampaignTimeline = m_dataBaseManager.table_campaign_timelines.getRecord(recChanel.campaign_timeline_id);
				if (recCampaignTimeline==null)
					continue;
				
				if (recCampaignTimeline.campaign_id!=m_hCampaign)
					continue;
				
				
				timeline = m_timelines[recChanel.campaign_timeline_id];
				if (timeline!=null)
				{
					var chanel:Channel = timeline.getChanel(recCampaignTimelineChanelPlayer.campaign_timeline_chanel_id);
					
					var adLocalEnabled:Boolean = false;
					var hAdLocalContent:int = -1;
					if (recCampaignTimelineChanelPlayer.ad_local_content_id!=-1)
					{
						var recAdLocalContent:Rec_ad_local_content = m_dataBaseManager.table_ad_local_contents.getRecord(recCampaignTimelineChanelPlayer.ad_local_content_id);
						if (recAdLocalContent!=null)  // in Web player it's null
						{
							adLocalEnabled = recAdLocalContent.enabled;
							hAdLocalContent = recCampaignTimelineChanelPlayer.ad_local_content_id;
						}
					}
					
					chanel.addPlayer(   recCampaignTimelineChanelPlayer.campaign_timeline_chanel_player_id,
										recCampaignTimelineChanelPlayer.mouse_children,
										recCampaignTimelineChanelPlayer.player_offset_time,
										recCampaignTimelineChanelPlayer.player_duration,
										recCampaignTimelineChanelPlayer.player_data,
										adLocalEnabled,
										hAdLocalContent);
				}
			}
			
			sortTimelines();
		}
		
		protected function sortTimelines():void
		{
			for each(var timeline:TimelinePlayer in m_timelines)
			{
				timeline.sort();			
			}
		}
		
		public function getTimeline(i_hCampaignTimeline:int):TimelinePlayer
		{
			return m_timelines[i_hCampaignTimeline];
		}

		public virtual function dispose():void
		{
			m_framework = null;
			m_dataBaseManager = null;
			if (m_timelines!=null)
			{
				for each(var timeline:TimelinePlayer in m_timelines)
				{
					timeline.dispose();
				}
				m_timelines = null;
			}
		}
	}
}
