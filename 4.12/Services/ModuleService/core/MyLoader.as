package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IFlexModuleFactory;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.ModuleEvent;

	//M??? import mx.modules.ModuleLoader;
	
	
	public class MyLoader extends Loader
	{
		protected var m_url:String;
		private var m_componentLoaderList:Dictionary;
		private var m_status:String = "None";
		private var m_factory:IFlexModuleFactory;
		
		private var m_applicationDomain:ApplicationDomain;
		private var m_moduleService:ModuleService;
		protected var m_moduleId:int = -1;
		protected var m_hResource:int = -1;
		
		
		
		protected var m_businessDomain:String;
		protected var m_version:String;
		

		
		public function MyLoader(i_applicationDomain:ApplicationDomain, i_businessDomain:String, i_moduleService:ModuleService, i_url:String, i_version:String)
		{
			super();
			m_applicationDomain = i_applicationDomain;
			m_businessDomain = i_businessDomain;
			m_moduleService = i_moduleService;
			m_url = i_url;
			m_version = i_version;
			m_componentLoaderList = new Dictionary(); 
		}
		
		public function get url():String
		{
			return m_url;
		}
		
		public function get moduleId():int
		{
			return m_moduleId;
		}
		
		public function set moduleId(i_moduleId:int):void
		{
			m_moduleId = i_moduleId;
		}	
		
		public function get hResource():int
		{
			return m_hResource;
		}
		
		public function set hResource(i_hResource:int):void
		{
			m_hResource = i_hResource;
		}		
		
		
		public function start():void
		{
			//trace("---start "+ m_moduleId);
			if (m_status=="None")
			{
				m_status="Loading";
				beginLoading();
				
				loadModule();
			} 
			else if (m_status=="Ready")
			{
				ready();
			}
		}
		
		
		
		
		
		protected function loadModule(i_moduleBytes:ByteArray=null):void
		{
			var securityDomain:SecurityDomain = null;
			
			var c:LoaderContext = new LoaderContext();
			
			c.applicationDomain = m_applicationDomain;
			
			c.securityDomain = securityDomain;
			if (securityDomain == null && Security.sandboxType == Security.REMOTE)
				c.securityDomain = SecurityDomain.currentDomain;
			
				
			
			// If the AIR flag is available then set it to true so we can
			// load the module without a security error.
			if ("allowLoadBytesCodeExecution" in c)
				c["allowLoadBytesCodeExecution"] = true;			
			
			
			
			
			contentLoaderInfo.addEventListener(
				Event.INIT, initHandler);
			contentLoaderInfo.addEventListener(
				ProgressEvent.PROGRESS, progressHandler);
			contentLoaderInfo.addEventListener(
				IOErrorEvent.IO_ERROR, errorHandler);
			contentLoaderInfo.addEventListener(
				SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			
			
			
			uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			
			
			if (i_moduleBytes!=null)
			{
				if ("allowLoadBytesCodeExecution" in c)
					c["allowLoadBytesCodeExecution"] = true;				
				loadBytes(i_moduleBytes, c);
			}
			else
			{
				var r:URLRequest = new URLRequest(m_url);
				load(r, c);
			}
			//trace("---load "+ m_moduleId);
			
		}
		
		
		public function attachChild(i_componentLoader:IComponentLoader):void
		{
			m_componentLoaderList[i_componentLoader] = i_componentLoader;
			if (m_status=="Ready")
			{
				ready();	
			}
		}
		
		public function dettachChild(i_componentLoader:IComponentLoader):void
		{
			delete m_componentLoaderList[i_componentLoader];
		}
		
		private function beginLoading():void
		{
			for each(var componentLoader:IComponentLoader in m_componentLoaderList)
			{
				if (componentLoader.enableProgress)
				{
					componentLoader.componentProgress = new ComponentProgress();
					IVisualElementContainer(componentLoader).addElement(IVisualElement(componentLoader.componentProgress));
				}
			}
		}
		
		
		private function progressHandler(event:ProgressEvent):void
		{
			for each(var componentLoader:IComponentLoader in m_componentLoaderList)
			{
				if (componentLoader.componentProgress!=null)
				{
					componentLoader.componentProgress.setProgress(event.bytesLoaded, event.bytesTotal);
				}
			}
		}
		
		private function initHandler(event:Event):void
		{
			m_status="init";
			
			//trace("---initHandler "+ m_moduleId);
			
			try
			{
				m_factory = contentLoaderInfo.content as IFlexModuleFactory;
			}
			catch(error:Error)
			{
				trace(error.message);
			}
			
			
			
			content.addEventListener(ModuleEvent.READY, onModuleReady);
			
			content.addEventListener(ModuleEvent.ERROR, onModuleError);
		}
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if ((event.error is SecurityError))
			{
				trace("MyLoader: SecurityError");
				event.preventDefault();
				return;
			}
			
			
			var errorMessage:String = "Error: ";
			var stackTrace:String = null;
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				
				
				if (error.errorID==2099) 	// The loading object is not sufficiently loaded to provide this information
				{
					event.preventDefault();
					return;
				}
				
				if (error.errorID==2036)  // Load Never Completed
				{
					// I saw it happend when icons on timeline never finish to load
					// but It might be call on other cases 
					// so not sure if I need to call event.preventDefault();
					// and prevent the re-try in other places
					return;    
				}

				
				try
				{
					stackTrace = error.getStackTrace();
				}
				catch(e:Error)
				{
					//Ignore
				}				
				
				errorMessage += error.message;
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				
				if (errorEvent is IOErrorEvent) 
				{
					event.preventDefault();
					return;
				}
				
				errorMessage += errorEvent.text;
			}
			else if (event.error is String)
			{
				errorMessage += String(event.error);
			}
			else
			{
				// a non-Error, non-ErrorEvent type was thrown and uncaught
			}
			
			if (errorMessage!=null)
			{
				try
				{
					m_moduleService.uncaughtErrorHandler(errorMessage, stackTrace);
				}
				catch(e1:Error)
				{
					// Ignore
				}
			}
		}
		
		protected function onModuleError(event:ModuleEvent) : void
		{
			content.removeEventListener(ModuleEvent.READY, onModuleReady);
			removeAllEvents();	
		}		
		

		
		
		private function onModuleReady(event:Event):void
		{
			//trace("---readyHandler "+ m_moduleId);
			content.removeEventListener(ModuleEvent.READY, onModuleReady);
			removeAllEvents();
			
			for each(var componentLoader:IComponentLoader in m_componentLoaderList)
			{
				if (componentLoader.componentProgress!=null)
				{
					componentLoader.componentProgress.setProgress(contentLoaderInfo.bytesLoaded, contentLoaderInfo.bytesTotal);
					IVisualElementContainer(componentLoader).removeElement(IVisualElement(componentLoader.componentProgress));
					componentLoader.componentProgress = null;
				}
			}
			
			ready();
		}
		
		protected function getModuleClass(i_componentLoader:ComponentLoader):String
		{
			var moduleClass:String = i_componentLoader.moduleClass;
			return moduleClass;
		}
		
		private function ready():void
		{
			m_status="Ready";
			for each(var componentLoader:IComponentLoader in m_componentLoaderList)
			{
				var uiComponent:UIComponent;
				var moduleClass:String = getModuleClass(ComponentLoader(componentLoader));
				if (moduleClass==null || moduleClass=="")
				{
					var a:Object = m_factory.create();
					uiComponent = a as UIComponent;
				}
				else
				{
					var definition:Class = getDefinitionByName(moduleClass) as Class;
					if (definition!=null)
					{
						var classFactory:ClassFactory = new ClassFactory(definition);
						uiComponent = classFactory.newInstance();
					}
				}
				
				uiComponent.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
				
				var componentModule:IComponentModule = uiComponent as IComponentModule;
				IComponentModule(uiComponent).framework = componentLoader.framework;
				IComponentModule(uiComponent).params = ComponentLoader(componentLoader).data;
				
				componentLoader.ready(uiComponent);
			}
			
			m_componentLoaderList = new Dictionary();
			
			if (m_moduleId!=-1)
			{
				m_moduleService.moduleReady(this);
			}
		}
		
		public function getDefinitionByName(name:String):Object
		{
			//const domain:ApplicationDomain =	m_factory.info()["currentDomain"] as ApplicationDomain; 
			
			var definition:Object;
			if (m_applicationDomain.hasDefinition(name))
				definition = m_applicationDomain.getDefinition(name);
			
			return definition;
		}
		
		private function errorHandler(event:ErrorEvent):void
		{
			//M??? Alert.show("Error in loading module "+ m_moduleId);
			removeAllEvents();
			
			for each(var componentLoader:IComponentLoader in m_componentLoaderList)
			{
				componentLoader.error(event.text);
			}
		}
		
		private function removeAllEvents():void
		{
			contentLoaderInfo.removeEventListener(
				Event.INIT, initHandler);
			contentLoaderInfo.removeEventListener(
				ProgressEvent.PROGRESS, progressHandler);
			contentLoaderInfo.removeEventListener(
				IOErrorEvent.IO_ERROR, errorHandler);
			contentLoaderInfo.removeEventListener(
				SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			
		}
	}
}