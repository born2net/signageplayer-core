package  
{
	public class CampaignEventHandler extends EventHandler
	{
		private var m_timelinePlayer:TimelinePlayer;
		private var m_finishAction:String;
		private var m_postUrl:String;
		
		public function CampaignEventHandler(i_playerEventService:IPlayerEventService, i_eventHandleHost:IEventHandleHost)
		{
			super(i_playerEventService, i_eventHandleHost);
		}
		
		
		public function get timelinePlayer():TimelinePlayer
		{
			return m_timelinePlayer;
		}
		
		public function set timelinePlayer(i_timelinePlayer:TimelinePlayer):void
		{
			m_timelinePlayer = i_timelinePlayer;
		}
		
		
		public function get finishAction():String
		{
			return m_finishAction;
		}
		
		public function set finishAction(i_finishAction:String):void
		{
			m_finishAction = i_finishAction;
		}
		
		
		public function get postUrl():String
		{
			return m_postUrl;
		}
		
		public function set postUrl(i_postUrl:String):void
		{
			m_postUrl = i_postUrl;
		}
		
	}
}
