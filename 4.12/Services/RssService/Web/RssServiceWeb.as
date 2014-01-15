package
{
	public class RssServiceWeb extends RssService
	{
		private var m_masterServerUrl:String
		
		public function RssServiceWeb(i_masterServerUrl:String):void
		{
			m_masterServerUrl = i_masterServerUrl;
		}

		public override function createRssRequest(i_url:String, i_minValidTime:Number, i_maxValidTime:Number):IRssRequest
		{
			var rssRequest:IRssRequest = super.createRssRequest(i_url, i_minValidTime, i_maxValidTime);
			if (rssRequest==null)
			{
				m_RequestMap[i_url] = rssRequest = new RssRequestWeb(m_masterServerUrl, m_rssMap, i_url, i_minValidTime, i_maxValidTime); 
			}
			return rssRequest;
			
		}
		
	}
}