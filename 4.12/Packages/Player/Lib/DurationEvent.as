package
{
	import flash.events.Event;

	public class DurationEvent extends Event
	{
		public static const CHANGED:String = "event_duration_changed";
		
		private var m_duration:Number;
		
		public function DurationEvent(type:String, i_duration:Number)
		{
			super(type, true);
			m_duration = i_duration;
		}
		
		public function get duration():Number
		{
			return  m_duration;
		}
	}
}