package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class PostService extends EventDispatcher
	{
		private var m_url:String;
		private var m_functionName:String;
		private var m_params:Array;
		private var m_args:Array;
		private var m_timer:Timer;
		private var m_retryCount:int = 0;
		private var m_retryDuration:Number = 5;
		
		
		public function PostService(i_url:String, i_functionName:String, ... i_params)
		{
			m_url = i_url;
			m_functionName = i_functionName;
			m_params = i_params;
		}
		
		public function call(... i_args):void
		{
			m_retryCount = 1;
			m_args = i_args;
			postNow();
		}
		
		public function callAndRetry(... i_args):void
		{
			m_retryCount = 12;
			m_retryDuration = 5;
			m_args = i_args;
			postNow();
		}		
		
		public function post(i_delay:Number):void
		{
			m_retryCount = 1;
			delayPost(i_delay);
		}
		
		private function delayPost(i_delay:Number):void
		{
			if (m_timer!=null)
				return;
			m_timer = new Timer(1000 * i_delay, 1);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onPostTimer);
			m_timer.start();
		}
		
		private function onPostTimer(event:TimerEvent):void
		{
			if (m_timer!=null)
			{
				m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onPostTimer);
				m_timer = null;
				postNow();	
			}
		}
		
 		public function postNow():void
        {
			m_retryCount--;
        	if (m_args==null || m_params.length!=m_args.length)
        		return;
	        var loader:URLLoader = new URLLoader();
	        loader.addEventListener(Event.COMPLETE, onCallCompleted);
	        loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
	         
	        var request:String = m_url+ "/" + m_functionName;
	        var _vars:URLVariables = new URLVariables(); 
			for (var i:uint = 0; i < m_params.length; i++)
		    {
		    	_vars[m_params[i]] = m_args[i];
		    }
		    
	        var urlRequest:URLRequest = new URLRequest(request);
	        urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = _vars; 
	        loader.load(urlRequest);
        }
        
		
		private function clearPost(i_loader:URLLoader):void
		{
			try
			{
				i_loader.removeEventListener(Event.COMPLETE, onCallCompleted);
				i_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				i_loader.close()
			}
			catch(e:Error)
			{
				// Ignore
				trace(e.message);
			}
		}
		
        private function onCallCompleted(event:Event):void
        {
			var loader:URLLoader = event.target as URLLoader;
			if (loader!=null && loader.data!=null)
			{
				try
				{
					var result:XML = new XML(loader.data);
					clearPost(loader);
					dispatchEvent( new ResultEvent(ResultEvent.RESULT, false, true, result) );
					return;
				}
				catch(e:Error)
				{
					// Invalid XML value
				}
			}
			
			// there was issue with the data
			if (m_retryCount==0)
			{
				dispatchEvent( new FaultEvent(FaultEvent.FAULT, false, true, null) );
			}
			else
			{
				post(m_retryDuration);
			}
        }
        
        private function onError(event:IOErrorEvent):void
        {
			var loader:URLLoader = event.target as URLLoader;
			clearPost(loader);
			
			if (m_retryCount==0)
			{
        		dispatchEvent( new FaultEvent(FaultEvent.FAULT, false, true, null) );
			}
			else
			{
				post(m_retryDuration);
			}
        }
	}
}
