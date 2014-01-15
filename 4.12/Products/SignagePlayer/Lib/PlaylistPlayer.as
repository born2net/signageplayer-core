package
{
	import flash.events.Event;
	
	public class PlaylistPlayer
	{
		protected var m_framework:IFramework;
		protected var m_debugLog:IDebugLog;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_viewerService:IViewerService;
		protected var m_timelineManager:TimelineManager;
		protected var m_hCampaign:int;
		
		public function PlaylistPlayer(i_framework:IFramework, i_timelineManager:TimelineManager, i_hCampaign:int)
		{
			m_framework = i_framework;
			m_timelineManager = i_timelineManager;
			m_hCampaign = i_hCampaign;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_viewerService = m_framework.ServiceBroker.QueryService("ViewerService") as IViewerService;
		}
		
		public function start():void
		{
		}
		
		public function stop():void
		{
			
		}
		
		public function tick(i_time:Number):void
		{
			
		}
		
		
		public function dispose():void
		{
			
		}
	}
}