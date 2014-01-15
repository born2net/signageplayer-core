package
{
	import flash.events.Event;

	public class OffsetTimeEvent extends Event
	{
		public static const EVENT_OFFSET_TIME:String = "event_offset_time";
		private var m_offsetTime:Number;
		
		public function OffsetTimeEvent(type:String, i_offsetTime:Number)
		{
			super(type, true);
			m_offsetTime = i_offsetTime;
		}
		
		public function get offsetTime():Number
		{
			return m_offsetTime;
		}
	}
}