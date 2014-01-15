package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class RssRequestAir extends RssRequest
	{
		private var m_rssServiceAir:RssServiceAir;
		private var m_dateMap:Object;
		private var m_urlLoader:URLLoader;

		private var m_dwonloadQueue:Array = new Array();
		private var m_downloader:URLDownloader = null;
		private var m_title:String;		
		private var m_mediaDest:File;
		private var m_loadedRssItem:RssItemAir;
		
		public function RssRequestAir(i_rssServiceAir:RssServiceAir, i_rssMap:Object, i_url:String, i_minValidTime:Number, i_maxValidTime:Number)
		{
			super(i_rssMap, i_url, i_minValidTime, i_maxValidTime);
			m_rssServiceAir = i_rssServiceAir;
			m_urlLoader = new URLLoader();
			m_urlLoader.addEventListener(Event.COMPLETE, onCompleted);
			m_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			m_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);				
		}
		
		protected override function updateRssMap(i_key:String, i_rssData:RssData):void
		{
			super.updateRssMap(i_key, i_rssData);
			m_rssServiceAir.saveRequired = true;
		}
		
		
		private function onError(event:IOErrorEvent):void
		{
			onResult(null);
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			onResult(null);
		}
		
		protected override function requestRss(i_url:String):void
		{
			m_urlLoader.load(new URLRequest(i_url));
		}

		private function onCompleted(event:Event):void
		{
			try
			{
				var result:XML = (event.target.data!=null) ? XML(event.target.data) : null;
				onResult(result);
			}
			catch(e:Error)
			{
				//
			}
		}
		
		protected override function createRssItem(i_xmlItem:XML):RssItem
		{
			return new RssItemAir(i_xmlItem, m_mediaDest, m_title);
		}
		
		
		protected override function populateItemList():void
		{
			m_mediaDest = File.applicationStorageDirectory.resolvePath("Rss");
			m_title = getTitle(m_result);
			m_mediaDest = m_mediaDest.resolvePath(m_title);
			
			super.populateItemList();
			

			if (m_itemList.length==0) // this is not XML result (maybe weather text)
				return;
			
			var oldList:Object = new Object();
			if (m_mediaDest.exists) 
			{
				for each(var file:File in m_mediaDest.getDirectoryListing())
				{
					var tmp:String = file.name.substr(file.name.length-4, 4);
					if (tmp==".tmp")
					{
						try
						{
							file.deleteFile();
						}
						catch(error:Error)
						{
							// File is in use.
							// Ignore
							trace(error.message);
						}
					} 
					else
					{	
						oldList[file.name] = file.name;
					}
				}
			}
			else
			{
				m_mediaDest.createDirectory();
			}

			
			for each(var rssItem:RssItemAir in m_itemList)
			{
				var filename:String = rssItem.getMediaFileName();
				if (filename==null)
					continue;
				if (oldList[filename]!=null)
				{
					delete oldList[filename];
				}
				else
				{
					m_dwonloadQueue.push(rssItem);
				}
			}
			// delete old files
			for each(filename in oldList)
			{
				try
				{
					var deleteFile:File = m_mediaDest.resolvePath(filename);
					deleteFile.deleteFile();
				}
				catch(e:Error)
				{
					//
				}		
			}			 	
			
			download();
		}

		
		private function getTitle(i_result:String):String
		{
			var title:String = XML(i_result).channel.title.toString();
			var myPattern:RegExp = /[\/~:|?&=.\-_() ]/g;
			return title.replace(myPattern, "");
		}
		
		private function download():void
		{
			try
			{
				m_loadedRssItem = m_dwonloadQueue.shift();
				if (m_loadedRssItem!=null)
				{
					var mediaFile:File = m_mediaDest.resolvePath(m_loadedRssItem.getMediaFileName()+".tmp");
					m_downloader = new URLDownloader(m_loadedRssItem.getMediaUrl(), mediaFile.nativePath);
					m_downloader.addEventListener(URLDownloader.DOWNLOADED, onVideoLoaded);
					m_downloader.download();
				}
			}
			catch(error:Error)  
			{
				download(); // this is for Linux to continue loading other files. (Linux can not copy files for Application path) 
			}
		}
		
		private function onVideoLoaded(event:Event):void
		{
			try
			{
				var file1:File = m_mediaDest.resolvePath(m_loadedRssItem.getMediaFileName()+".tmp");
				var file2:File = m_mediaDest.resolvePath(m_loadedRssItem.getMediaFileName());
				file1.moveTo(file2, true);
			}
			catch(error:Error)
			{
			
			}
			download();
		}   
	}
}
