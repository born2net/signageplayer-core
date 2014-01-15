package
{
	import flash.events.Event;
	
	public class StateBrokerEvent extends Event
	{
		public static var STATE_SET:String 		= "event_state_set";
		public static var STATE_REMOVED:String 	= "event_sate_removed";
		
		private var m_sender:Object;
		private var m_stateName:String;
		
		public function StateBrokerEvent(i_sender:Object, i_stateName:String, i_type:String)
		{
			super(i_type, false, false);
			m_sender = i_sender;
			m_stateName = i_stateName;
		}
		
		public function get sender():Object { return m_sender; }
		public function get stateName():Object { return m_stateName; }
	}
}