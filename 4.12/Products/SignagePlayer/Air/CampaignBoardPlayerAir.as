package
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	public class CampaignBoardPlayerAir extends CampaignBoardPlayer
	{
		import mx.events.ModuleEvent; 
		import mx.rpc.events.ResultEvent;
		import mx.rpc.events.FaultEvent;
		
		protected var m_watchDogService:IWatchDogService;
		
		
		protected var m_kioskTimeline:TimelinePlayer
		protected var m_idleTimer:Timer;
		
		
		
		
		
		public function CampaignBoardPlayerAir(i_framework:IFramework)
		{
			super(i_framework);
			m_watchDogService = m_framework.ServiceBroker.QueryService("WatchDogService") as IWatchDogService;
		}
		
		
		protected override function updatePlayMode(i_recCampaign:Rec_campaign):void
		{
			m_framework.StateBroker.SetState(this, "kioskMode", i_recCampaign.kiosk_mode);
			m_framework.StateBroker.SetState(this, "kioskKey", i_recCampaign.kiosk_key);
			
			if (i_recCampaign.mouse_interrupt_mode)
			{
				m_kioskTimeline = (i_recCampaign.kiosk_timeline_id!=-1) ?
					m_timelineManager.getTimeline(i_recCampaign.kiosk_timeline_id) :
					null;
				m_playMode = PlayMode.MOUSE_INTERUPT; 
				FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				m_idleTimer = new Timer(i_recCampaign.kiosk_wait_time * 60000, 1);
				m_idleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onIdleTimer);
				m_idleTimer.start();
			}
			else
			{
				m_playMode = PlayMode.PRESENTATION;
			}
		}		
		
		private function onMouseMove(event:MouseEvent):void
		{
			if (m_playMode==PlayMode.PRESENTATION)
			{
				if (m_mouseX!=0 && Math.abs(event.stageX-m_mouseX)>30)
				{ 
					if (m_playlistPlayer!=null)
					{
						m_playlistPlayer.stop();
					}
					
					m_playMode = PlayMode.MOUSE_INTERUPT;
					
					if (m_kioskTimeline!=null)
					{
						m_kioskTimeline.play();
					}
					else
					{
						showTopWindow(false);
					}
					m_idleTimer.start();
				}
				
			}
			else if (m_playMode==PlayMode.MOUSE_INTERUPT)
			{
				m_idleTimer.reset();
				m_idleTimer.start();
			}
			m_mouseX = event.stageX;
		}
		
		private function onIdleTimer(event:TimerEvent):void
		{
			if (m_playMode == PlayMode.MOUSE_INTERUPT && m_playerStatus=="Playing")
			{
				if (m_kioskTimeline!=null)
				{
					m_kioskTimeline.stop();
				}
				
				m_playMode = PlayMode.PRESENTATION;
				
				if (m_playlistPlayer!=null)
				{
					showTopWindow(true);
					m_playlistPlayer.start();
				}
			}
		}
		
		
		public override function start():void
		{
			super.start();
			
			if (m_playMode==PlayMode.MOUSE_INTERUPT) 
			{
				if (m_kioskTimeline!=null) 
				{
					showTopWindow(true);
					m_kioskTimeline.play();
					
					if (m_watchDogService!=null)
					{
						//m_watchDogService.showTaskBar(false);
					}					
				}
				else
				{
					// desktop mode
					showTopWindow(false);
					
					if (m_watchDogService!=null)
					{
						m_watchDogService.mouseMoveListener(true);
						//m_watchDogService.showTaskBar(true);
					}
				}
			}
		}
		
		public override function stop():void
		{
			super.stop();
			
			//m_watchDogService.showTaskBar(true);
			
			if (m_playMode==PlayMode.MOUSE_INTERUPT)
			{
				if (m_kioskTimeline!=null)
				{
					m_kioskTimeline.stop();
				}
				else // Desktop
				{
					if (m_watchDogService!=null)
					{
						m_watchDogService.mouseMoveListener(false);
					}					
				}
			}			
		}
		
		
		protected override function tick(i_time:Number):void
		{
			super.tick(i_time);
			if (m_playMode==PlayMode.MOUSE_INTERUPT)
			{
				if (m_kioskTimeline!=null)
				{
					try
					{
						if (m_kioskTimeline.tick(i_time)==false)
						{
							m_kioskTimeline.play();
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
		
		
		protected function showTopWindow(i_show:Boolean):void
		{
			var topWindow:UIComponent = UIComponent(m_framework.StateBroker.GetState("parentApplication"));
			topWindow.visible = i_show;
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if (m_idleTimer!=null)
			{
				m_idleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onIdleTimer);
				m_idleTimer = null;	
			}
		}
	}
}
