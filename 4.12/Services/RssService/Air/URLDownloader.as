package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	public class URLDownloader extends URLStream
	{
		public static var DOWNLOADED:String = "event_downloaded";
		
		private var m_resourceSource:String;
		private var m_resourceDest:String;
		private var m_fileStream:FileStream;
		
		public function URLDownloader(i_resourceSource:String, i_resourceDest:String)
		{
			super();
			m_resourceSource = i_resourceSource;
			m_resourceDest = i_resourceDest;
		}
		
		public function download():Boolean
		{
        	var file:File = new File(m_resourceDest);
        	m_fileStream = new FileStream();
        	try
        	{
        		m_fileStream.open(file, FileMode.WRITE);
        	}
        	catch(error:Error)
        	{
        		return false; // file is in use
        	}
			
			addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addEventListener(ProgressEvent.PROGRESS, onProgress);
			addEventListener(Event.COMPLETE, completeHandler);
			
			var request:URLRequest = new URLRequest(m_resourceSource);
			load(request);
			return true;
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			removeEventListener(ProgressEvent.PROGRESS, onProgress);
			removeEventListener(Event.COMPLETE, completeHandler);
        	m_fileStream.close();
        	m_fileStream = null;
		}
		
		private function onProgress(event:ProgressEvent):void
		{
        	var bytes:ByteArray = new ByteArray();
        	readBytes(bytes, 0, 0);
        	m_fileStream.writeBytes(bytes, 0, 0);
        	//trace("progress: "+bytes.length);
		}

		private function completeHandler(event:Event):void 
		{
			removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			removeEventListener(ProgressEvent.PROGRESS, onProgress);
			removeEventListener(Event.COMPLETE, completeHandler);
        	m_fileStream.close();
        	m_fileStream = null;
        	dispatchEvent( new Event(DOWNLOADED) );
    	}
    	
    	public override function close():void
    	{
    		if (connected)
    		{
    			super.close();	
    		}
    		if (m_fileStream!=null)
    		{
    			removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				removeEventListener(ProgressEvent.PROGRESS, onProgress);
				removeEventListener(Event.COMPLETE, completeHandler);
	        	m_fileStream.close();
	        	m_fileStream = null;
	     	}
    	}
	}
}
