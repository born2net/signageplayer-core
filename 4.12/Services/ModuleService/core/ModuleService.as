package
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	
	import mx.collections.ArrayList;
	import mx.collections.XMLListCollection;
	import mx.core.UIComponent;
	import mx.messaging.events.MessageEvent;
	
	public class ModuleService extends EventDispatcher implements IModuleService
	{ 
		protected const MODULE_VER:String = "4.12";
		protected var m_moduleBasePath:String;
	
		
		protected var m_framework:IFramework;
		protected var m_debugLog:IDebugLog;
		
		protected var m_applicationDomain:ApplicationDomain;
		protected var m_debug:Boolean;
		
		protected var m_businessDomain:String;
		protected var m_version:String;
		protected var m_loadModules:Boolean;

		protected var m_loaderMap:Object;  // Singleton for all frameworks

		protected var m_modules:Object =  new Object();
		protected var m_pandingQueue:Array = new Array();
		
		
		protected var m_loadingCount:int = 0;
		
		protected var m_installedApps:XML;
		protected var m_allApps:Object = new Object();
		protected var m_timelineComponents:XML = <Root/>;
		protected var m_sceneComponents:XML = <Root/>;
		
		protected var m_mimeTypeMap:Object = new Object();
		protected var m_mimeTypeNames:Array = new Array();
		
		public function ModuleService(i_framework:IFramework, i_applicationDomain:ApplicationDomain, i_debug:Boolean)
		{
			m_framework = i_framework;
			m_applicationDomain = i_applicationDomain;
			m_debug = i_debug;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			
			m_moduleBasePath = MODULE_VER + "/" + "desktop";
			if (i_debug)
				m_moduleBasePath += "_d";			
			
			if (m_loaderMap==null) // create Singleton instance
			{
				m_loaderMap = new Object();
			}
		}
		
		
		public function setAppStoreList(i_appStoreList:XMLList):void
		{
			AppStore.appStoreList = i_appStoreList;
			for each(var xmlApp:XML in AppStore.appStoreList)
			{
				m_allApps[xmlApp.@id] = xmlApp;
			}			
		}
		
		
		public function get installedApps():XML
		{
			return m_installedApps;
		}
		
		
		public function registerAppList(i_installedApps:XML):void
		{
			m_installedApps = i_installedApps;
			for each(var xmlResellerApp:XML in i_installedApps.*)
			{
				registerApp(xmlResellerApp.@id, xmlResellerApp.@installed=="1");
			}
		}
		
		private function registerApp(i_appId:int, i_installed:Boolean):void
		{
			var xmlApp:XML = m_allApps[i_appId];
			if (xmlApp==null)
			{
				return;
			}
			xmlApp.@installed = i_installed ? "1" : "0";
			var xmlPlayer:XML;
			var xmlComponents:XML = xmlApp.Components[0];
			for each(var xmlComponent:XML in xmlComponents.*)
			{
				var moduleId:int = int(xmlComponent.@moduleId);
				if (m_modules[moduleId]!=null)
					return;
				
				 
				if (i_installed==true)
				{
					if (xmlComponent.@showInTimeline=="1")
					{
						xmlPlayer = <Player/>;
						xmlPlayer.@label = xmlComponent.@label;
						xmlPlayer.@player = xmlComponent.@moduleId;
						xmlPlayer.@iconName = "player" + xmlComponent.@moduleId +"Icon";
						m_timelineComponents.appendChild(xmlPlayer);
					}
					if (xmlComponent.@showInScene=="1")
					{
						xmlPlayer = <Player/>;
						xmlPlayer.@label = xmlComponent.@label;
						xmlPlayer.@player = xmlComponent.@moduleId;
						xmlPlayer.@iconName = "player" + xmlComponent.@moduleId +"Icon";
						m_sceneComponents.appendChild(xmlPlayer);
					}
				}
				
				var xmlModule:XML = <Module/>;
				xmlModule.@moduleId = xmlComponent.@moduleId;
				xmlModule.@moduleWeb = xmlComponent.@moduleWeb;
				xmlModule.@moduleAir = xmlComponent.@moduleAir;
				xmlModule.@moduleMobile = xmlComponent.@moduleMobile;
				xmlModule.@ver = xmlComponent.@version;
				xmlModule.@appStore = "1";
				ApplicationModules.Players.appendChild(xmlModule);
				
				m_modules[moduleId] = xmlModule;
				
				if (XMLList(xmlComponent.MimeTypes).length()>0)
				{
					for each(var xmlItem:XML in xmlComponent.MimeTypes.*)
					{
						
						var mimeType:String = xmlItem.@name;
						var providerType:String = null;
						if (XMLList(xmlItem.@providerType).length()>0)
						{
							providerType = String(xmlItem.@providerType);
							mimeType += "." + providerType;
						}
						
						var xmlMimeType:XML = <MimeType/>;
						xmlMimeType.@label = xmlItem.@label;
						xmlMimeType.@id = mimeType;
						
						xmlPlayer = <Player/>;
						xmlPlayer.@player = xmlComponent.@moduleId;
						xmlPlayer.@iconName = "player" + xmlComponent.@moduleId +"Icon";
						xmlPlayer.@label = xmlComponent.@label;
						xmlMimeType.appendChild(xmlPlayer);
						var xmlData:XML = <Data/>;
						xmlPlayer.appendChild(xmlData);

						var tag:String = xmlItem.@name;
						var xmlTag:XML = <A/>;
						xmlTag.setName(tag);
						xmlData.appendChild(xmlTag);
						if (providerType!=null)
						{
							xmlTag.@providerType = providerType;
						}
						
						m_mimeTypeMap[mimeType] = xmlMimeType;
						m_mimeTypeNames.push(mimeType);
					}
				}
			}				
			
		}
		
		public function installApp(i_appId:int):void
		{
			m_installedApps.appendChild(<App id={i_appId}/>);
			registerApp(i_appId, true);
			applyAllModules(ApplicationModules.Players);
		}
		
		
		public function setModules(i_applicationId:int, i_loadModules:Boolean):void
		{
			m_loadModules = i_loadModules;
			switch(i_applicationId)
			{
				case 1:
					applyAllModules(ApplicationModules.MediaSignage);
				break;

				case 2:
					applyAllModules(ApplicationModules.Customers);
					applyAllModules(ApplicationModules.Players);
				break;

				case 3:
					applyAllModules(ApplicationModules.Reseller);
					applyAllModules(ApplicationModules.Customers);
					applyAllModules(ApplicationModules.Players);
				break;

				case 4:
					applyAllModules(ApplicationModules.Players);
				break;
			}
		}

		private function applyAllModules(i_modules:XML):void
		{
			if (m_loadModules==false)
				return;
				
			for each(var xmlModule:XML in i_modules.*)
			{
				var moduleId:int = int(xmlModule.@moduleId);
				m_modules[moduleId] = xmlModule;

			} 
		}
		
		public function init(i_businessDomain:String, i_version:String):void
		{
			m_businessDomain = i_businessDomain;
			m_version = i_version;
		}
		
		protected function getUrlFromId(i_moduleId:int):String
		{
			var url:String = null;
			if (m_modules[i_moduleId]!=null)
			{
				//url = m_businessUrl + String(m_modules[i_moduleId].@moduleWeb) + "?ver="+m_version;
				url = "http://" + m_businessDomain + "/Code/Modules/" + m_moduleBasePath + "/" + String(m_modules[i_moduleId].@moduleWeb) + "?ver="+m_version;
				//Alert.show("url="+url);
			}
			else
			{
				//m_debugLog.addError("module "+i_moduleId.toString() + " does not exist");
				//M??? Alert.show("module "+i_moduleId.toString() + " does not exist");
			}

			return url;
		}
		
		
		
		//////////////////////////////////////////////
		
		
		
		
		protected function createLoader(i_moduleId:int):MyLoader
		{
			var loader:MyLoader = m_loaderMap[i_moduleId];
			if (loader==null)
			{
				var url:String = getUrlFromId(i_moduleId);
				if (url==null)
				{
					//m_debugLog.addError("Module "+i_moduleId.toString()+" does not exist");
					//M???Alert.show("Module "+i_moduleId.toString()+" does not exist");
					return null
				}
				
				var xmlModule:XML = m_modules[i_moduleId];
				var ver:String = m_moduleBasePath + "/" + xmlModule.@ver;
		        m_loaderMap[i_moduleId] = loader = new MyLoader(m_applicationDomain, m_businessDomain, this, url, ver);
				loader.moduleId = i_moduleId;
		        m_pandingQueue.push(loader);
			}
			
			return loader; 
		}
		
		
		protected function createResourceLoader(i_hResource:int, i_url:String, i_ver:String):MyLoader
		{
			var key:String = "resource"+i_hResource.toString();
			var loader:MyLoader = m_loaderMap[key];
			if (loader==null)
			{
				m_loaderMap[key] = loader = new MyLoader(m_applicationDomain, m_businessDomain, this, i_url, i_ver);
				loader.hResource = i_hResource;
			}
			
			
			
			return loader; 
		}
		
		
		public function attachChild(i_componentLoader:IComponentLoader, i_moduleId:int):void
		{
			var loader:MyLoader = createLoader(i_moduleId);
			if (loader!=null)
			{
				loader.attachChild(i_componentLoader)
			}
			loadNext();
		}
		
		public function dettachChild(i_componentLoader:IComponentLoader, i_moduleId:int):void
		{ 
			var loader:MyLoader = createLoader(i_moduleId);
			if (loader!=null)
			{
				loader.dettachChild(i_componentLoader);
			}
		}
		
		
		public function attachChildToResource(i_componentLoader:IComponentLoader, i_hResource:int, i_url:String, i_ver:String):void
		{
			var loader:MyLoader = createResourceLoader(i_hResource, i_url, i_ver);
			if (loader!=null)
			{
				loader.attachChild(i_componentLoader);
				loader.start();
			}			
		}
		
		public function dettachChildFromResource(i_componentLoader:IComponentLoader, i_hResource:int):void
		{ 
			var key:String = "resource"+i_hResource.toString();
			var loader:MyLoader = m_loaderMap[key];	
			if (loader!=null)
			{
				loader.dettachChild(i_componentLoader);
			}			
		}
		
		
		public function moduleReady(i_loader:MyLoader):void
		{
			var xmlBusiness:XML = m_modules[i_loader.moduleId];
			m_loadingCount--;
			loadNext();
		}
		
		private function loadNext():void
		{
			if (m_loadingCount>=1)  // can load up to 1 modules together.
				return;
				
			var loader:MyLoader = m_pandingQueue.pop();
			if (loader==null)
				return;
				
			m_loadingCount++;
				
			dispatchEvent( new MyModuleEvent(MyModuleEvent.MODULE_BEGIN_LOADING, loader.url) );
			
			loader.start();
		}
		
		
		public function getApps():XMLList
		{
			return AppStore.appStoreList;
		}
		
		public function getTimelineComponents():XML
		{
			return m_timelineComponents;
		}
		
		public function getSceneComponents():XML
		{
			return m_sceneComponents;
		}
		
		public function get mimeTypeNames():Array
		{
			return m_mimeTypeNames;
		}
		
		public function getMimeType(i_mimeTypeName:String):XML
		{
			return m_mimeTypeMap[i_mimeTypeName];
		}
		
		
		public function uncaughtErrorHandler(i_errorMessage:String, i_stackTrace:String):void
		{
			if (i_stackTrace!=null)
			{
				try
				{
					DebugLog(m_debugLog).setStackTrace(i_stackTrace);
				}
				catch(e:Error)
				{
					// Ignore
				}
			}
			m_debugLog.addError(i_errorMessage);
		}
	}
}

