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
	
	import mx.messaging.messages.AbstractMessage;
	import mx.rpc.events.FaultEvent;
	
	public class URLDownloader2 extends URLStream
	{
		public static var DOWNLOADED:String = "event_downloaded";
		public static var FAULT:String = FaultEvent.FAULT;
		
		private var m_resourceSource:String;
		private var m_resourceDest:String;
		private var m_fileName:String;
		private var m_fileStream:FileStream;
		
		public function URLDownloader2(i_resourceSource:String, i_resourceDest:String, i_fileName:String)
		{
			super();
			m_resourceSource = i_resourceSource;
			m_resourceDest = i_resourceDest;
			m_fileName = i_fileName;
			//trace("download: "+i_fileName);
		}
		
		public function download():void
		{
        	var file:File = new File(m_resourceDest+"/"+m_fileName+".tmp");
        	if (file.exists)
        	{
        		try
        		{
        			file.deleteFile();	
        		}
        		catch(e:Error)
        		{
        			trace("file is locked");
        			return;
        		}
        	}
        	
        	
        	m_fileStream = new FileStream();
        	m_fileStream.open(file, FileMode.WRITE);
			addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addEventListener(ProgressEvent.PROGRESS, onProgress);
			addEventListener(Event.COMPLETE, completeHandler);
			var request:URLRequest = new URLRequest(m_resourceSource+m_fileName);
			load(request);
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			removeEventListener(ProgressEvent.PROGRESS, onProgress);
			removeEventListener(Event.COMPLETE, completeHandler);
        	m_fileStream.close();
        	close();
			
			try
			{
				var file1:File = new File(m_resourceDest+"/"+m_fileName+".tmp");
				if (file1.exists)
				{
					file1.deleteFile();	
				}
			}
			catch(e:Error)
			{
				//
			}
			
			var faultEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT);
			faultEvent.message = new AbstractMessage();
			faultEvent.message.body = "Can not download file: '" + m_fileName + "'"; 
			dispatchEvent(faultEvent);
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
        	close();
        	try
        	{
				var file1:File = new File(m_resourceDest+"/"+m_fileName+".tmp");
				var file2:File = new File(m_resourceDest+"/"+m_fileName);
				file1.moveTo(file2, true);
        	}
			catch(error:Error)
			{
				var faultEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT);
				faultEvent.message = new AbstractMessage();
				faultEvent.message.body = "Can not move file: '" + m_fileName + "'"; 
				dispatchEvent(faultEvent);
				return;
			}        	
			
        	dispatchEvent( new Event(DOWNLOADED) );
    	}
    	
    	public function dispose():void
    	{
			removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			removeEventListener(ProgressEvent.PROGRESS, onProgress);
			removeEventListener(Event.COMPLETE, completeHandler);
			try
			{
				if (m_fileStream!=null)
				{
					m_fileStream.close();
					m_fileStream = null;	
				}
				close();
			}
			catch(error:Error)
			{
					
			}
    	}
	}
}
