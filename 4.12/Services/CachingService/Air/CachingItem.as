package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public class CachingItem extends EventDispatcher implements ICachingItem
	{
		private var m_cachingService:ICachingService;
		private var m_relativePath:String;
		private var m_fileName:String;
		private var m_type:String = null;
		
		private var m_url:String;
		private var m_expireDuration:Number = NaN;  // Seconds  (NaN - never expier)
		private var m_version:String = "";
		private var m_size:Number = 0;
		private var m_tag:int;
		
		private var m_lastDownloadTime:Number = NaN;
		private var m_expirationTime:Number = NaN; // Seconds (NaN - never expier)
		
	
		
		
		private var m_filePath:String;
		private var m_cachedFile:File;
		private var m_tmpFile:File;
		private var m_requiredFileOverride:Boolean = false;
		
		private var m_urlStream:URLStream;
		private var m_fileStream:FileStream;
		
		private var m_requestFreeStorage:Boolean = false;
		
		
		public function CachingItem(i_cachingService:ICachingService, i_relativePath:String = null, i_fileName:String = null)
		{
			m_cachingService = i_cachingService;
			m_relativePath = i_relativePath;
			m_fileName = i_fileName;
			
			if (m_relativePath!=null && m_fileName!=null)
			{
				updateFilePath();
			}
		}
		
		private function updateFilePath():void
		{
			if (CachingServiceAir(m_cachingService).userDirectory)
			{
				m_filePath = "file://" + File.userDirectory.resolvePath("SignagePlayer").resolvePath(m_relativePath).resolvePath(m_fileName).nativePath;
			}
			else
			{
				m_filePath = "app-storage:/" + m_relativePath + "/" + m_fileName;
			}
		}
		
		public static function getKey(i_relativePath:String, i_fileName:String):String
		{
			return i_relativePath + "/" + i_fileName;
		}
		
		public function get key():String
		{
			return m_relativePath + "/" + m_fileName;
		}	
		
		public function get url():String
		{
			return m_url;
		}
		
		public function set url(i_url:String):void
		{
			m_url = i_url;
		}
		
		
		public function get size():Number
		{
			return m_size;
		}
		
		public function set size(i_size:Number):void
		{
			m_size = i_size;
		}
		
		public function get cached():Boolean
		{
			return (m_cachedFile!=null && m_cachedFile.exists);
		}

		
		public function get expireDuration():Number
		{
			return m_expireDuration;
		}
		
		public function set expireDuration(i_expireDuration:Number):void
		{
			m_expireDuration = i_expireDuration;
			updateExpirationTime();
		}
		
		
		public function get version():String
		{
			return m_version;
		}
		
		public function set version(i_version:String):void
		{
			m_version = i_version;
		}
		
		
		public function get tag():int
		{
			return m_tag;
		}
		
		public function set tag(i_tag:int):void
		{
			m_tag = i_tag
		}
		
		public function load(i_xmlCachingItem:XML):void
		{
			m_url = i_xmlCachingItem.@url;
			m_relativePath = i_xmlCachingItem.@relativePath;
			m_fileName = i_xmlCachingItem.@fileName;
			m_expireDuration = i_xmlCachingItem.@expireDuration;
			m_version = i_xmlCachingItem.@version;
			m_size = Number(i_xmlCachingItem.@size);
			
			m_expirationTime = i_xmlCachingItem.@expirationTime;
			m_lastDownloadTime = i_xmlCachingItem.@lastDownloadTime;
			updateFilePath();
		}
		
		public function save():XML
		{
			var xmlCachingItem:XML = <CachingItem/>;
			xmlCachingItem.@url = m_url;
			xmlCachingItem.@relativePath = m_relativePath;
			xmlCachingItem.@fileName = m_fileName;
			xmlCachingItem.@expireDuration = m_expireDuration;
			xmlCachingItem.@version = m_version;
			xmlCachingItem.@size = m_size;
				
			xmlCachingItem.@expirationTime = m_expirationTime;
			xmlCachingItem.@lastDownloadTime = m_lastDownloadTime;
			return xmlCachingItem;	
		}
		
		public function updateExpirationTime():void
		{
			var expirationTime:Number = m_expirationTime;
			
			if (isNaN(m_expireDuration))
			{
				m_expirationTime = NaN;
			}
			else
			{
				var lastRequestTime:Number = Math.floor( (new Date()).time / 1000 );
				m_expirationTime = lastRequestTime + m_expireDuration;
			}
			
			if (expirationTime!=m_expireDuration)
			{
				CachingServiceAir(m_cachingService).saveRequired = true;
			}
		}
		
		public function get expired():Boolean
		{
			if (isNaN(m_expirationTime))
				return false;
			
			var now:Number = Math.floor( (new Date().time) / 1000 );
			return now>m_expirationTime;
		}
		
		public function get lastDownload():Number
		{
			if (isNaN(m_lastDownloadTime))
				return NaN;
			var now:Number = new Date().time / 1000;
			return now - m_lastDownloadTime;
		}
		
		
		
		public function cache(i_force:Boolean = false):Boolean
		{
			updateExpirationTime();
			
			
			m_cachedFile = new File(m_filePath);
			if (m_cachedFile.exists)
			{
				if (i_force==false)
				{
					return true;
				}
			}
			
			
			if (m_requiredFileOverride)
			{
				try
				{
					m_tmpFile.moveTo(m_cachedFile, true);
					m_tmpFile = null;
					m_requiredFileOverride = false;
					return true;
				}
				catch(e3:Error)
				{
					return false;
				}
				
			}

			if (m_tmpFile!=null) // still downloading
				return false;

			
			cleanDownload();
			
			try
			{
				m_tmpFile = new File(m_filePath + ".tmp");
				m_fileStream = new FileStream();
				m_fileStream.open(m_tmpFile, FileMode.WRITE);
				m_urlStream = new URLStream();
				m_urlStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				m_urlStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
				m_urlStream.addEventListener(Event.COMPLETE, completeHandler);
				var request:URLRequest = new URLRequest(m_url);
				m_urlStream.load(request);
				m_requestFreeStorage = true;
			}
			catch(e:Error)
			{
				cleanDownload();
			}
			
			return false;
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			cleanDownload();
			//??? dispatchEvent( event.clone() );
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			try
			{
				if (m_requestFreeStorage)
				{
					m_requestFreeStorage = false;
					CachingServiceAir(m_cachingService).freeStorage(event.bytesTotal);
				}
				
					
				var bytes:ByteArray = new ByteArray();
				m_urlStream.readBytes(bytes, 0, 0);
				m_fileStream.writeBytes(bytes, 0, 0);
				
				dispatchEvent( event.clone() );
			}
			catch(e1:Error)
			{
				cleanDownload();
			}
		}
		
		private function completeHandler(event:Event):void 
		{
			if (m_fileStream!=null)
			{
				try
				{
					m_size = m_fileStream.position;
					m_fileStream.close();
				}
				catch(e1:Error)
				{
					
				}
				m_fileStream = null;
			}
			if (m_urlStream!=null)
			{
				m_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				m_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				m_urlStream.removeEventListener(Event.COMPLETE, completeHandler);
				try
				{
					m_urlStream.close();
				}
				catch(e2:Error)
				{
					
				}
			}
			
			try
			{
				m_tmpFile.moveTo(m_cachedFile, true);
				m_tmpFile = null;	
			}
			catch(e3:Error)
			{
				m_requiredFileOverride = true;
			}
			
			
			
			
			m_lastDownloadTime = Math.floor( (new Date().time) / 1000 );
			
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		
		public function get source():String
		{
			return cache() ? m_filePath : m_url;
		}
		
		
		public function get type():String
		{
			if (m_type==null && m_fileName!=null)
			{
				var ar:Array = m_fileName.split(".");
				m_type =  ar[1];
			}
			
			return m_type;
		}
		
		
		public function get data():String
		{
			if (cache()==false)
				return null;
			
			if (m_cachedFile.exists==false)
				return null;
			
			var stream:FileStream = new FileStream();
			stream.open(m_cachedFile, FileMode.READ);
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			str = str.replace(File.lineEnding, "\n");
			return str;
		}
		
		private function cleanDownload():void
		{
			if (m_fileStream!=null)
			{
				try
				{
					m_fileStream.close();
				}
				catch(e1:Error)
				{
					
				}
				m_fileStream = null;
			}
			if (m_urlStream!=null)
			{
				m_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				m_urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				m_urlStream.removeEventListener(Event.COMPLETE, completeHandler);
				try
				{
					m_urlStream.close();
				}
				catch(e2:Error)
				{
					
				}
			}
			
			try
			{
				if (m_tmpFile!=null && m_tmpFile.exists)
				{
					m_tmpFile.deleteFile();
				}
				m_tmpFile = null;
			}
			catch(e1:Error)
			{
				
			}
			m_requiredFileOverride = false;
		}
		
		public function remove():void
		{
			cleanDownload();
			
			try
			{
				if (m_cachedFile==null)
				{
					m_cachedFile = new File(m_filePath);
				}
				if (m_cachedFile.exists)
				{
					m_cachedFile.deleteFile();
				}
				m_cachedFile = null;
			}
			catch(e1:Error)
			{
				
			}
		}
	}
}
