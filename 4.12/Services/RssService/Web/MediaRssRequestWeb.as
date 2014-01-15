package
{
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	import flash.events.EventDispatcher;
	
	public class MediaRssRequestWeb extends RssRequest
	{
		private var m_rssWebService:WebService = new WebService();
		
		public function MediaRssRequestWeb(i_masterServerUrl:String, i_rssMap:Object, i_url:String, i_minValidTime:Number, i_maxValidTime:Number)
		{
			super(i_rssMap, i_url, i_minValidTime, i_maxValidTime);
			
			m_rssWebService.useProxy = false; 
			m_rssWebService.addEventListener(FaultEvent.FAULT, onWebServiceFault);
			m_rssWebService.GetRss.addEventListener(ResultEvent.RESULT, onRss);
			m_rssWebService.loadWSDL(i_masterServerUrl+"RssService.asmx?wsdl");
			
		}
		
		protected override function requestRss(i_url:String):void
		{
			m_rssWebService.GetRss(i_url);	
		}

		private function onWebServiceFault(event:FaultEvent):void
		{
			onResult(null);
		}
		
		
		private function onRss(event:ResultEvent):void
		{
			var result:String = (event.result!=null) ? String(event.result) : null;
			onResult(result);
		}
	}
}