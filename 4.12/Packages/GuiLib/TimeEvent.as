package
{
	import flash.events.Event;

	public class TimeEvent extends Event
	{
		public static var TIME_CHANGED:String = "time_changed";
		private var m_sender:TimeCtrl;
		private var m_newTime:Number;
		
		public function TimeEvent(i_sender:TimeCtrl, i_newTime:Number)
		{
			super(TIME_CHANGED, false, false);
			m_sender = i_sender;
			m_newTime= i_newTime;
		}
		
		public function get sender():TimeCtrl { return m_sender; }
		
		public function get newTime():Number { return m_newTime; }
		
	}
}