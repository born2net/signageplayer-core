package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	import spark.primitives.Path;

	public class CachingServiceAir implements ICachingService
	{
		private var m_userDirectory:Boolean;
		private var m_cachingMap:Object;
		private var m_saveRequired:Boolean = false;
		
		
		public function CachingServiceAir(i_userDirectory:Boolean)
		{
			m_userDirectory = i_userDirectory;
		}
		
		public function get userDirectory():Boolean
		{
			return m_userDirectory;
		}
		
		public function set saveRequired(i_saveRequired:Boolean):void
		{
			m_saveRequired = i_saveRequired;
		}
		
		public function get saveRequired():Boolean
		{
			return m_saveRequired;
		}
		
		public function generateFileName(i_url:String):String
		{
			var i0:int = i_url.indexOf("://") + 3;
			var array:Array = i_url.split("?");
			var s1:String = array[0];
			
			var i1:int = s1.lastIndexOf("/");
			var i2:int = s1.lastIndexOf(".");
			var ext:String = (i1>i0 && i2>i1) ? s1.substr(i2) : "";
			var filename:String = s1.substr(0, s1.length-ext.length);
			if (array.length>1)
				filename += array[1];
			filename = filename.toLocaleLowerCase();
			var myPattern:RegExp = /[\/~:|?&=.\-_() ]/g;
			filename = filename.replace(myPattern, "");
			
			filename = filename + ext;
			
			return filename;
		}		
		
		public function getCachingItem(i_relativePath:String, i_fileName:String):ICachingItem
		{
			var key:String = CachingItem.getKey(i_relativePath, i_fileName);
			var cachedFile:CachingItem = m_cachingMap[key];
			if (cachedFile==null)
			{
				m_cachingMap[key] = cachedFile = new CachingItem(this, i_relativePath, i_fileName);
			}
			return cachedFile;
		}
		
		public function removeCachingItem(i_cachingItem:ICachingItem):Boolean
		{
			CachingItem(i_cachingItem).remove();
			delete m_cachingMap[CachingItem(i_cachingItem).key];
			return true;
		}
		
		
		public function load():void
		{
			m_cachingMap = new Object();
			var file:File = File.applicationStorageDirectory.resolvePath( "cachingMap.xml" );
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
				for each(var xmlCachingItem:XML in xmlData.*)
				{
					var cachingItem:CachingItem = new CachingItem(this);
					cachingItem.load(xmlCachingItem);
					m_cachingMap[cachingItem.key] = cachingItem;
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
			
			for(var key:String in m_cachingMap)
			{
				var cachedFile:CachingItem = m_cachingMap[key];
				if (cachedFile.expired==false)
				{
					var xmlCachingItem:XML = cachedFile.save();
					xmlData.appendChild(xmlCachingItem);
				}
				else
				{
					cachedFile.remove();
					delete m_cachingMap[key];
				}
			}
			
			try
			{
				var file:File = File.applicationStorageDirectory.resolvePath( "cachingMap.xml" );
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
			
			
			freeStorage(100000000);
		}
		
		
		public function freeStorage(i_requestSize:Number):void
		{
			var file:File = File.applicationStorageDirectory;
			if (file.spaceAvailable-i_requestSize>100000000) // >100M
				return;
			var needToFree:Number = 150000000 + i_requestSize;
			
			var items:Array = new Array();
			var item:Object;
			var cachedFile:CachingItem;
			
			for(var key:String in m_cachingMap)
			{
				cachedFile = m_cachingMap[key];
				item = new Object();
				item.key = key;
				item.lastDownload = cachedFile.lastDownload;
				items.push(item);
			}
			
			var totalRemoved:Number = 0;
			var sortItems:Array = items.sortOn("lastDownload");
			for(var i:int = sortItems.length-1; i>=0; i--)
			{
				item = items[i];
				cachedFile = m_cachingMap[item.key];
				if (cachedFile.cached && cachedFile.size>0)
				{
					totalRemoved += cachedFile.size;
					cachedFile.remove();
				}
				if (totalRemoved>needToFree) 
					break;
			}
		}
		
	}
}
