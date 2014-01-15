package
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.ModuleEvent;
	
	import spark.modules.ModuleLoader;
	
	
	public class StyleServiceAir extends StyleService
	{
		private var m_loader:URLDownloader2;
		private var m_styleUrlLoader:URLLoader; 
		private var m_styleModuleLoader:ModuleLoader; 
		
		public function StyleServiceAir(i_framework:IFramework, i_requestFontList:Boolean)
		{
			super(i_framework, i_requestFontList);
		}
		
		protected override function get styleUrl():String
		{
			return "app-storage:/"+m_currentUrl;
		}
		
		
		protected override function loadStyle():void
		{ 
			var file:File = File.applicationStorageDirectory.resolvePath(m_currentUrl);
			var fileExists:Boolean = false;
			if (file.exists)
			{
				if (m_currentOverride)
				{
					file.deleteFile();
				}
				else
				{
					fileExists = true;
				}
			}
			
			if (fileExists)
			{
				doStyleLoad();
			}
			else
			{
				var masterUrl:String = m_framework.StateBroker.GetState("MasterUrl") as String;
				m_loader = new URLDownloader2(masterUrl, File.applicationStorageDirectory.nativePath, m_currentUrl);
				m_loader.addEventListener(URLDownloader2.DOWNLOADED, onDownload);
				m_loader.addEventListener(URLDownloader2.FAULT, onFail);
				m_loader.download();
			}
		} 
		
		private function onFail(i_event:Event):void
		{
			/*???
			AlertEx.showOk(
				UIComponent(m_framework.StateBroker.GetState("topWindow")),
				m_currentUrl, "Load style fail");
			*/
			if (m_loader!=null)
			{
				m_loader.download();
			}
		}
		
		private function onDownload(i_event:Event):void
		{
			doStyleLoad();
		}
		
		protected function doStyleLoad():void
		{
			m_styleUrlLoader = new URLLoader(); 
			m_styleModuleLoader = new ModuleLoader();
			m_styleModuleLoader.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
			m_styleModuleLoader.applicationDomain = m_framework.StateBroker.GetState("ApplicationDomain") as ApplicationDomain;
			
			
			m_styleModuleLoader.addEventListener(ModuleEvent.READY, onStyleModuleLoaderReady); 
			m_styleUrlLoader.addEventListener(Event.COMPLETE, onStyleLoaderComplete); 
			m_styleUrlLoader.dataFormat = URLLoaderDataFormat.BINARY; 
			m_styleUrlLoader.load(new URLRequest(styleUrl)); 
		}
		
		private function onStyleLoaderComplete(event:Event) : void 
		{ 
			m_styleUrlLoader.removeEventListener(Event.COMPLETE, onStyleLoaderComplete); 
			
			var moduleBytes : ByteArray = ByteArray(URLLoader(event.target).data); 
			
			m_styleModuleLoader.loadModule(styleUrl, moduleBytes); 
			
			m_styleUrlLoader = null; 
		} 
		
		private function onStyleModuleLoaderReady(event : ModuleEvent) : void 
		{ 
			// Now that the module is in the security domain it we can load from this url 
			loadStyleDeclarations();
		} 
	}
}