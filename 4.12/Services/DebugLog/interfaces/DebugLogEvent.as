package
{
	import flash.events.Event;
	
	public class DebugLogEvent extends Event
	{
		private var m_message:String;
		private var m_messageType:String;
		public static var MESSAGE:String = "event_log_message"; 
		
		public function DebugLogEvent(i_type:String, i_message:String, i_messageType:String)
		{
			super(i_type);
			m_message = i_message;
			m_messageType = i_messageType;
		}
		
		public function get message():String
		{
			return m_message;
		}
		
		public function get messageType():String
		{
			return m_messageType;
		}
	}	
}