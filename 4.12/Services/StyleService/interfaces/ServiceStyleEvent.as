package
{
	import flash.events.Event;
	
	public class ServiceStyleEvent extends Event
	{
		private var m_url:String;
		private var m_percentage:Number;
		
		public static const COMPLETE:String = "event_complete";
		public static const PROGRESS:String = "event_progress";
		
		public function ServiceStyleEvent(i_type:String, i_url:String, i_percentage:Number)
		{
			super(i_type);
			m_url = i_url;
			m_percentage = i_percentage;
		}
		
		public function get url():String
		{
			return m_url;
		}

		public function get percentage():Number
		{
			return m_percentage;
		}
	}
}