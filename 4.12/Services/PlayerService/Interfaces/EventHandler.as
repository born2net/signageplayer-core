package  
{
	public class EventHandler implements IEventHandler
	{
		protected var m_eventHandleHost:IEventHandleHost;
		protected var m_playerEventService:IPlayerEventService;
		protected var m_senderName:String;
		protected var m_eventCondition:String;
		protected var m_commandName:String;
		protected var m_commandParams:XML;

		
		public function EventHandler(i_playerEventService:IPlayerEventService, i_eventHandleHost:IEventHandleHost)
		{
			m_playerEventService = i_playerEventService;
			m_eventHandleHost = i_eventHandleHost;
		}
		
		public function onEvent(i_eventName:String, i_eventParam:Object):void
		{
			var validCondition:Boolean = triggerNow(i_eventParam);
			if (validCondition)
			{
				m_eventHandleHost.onCommand(this, i_eventParam);
			}
		}
			
		public function triggerNow(i_eventParam:Object):Boolean
		{
			if (m_eventCondition==null || m_eventCondition=="")
				return true;
			
			var value:Number = Number(i_eventParam);
			
			
			//??? return m_playerEventService.callFunction(m_eventCondition, value);
			return true;
		}
		
		
		public function get senderName():String
		{
			return m_senderName;
		}
		
		public function set senderName(i_senderName:String):void
		{
			m_senderName = i_senderName;
		}
		
		
		public function get eventCondition():String
		{
			return m_eventCondition;
		}
		
		public function set eventCondition(i_eventCondition:String):void
		{
			m_eventCondition = i_eventCondition;
		}
		
		
		public function get commandName():String
		{
			return m_commandName;
		}
		
		public function set commandName(i_commandName:String):void
		{
			m_commandName = i_commandName;
		}
		
		public function get commandParams():XML
		{
			return m_commandParams;
		}
		
		public function set commandParams(i_commandParams:XML):void
		{
			m_commandParams = i_commandParams;
		}
	}
}
