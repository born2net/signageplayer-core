package
{
	import flash.events.Event;

	public class RssEvent extends Event
	{
		public static const RSS_RESULT:String = "rss_result_event";
		private var m_rssRequest:IRssRequest;
		
		public function RssEvent(type:String, i_rssRequest:IRssRequest)
		{
			super(type);
			m_rssRequest = i_rssRequest;
		}
		
		public function get rssRequest():IRssRequest
		{
			return m_rssRequest;
		}
	}
}