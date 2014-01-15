package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.events.ModuleEvent;
	
	
	public class MyLoaderAir extends MyLoader 
	{
		private var m_framework:IFramework;
		private var m_downloader:URLDownloader2;
		private var m_binaryLoader:URLLoader;
		private var m_modulePath:String;
		 
		
		public function MyLoaderAir(i_framework:IFramework, i_applicationDomain:ApplicationDomain, i_businessDomain:String, i_moduleService:ModuleService, i_url:String, i_version:String)
		{
			super(i_applicationDomain, i_businessDomain, i_moduleService, i_url, i_version);
			m_framework = i_framework;
			m_modulePath = i_url;
			
			m_url =  i_url;
		}
		
		protected override function loadModule(i_moduleBytes:ByteArray=null):void
		{
			downloadModule();
		} 
		
		protected override function getModuleClass(i_componentLoader:ComponentLoader):String
		{
			var moduleClass:String = null;
			try
			{
				moduleClass = i_componentLoader.moduleClassAir;
			}
			catch(error:Error)
			{
				// Ignore
			}
			if (moduleClass==null)
			{
				moduleClass = super.getModuleClass(i_componentLoader);
			}
			return moduleClass;
		}
		
		protected function downloadModule():void
		{ 
			var path:String = "app-storage:/";
			var i:int;
			var domain:String;
			if (m_moduleId==-1)
			{
				i = m_businessDomain.lastIndexOf('.');
				i = m_businessDomain.lastIndexOf('.', i-1);
				domain = m_businessDomain.substr(i+1);
				path += domain + "/";
			}
			m_url = path + m_url;
			
			var file:File = new File(m_url);
			
			var download:Boolean = false;
			if (file.exists)
			{
				var modulesSharedObject:SharedObject = SharedObject.getLocal("modules", "/", false);
				var moduleKey:String = "module"+m_moduleId;
				var moduleData:Object = modulesSharedObject.data[moduleKey];
				if (moduleData==null || moduleData.ver!=m_version)
				{
					download = true;
				}
				
				
			}
			else
			{
				download = true;
			}
			
			if (m_version=="force")
			{
				download = true; 
			}
			else if (m_version=="ignore")
			{
				download = false;
			} 
			
			 
			if (download)
			{
				var moduleUrl:String = (m_moduleId!=-1) ? "http://" + m_businessDomain + "/Code/" : "http://" + m_businessDomain + "/Resources/";
				var destPath:String = File.applicationStorageDirectory.nativePath;
				if (m_moduleId==-1)
				{
					i = m_businessDomain.lastIndexOf('.');
					i = m_businessDomain.lastIndexOf('.', i-1);
					domain = m_businessDomain.substr(i+1);
					destPath += "/" + domain;
				}
				//AlertEx.showOk(moduleUrl+"\n"+destPath+"\n"+m_modulePath);
				m_downloader = new URLDownloader2(moduleUrl, destPath, m_modulePath);
				m_downloader.addEventListener(URLDownloader2.DOWNLOADED, onDownload);
				m_downloader.addEventListener(URLDownloader2.FAULT, onFail);
				m_downloader.download();
			}
			else
			{
				loadBinary();
			}
		} 		
		
		private function onDownload(i_event:Event):void
		{
			var modulesSharedObject:SharedObject = SharedObject.getLocal("modules", "/", false);
			var moduleKey:String = "module"+m_moduleId;
			var moduleData:Object = new Object();
			moduleData.ver = m_version;
			modulesSharedObject.data[moduleKey] = moduleData;
			modulesSharedObject.flush();
			
			loadBinary();
		}
		
		private function onFail(i_event:Event):void
		{
			/*
			AlertEx.showOk(
				UIComponent(m_framework.StateBroker.GetState("topWindow")),
				"Can't fine url:\n"+m_url, "Download fail2");
			*/
			
			if (m_downloader!=null)
			{
				m_downloader.download();
			}
		}		
		
		private function loadBinary():void
		{
			m_binaryLoader = new URLLoader(); 
			m_binaryLoader.addEventListener(Event.COMPLETE, onLoadBinaryComplete);
			m_binaryLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadBinaryFail);
			
			m_binaryLoader.dataFormat = URLLoaderDataFormat.BINARY; 
			m_binaryLoader.load(new URLRequest(m_url)); 		
		}
		
		private function onLoadBinaryComplete(event:Event) : void 
		{ 
			m_binaryLoader.removeEventListener(Event.COMPLETE, onLoadBinaryComplete); 
			
			var moduleBytes : ByteArray = ByteArray(URLLoader(event.target).data); 
			
			super.loadModule(moduleBytes); 
			
			m_binaryLoader = null; 
		} 
		
		private function onLoadBinaryFail(event:Event):void
		{
			
		}
		
		protected override function onModuleError(event:ModuleEvent) : void
		{
			super.onModuleError(event);
			AlertEx.showOk(
				UIComponent(m_framework.StateBroker.GetState("topWindow")),
				m_modulePath+"\n"+event.errorText, "onModuleError");
		}		
		
	}
}