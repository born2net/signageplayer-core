package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
		
	public class RssServiceAir extends RssService
	{
		private var m_saveRequired:Boolean = false;
		
		public function RssServiceAir()
		{
		}
		
		public function set saveRequired(i_saveRequired:Boolean):void
		{
			m_saveRequired = i_saveRequired;
		}
		
		public function get saveRequired():Boolean
		{
			return m_saveRequired;
		}
		

		public override function createRssRequest(i_url:String, i_minRefreshTime:Number, i_expiredTime:Number):IRssRequest
		{ 
			var rssRequest:IRssRequest = super.createRssRequest(i_url, i_minRefreshTime, i_expiredTime);
			if (rssRequest==null)
			{
				m_RequestMap[i_url] = rssRequest = new RssRequestAir(this, m_rssMap, i_url, i_minRefreshTime, i_expiredTime); 
			}
			return rssRequest;
		}
		
		public function load():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath( "rss_caching.xml" );
			if (file.exists==false)
				return;
			try
			{
				var stream:FileStream = new FileStream(); 
				stream.open( file, FileMode.READ );
				var strData:String = ""; 
				while(stream.bytesAvailable>0)
				{
					var length:int = Math.min(10000, stream.bytesAvailable);
					strData += stream.readUTFBytes(length);
				} 
				stream.close();
				var xmlData:XML = new XML(strData);
				for each(var xmlItem:XML in xmlData.*)
				{
					var key:String = xmlItem.@key;
					var expiredTime:Number = Number(xmlItem.@expiredTime);
					var data:XML = XML(xmlItem).children()[0];
					var createdDate:Date = new Date();
					createdDate.time = Number(xmlItem.@created);
					var rssData:RssData = new RssData(data.toString(), expiredTime, createdDate);
					m_rssMap[key] = rssData;
				}
			}
			catch(error:Error)
			{
				trace(error.message);
			}
		}
		
		public function save():void
		{
			if (m_saveRequired==false)
				return;
			m_saveRequired = false;

			
			var xmlData:XML = <Data/>;
			for(var key:String in m_rssMap)
			{
				var rssData:RssData = m_rssMap[key];
				if (rssData.liveTime<rssData.expiredTime)
				{
					var xmlItem:XML = <Item>{rssData.data}</Item>;
					xmlItem.@key = key;
					xmlItem.@expiredTime = rssData.expiredTime;
					xmlItem.@created = rssData.createdTime;
					xmlData.appendChild(xmlItem);
				}
			}
			try
			{
				var file:File = File.applicationStorageDirectory.resolvePath( "rss_caching.xml" );
				var stream:FileStream = new FileStream(); 
				stream.open( file, FileMode.WRITE ); 
				stream.writeUTFBytes(xmlData.toXMLString()); 
				stream.close();
			}
			catch(error:Error)
			{
				trace(error.message);
			}
			file = null;
			stream = null;						
		}
		
		/*
		public function freeStorage(i_requestSize:Number):void
		{
			var file:File = File.applicationStorageDirectory;
			if (file.spaceAvailable-i_requestSize>250000000) // >250M
				return;
			var needToFree:Number = 500000000 + i_requestSize;
			
			var items:Array = new Array();
			var item:Object;
			for(var key:String in m_rssMap)
			{
				var rssData:RssData = m_rssMap[key];
				item = new Object();
				item.key = key;
				item.liveTime = rssData.liveTime;
				items.push(item);
			}
			
			var totalRemoved:Number = 0;
			var sortItems:Array = items.sortOn("liveTime");
			for(var i:int = sortItems.length-1; i>=0; i--)
			{
				item = items[i];
				var rssData:RssData = m_rssMap[item.key];
				if (rssData.cached && rssData.size>0)
				{
					totalRemoved += rssData.size;
					rssData.remove();
				}
				if (totalRemoved>needToFree) 
					break;
			}
		}
		*/
	}
}
