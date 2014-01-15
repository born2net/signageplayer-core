package
{
	public class TimelinePlayer
	{
		public static const TIMELINE_FINISHED_EVENT:String = "timeline_finish_event";
		
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_viewerService:IViewerService;
		protected var m_debugLog:IDebugLog;
		
		
		protected var m_hCampaignTimeline:int = -1; 
		protected var m_chanles:Object = new Object();
		protected var m_beginTime:Number;
		
		protected var m_offsetTime:Number = 0;
		private var m_timelineDuration:Number;
		
		public function TimelinePlayer(i_framework:IFramework, i_hCampaignTimeline:int)
		{
			m_framework = i_framework;
			m_hCampaignTimeline = i_hCampaignTimeline;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_viewerService = m_framework.ServiceBroker.QueryService("ViewerService") as IViewerService;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			
			var recCampaignTimeline:Rec_campaign_timeline = m_dataBaseManager.table_campaign_timelines.getRecord(i_hCampaignTimeline);
			m_timelineDuration = recCampaignTimeline.timeline_duration * 1000;
		}
		
		public function addChanel(i_hCampaignTimelineChanel:int):void
		{
			if (m_chanles[i_hCampaignTimelineChanel]==null)
			{
				var chanel:Channel = new TimelineChannel(m_framework);
				chanel.init(i_hCampaignTimelineChanel);
				m_chanles[i_hCampaignTimelineChanel] = chanel;
			}
		}
		
		public function getChanel(i_hCampaignTimelineChanel:int):Channel
		{
			return m_chanles[i_hCampaignTimelineChanel];
		}
		

		public function sort():void
		{
			for each(var chanel:Channel in m_chanles)
			{
				chanel.sort();
			}
		}
		
		public function play():void
		{
			m_beginTime = new Date().time;
			for each(var chanle:Channel in m_chanles)
			{
				chanle.start();
			}
		}
		
		public function stop():void
		{
			m_viewerService.cleanChanels(false);
			for each(var chanle:Channel in m_chanles)
			{
				chanle.stop();
			}
		}
		
		public function tick(i_time:Number):Boolean
		{
			try
			{
				m_offsetTime = i_time - m_beginTime;
				if (m_offsetTime>m_timelineDuration)
				{
					return false;
				}
				for each(var chanle:Channel in m_chanles)
				{
					chanle.tick(m_offsetTime);
				}
			}
			catch(error:Error)
			{
				m_debugLog.addInfo("TimelinePlayer.tick()");
				m_debugLog.addException(error);
			}			
			return true;
		}
		
		public function dispose():void
		{
			m_framework = null;
			m_dataBaseManager = null;
			m_viewerService = null;
			if (m_chanles!=null)
			{
				for each(var chanle:Channel in m_chanles)
				{
					chanle.dispose();
				}
				m_chanles = null;
			}
		}
	}
}
