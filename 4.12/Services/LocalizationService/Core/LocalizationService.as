package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	import mx.core.UIComponent;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	
	public class LocalizationService extends EventDispatcher implements ILocalizationService
	{
		public static const EVENT_LOCALIZATION_COMPLETE:String = "event_localization_complete";
		private var m_framework:IFramework;
		private var m_debugLog:IDebugLog;
		
		private var m_GetResourceBundles:PostService;
		
		private var m_bundleList:String;
		
		public function LocalizationService(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			
			var masterServerUrl:String = m_framework.StateBroker.GetState("MasterServerUrl") as String;
			
			m_GetResourceBundles = new PostService(masterServerUrl + "LocalizationService.asmx", "GetResourceBundles2", "i_local", "i_bundleList");
			m_GetResourceBundles.addEventListener(ResultEvent.RESULT, onResourceBundlesResult);
			m_GetResourceBundles.addEventListener(FaultEvent.FAULT, onResourceBundlesFault);
			
			ResourceManager.getInstance().localeChain = [local];
		}

		
		public function get local():String
		{
			var loginSharedObject:SharedObject = SharedObject.getLocal("localization", "/", false); 
			return (loginSharedObject.data.local==null) ? "en_US" : loginSharedObject.data.local; 
		}
		
		public function set local(i_local:String):void
		{
			var loginSharedObject:SharedObject = SharedObject.getLocal("localization", "/", false); 
			loginSharedObject.data.local = i_local; 
			loginSharedObject.flush();
			ResourceManager.getInstance().localeChain = [i_local];
			if (m_bundleList!=null)
			{
				m_GetResourceBundles.callAndRetry(local, m_bundleList);
			}
		}

		public function getResourceBundles(i_bundleList:String):void
		{
			m_bundleList = i_bundleList;
			m_GetResourceBundles.callAndRetry(local, i_bundleList);
		}	
		
		protected function onResourceBundlesResult(event:ResultEvent):void
		{
			var xmlResourceBundleList:XML = XML(event.result);
			for each(var xmlResourceBundle:XML in xmlResourceBundleList.*)
			{
				var resourceBundle:ResourceBundle = new ResourceBundle(String(xmlResourceBundle.@local), String(xmlResourceBundle.@bundleName));
				
				for each(var xmlString:XML in xmlResourceBundle.*)
				{
					resourceBundle.content[String(xmlString.@key)] = String(xmlString.@value);
				}
				ResourceManager.getInstance().addResourceBundle(resourceBundle);
			}
			ResourceManager.getInstance().update();
			
	    	dispatchEvent( new Event(EVENT_LOCALIZATION_COMPLETE) );
		}
		
		protected function onResourceBundlesFault(event:FaultEvent):void
		{
			AlertEx.showOk(UIComponent(m_framework.StateBroker.GetState("topWindow")), "onResourceBundlesFault", "LocalizationService");
		}
		
		
		public function localizeXml(i_bundleName:String, i_xml:XML, i_keyPrefix:String, i_keyField:String, i_labelField:String):void
		{
			if (m_bundleList==null)
				return;
				 
			var xmlItem:XML;	
			for each(xmlItem in i_xml.children())
			{
				var label:String = xmlItem[i_labelField];
				var keyString:String = i_keyPrefix+String(xmlItem[i_keyField]);
				var localLabel:String = ResourceManager.getInstance().getString(i_bundleName, keyString);
				xmlItem[i_labelField] = (localLabel!=null) ? localLabel : label;
				
				localizeXml(i_bundleName, xmlItem, i_keyPrefix, i_keyField, i_labelField);
			}
		}
	}
}