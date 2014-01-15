package
{
	public class RssService implements IRssService
	{
		protected var m_RequestMap:Object = new Object();
		protected var m_rssMap:Object = new Object();
		
		public function RssService()
		{
		}

		public function createRssRequest(i_url:String, i_minValidTime:Number, i_maxValidTime:Number):IRssRequest
		{
			return m_RequestMap[i_url];
		}		
	}
}