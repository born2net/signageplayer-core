package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;
	import mx.rpc.events.FaultEvent;
	
	public class ResourceServiceAir extends ResourceService implements IResourceServiceAir
	{ 
		private var m_userDirectory:Boolean;
		private var m_debugLog:IDebugLog;
		private var m_resourceKeys:Object = new Object();
		private var m_fileQueue:Array = new Array();
		
		private var m_totalFiles:int = 0;
		private var m_goodDownloaded:int = 0;
		private var m_badDownloaded:int = 0;
		private var m_linux:Boolean = false;
		
		private var m_numOfLoading:int = 0;
		
		public function ResourceServiceAir(i_framework:IFramework, i_userDirectory:Boolean)
		{
			super(i_framework);
			m_userDirectory = i_userDirectory;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			m_linux = Capabilities.os=="Linux";
			
			deleteTempFiles(getLocalFolder(false));
			deleteTempFiles(getLocalFolder(true));
		} 
		
		
		public override function update():void
		{
			var keys:Array = m_dataBaseManager.table_resources.getAllPrimaryKeys();
			m_totalFiles = keys.length;
			updateCachingStatus();			
		}
		
		public override function isAir():Boolean
		{
			return true;
		}
		
		
		private function getLocalFolder(i_applicationDirectory:Boolean):File
		{
			var file:File = null;
			if (i_applicationDirectory)
			{
				file = File.applicationDirectory;
			}
			else
			{
				file = m_userDirectory ? File.userDirectory.resolvePath("SignagePlayer") : File.applicationStorageDirectory;  
			}

			file = file.resolvePath(m_businessDomain.substr(m_businessDomain.indexOf(".")+1)); 
			file = file.resolvePath("business" + m_businessId.toString());
			file = file.resolvePath("Resources");
			return file;
		}
		
		protected override function getPath(i_recResource:Rec_resource):String
		{
			var filePath:String = null;
			var file:File;
			try
			{
				if (i_recResource.native_id!=-1) 
				{
					var domain:String = m_businessDomain.substr(m_businessDomain.indexOf(".")+1);
					var relativePath:String = domain + "/business" + m_businessId.toString() + "/Resources";
					var fileName:String = i_recResource.native_id + "." + i_recResource.resource_type;
					var cachingItem:ICachingItem = cacheItem(relativePath, fileName, i_recResource.resource_date_modified, i_recResource.resource_id);
					filePath = cachingItem.source;
				} 
				else // before submit to server. (not for player)
				{
					file = m_loaderManager.getFileReference(i_recResource.resource_id) as File;
					filePath = file.nativePath;
				}
			}
			catch(e:Error)
			{
				/*M???
				Alert.show(
					e.message, "Resource service",
					Alert.OK,
					UIComponent(m_framework.StateBroker.GetState("topWindow")));	
				*/
			}

			return filePath;
		}
		
		public function isLocalResource(i_hResource:int):Boolean
		{
			var recResouce:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if (recResouce==null)
				return false;
			var dateModified:Number = recResouce.resource_date_modified;
			var fileName:String = recResouce.native_id + "." + recResouce.resource_type;
			var dir:File = getLocalFolder(false);
			var file:File = dir.resolvePath(fileName); 
			return file.exists;
		}
		
		
		public function makeLocalResources():void
		{
			if (m_numOfLoading>0)
				return;
			
			m_totalFiles = 0;
			m_goodDownloaded = 0;
			m_badDownloaded = 0;
			m_fileQueue = new Array();
			m_resourceKeys = new Object();
			
			var keys:Array = m_dataBaseManager.table_resources.getAllPrimaryKeys();
			for each(var hResource:int in keys)
			{
				load(hResource);
			}
			m_totalFiles = keys.length;
			updateCachingStatus();
		}
		
		private function updateCachingStatus():void
		{
			m_framework.StateBroker.SetState(this, "CachingStatus", [m_goodDownloaded, m_badDownloaded, m_totalFiles]);	
		}
		
		
		private function deleteTempFiles(i_directory:File):void
		{
			if (i_directory.exists) 
			{
				for each(var file:File in i_directory.getDirectoryListing())
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
				}
			}
		}
		
		
		public override function clearCaching():void
		{
			var dir:File
			try
			{
				dir = getLocalFolder(false);
				if (dir.exists)
				{
					dir.deleteDirectory(true);
				}
			}
			catch(error:Error)
			{
				//				
			}
			try
			{				
				dir = getLocalFolder(true);
				if (dir.exists)
				{
					dir.deleteDirectory(true);
				}
			}
			catch(error:Error)
			{
				//	
			}
		}
		
		private function load(i_hResource:int):void
		{
			var key:String = m_businessDomain + "." + i_hResource;
			if (m_resourceKeys[key]!=null)
				return;
			m_resourceKeys[key] = true;
			
			var recResouce:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			var dateModified:Number = recResouce.resource_date_modified;
			var fileName:String = recResouce.native_id + "." + recResouce.resource_type;
			var dir:File = getLocalFolder(recResouce.resource_module);
			var file:File = dir.resolvePath(fileName); 
			if (file.exists)
			{
				m_goodDownloaded++;
				return;
			}
			
			if (recResouce.resource_module)
			{
				m_fileQueue.unshift([dir.nativePath, fileName, i_hResource, dateModified]);
			}
			else
			{	
				m_fileQueue.push([dir.nativePath, fileName, i_hResource, dateModified]);
			}
			
			if (m_numOfLoading==0)
			{
				download();
			}
		}
		
		private function download():void
		{
			try
			{
				if (m_framework.StateBroker.GetState("internetConnection")!=true)
				{
					// no internet connection
					m_fileQueue = new Array();
				}

				
				var localAndFile:Array = m_fileQueue.shift();
				if (localAndFile!=null)
				{
					var resourceLocal:String = localAndFile[0];
					var fileName:String = localAndFile[1];
					var hResource:int = localAndFile[2];
					var dateModified:Number = localAndFile[3];
					
					var cachingItem:ICachingItem = cacheItem(resourceLocal, fileName, dateModified, hResource);
					m_numOfLoading++;
				}
			}
			catch(error:Error)  
			{
				/*M???
				Alert.show (
					"E1:"+error.message,
					"Resource serivce",
					Alert.OK,
					UIComponent(m_framework.StateBroker.GetState("topWindow")));
				*/
				m_badDownloaded++;
				updateCachingStatus();
				m_debugLog.addException(error);
				download(); // this is for Linux to continue loading other files. (Linux can not copy files for Application path) 
			}
		}
		
		public function getCachingItem(i_hResource:int):ICachingItem
		{
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if (recResource.native_id!=-1) 
			{
				var domain:String = m_businessDomain.substr(m_businessDomain.indexOf(".")+1);
				var relativePath:String = domain + "/business" + m_businessId.toString() + "/Resources";
				var fileName:String = recResource.native_id + "." + recResource.resource_type;
				return m_cachingService.getCachingItem(relativePath, fileName);
			} 
			return null;			
		}
		
		private function cacheItem(i_relativePath:String, i_fileName:String, i_dateModified:Number, i_hResource:int):ICachingItem
		{
			var cachingItem:ICachingItem = m_cachingService.getCachingItem(i_relativePath, i_fileName);
			cachingItem.addEventListener(Event.COMPLETE, onCachingItemComplete);
			cachingItem.addEventListener(IOErrorEvent.IO_ERROR, onCachingItemFail);
			cachingItem.expireDuration = 60 * 60 * 24 * 365; // 1 year
			cachingItem.url = m_resourceUrl + i_fileName;
			var version:String = i_dateModified.toString();
			var force:Boolean = (cachingItem.version != version);
			cachingItem.version = version;
			cachingItem.tag = i_hResource;
			cachingItem.cache(force);
			return cachingItem;
		}
		
		private function onCachingItemComplete(i_event:Event):void
		{
			i_event.target.removeEventListener(Event.COMPLETE, onCachingItemComplete);
			i_event.target.removeEventListener(IOErrorEvent.IO_ERROR, onCachingItemFail);
			
			m_goodDownloaded++;
			updateCachingStatus();
			
			var cachingItem:ICachingItem = ICachingItem(i_event.target);
			m_framework.EventBroker.dispatchEvent( new ResourceEvent(ResourceEvent.EVENT_RESOURCE_DOWNLOADED, cachingItem.tag) );
			
			download();
		}

		private function onCachingItemFail(i_event:Event):void
		{
			i_event.target.removeEventListener(Event.COMPLETE, onCachingItemComplete);
			i_event.target.removeEventListener(IOErrorEvent.IO_ERROR, onCachingItemFail);
			
			m_badDownloaded++;
			updateCachingStatus();
			//??? m_debugLog.addWarning(String(i_event.message.body));
			download();
		}
		
		public function dispose():void  // use when before start import data from USB. 
		{
		}
	}
}
