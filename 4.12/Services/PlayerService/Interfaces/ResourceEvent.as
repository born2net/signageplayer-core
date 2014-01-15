package
{
	import flash.events.Event;

	public class ResourceEvent extends Event
	{
		public static const EVENT_RESOURCE_MONIFIED:String = "event_resource_modified";
		public static const EVENT_RESOURCE_DOWNLOADED:String = "event_resource_downloaded";
		
		
		private var m_hResource:int = -1;
		
		
		public function ResourceEvent(type:String, i_hResource:int)
		{
			super(type); 
			m_hResource = i_hResource;
		}

		public function get hResource():int
		{
			return m_hResource;			
		}
	}
}