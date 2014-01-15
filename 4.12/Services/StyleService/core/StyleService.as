package
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.StyleEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	public class StyleService extends EventDispatcher implements IStyleService
	{
		public static const SDK_VER:String = "4.6";
		
		
		protected var m_framework:IFramework;
		private var m_studioService:WebService;
		
		private static var m_urlMap:Object;  // Singleton for all frameworks 
		protected static var m_styleCompletes:Object = new Object();
		
		
		protected var m_loadingQueue:Array = new Array();
		
		public var m_baseUrl:String = "";
		protected var m_currentUrl:String = "";
		protected var m_currentUpdate:Boolean;
		protected var m_currentOverride:Boolean;

		protected var m_count:int = 0;
		protected var m_loading:Boolean = false;
		
		
		
		private var m_weatherList:XMLList;
		private var m_weatherMap:Object = new Object();
		
		private var m_fontFamilyList:Array = new Array();
		
		public function StyleService(i_framework:IFramework, i_requestFontList:Boolean)
		{
			m_framework = i_framework; 
			
			if (m_urlMap==null)  // create Singleton instance
			{
				m_urlMap = new Object();
			}
			
			
			if (i_requestFontList)
			{
				var masterServerUrl:String = m_framework.StateBroker.GetState("MasterServerUrl") as String;
				m_studioService = new WebService();
				m_studioService.useProxy = false;
				m_studioService.addEventListener(FaultEvent.FAULT, onWebServiceFault);
				m_studioService.loadWSDL(masterServerUrl+"StudioService.asmx?wsdl");
				m_studioService.RequestFontFamilyList.addEventListener("result", onFontFamilyList);
				m_studioService.RequestFontFamilyList();
			}
		}
		
		private function onWebServiceFault(event:FaultEvent):void
		{
		}
		
		private function onFontFamilyList(event:ResultEvent):void
		{
			var list:Array = String(event.result).split(",");
			var familyList:Array = new Array();
			for each(var family:String in list)
			{
				var fontFamily:Object = new Object();
				fontFamily.fontName = family;
				familyList.push(fontFamily);
			}
			
			m_fontFamilyList = familyList.sortOn("fontName");
			
			
			/*
			// Test load all Fonts
			var count:int = m_fontFamilyList.length;
			for(var i:int=0;i<count;i++)
			{
				var nm:Object = m_fontFamilyList[i]; 
				loadFont(nm.fontName);
			}
			*/
			
		}
		
		public function setWeathers(i_weatherList:XMLList):void
		{
			m_weatherList = i_weatherList;
			for each(var xmlWeather:XML in i_weatherList)
			{
				m_weatherMap[ int(xmlWeather.@id) ] = xmlWeather;
			}
		}
		
		public function load(i_url:String, i_update:Boolean, i_override:Boolean=false):void
		{
			if (m_urlMap[i_url]==null || i_override)
			{
				m_urlMap[i_url] = true;
				m_count++;
				m_loadingQueue.push([i_url, i_update, i_override]);
				loadNext();
			}
		}
		
		protected function get styleUrl():String
		{
			return m_baseUrl + m_currentUrl;
		}
		
		protected function loadNext():void
		{
			if (m_loading==false && m_count>0)
			{
				m_loading = true;
				var cssData:Array = m_loadingQueue.shift();
				m_currentUrl = cssData[0];
				m_currentUpdate = cssData[1];
				m_currentOverride = cssData[2];
				//trace("url: " + m_currentUrl + "  count="+m_count);
				loadStyle();
			}
		}
		
		protected function loadStyle():void
		{
			loadStyleDeclarations();
		}
		
		protected function loadStyleDeclarations():void
		{ 
			var applicationDomain:ApplicationDomain = m_framework.StateBroker.GetState("ApplicationDomain") as ApplicationDomain;
			var eventDispatcher:IEventDispatcher = FlexGlobals.topLevelApplication.styleManager.loadStyleDeclarations(styleUrl, m_currentUpdate, false, applicationDomain);
				
			
			m_styleCompletes[m_currentUrl] = false;
			eventDispatcher.addEventListener(StyleEvent.COMPLETE, onStyleComplete);
			eventDispatcher.addEventListener(StyleEvent.PROGRESS, onStyleProgress);
			eventDispatcher.addEventListener(StyleEvent.ERROR, onStyleError);
		}
		 
		public function isCompleted(i_url:String):Boolean
		{
			return (m_styleCompletes[i_url]==true);
		}
		
		public function allCompleted():Boolean
		{
			return (m_count==0);
		}
		
		private function onStyleError(event:StyleEvent):void
		{
			var eventDispatcher:IEventDispatcher = IEventDispatcher(event.target);
			removeEvents(eventDispatcher);
			AlertEx.showOk(
				UIComponent(m_framework.StateBroker.GetState("topWindow")),
				event.errorText, "StyleError");
		}
		
		private function onStyleProgress(event:StyleEvent):void
		{
			var percentage:Number = int(100*event.bytesLoaded/event.bytesTotal);
			dispatchEvent(new ServiceStyleEvent(ServiceStyleEvent.PROGRESS, m_currentUrl, percentage) );
		}
		
		private function onStyleComplete(event:StyleEvent):void
		{
			var eventDispatcher:IEventDispatcher = IEventDispatcher(event.target);
			removeEvents(eventDispatcher);
			m_loading = false;
			m_styleCompletes[m_currentUrl] = true;
			m_count--;
			dispatchEvent(new ServiceStyleEvent(ServiceStyleEvent.COMPLETE, m_currentUrl, 100) );
			loadNext();
		}
		
		private function removeEvents(i_eventDispatcher:IEventDispatcher):void
		{
			i_eventDispatcher.removeEventListener(StyleEvent.COMPLETE, onStyleComplete);
			i_eventDispatcher.removeEventListener(StyleEvent.PROGRESS, onStyleProgress);
			i_eventDispatcher.removeEventListener(StyleEvent.ERROR, onStyleError);
		}
		
		
		// Impliment IWeatherStyle
		
		public function get weatherList():XMLList
		{
			return m_weatherList;
		} 
		
		public function getWeatherCSS(i_weatherStyleId:int):CSSStyleDeclaration
		{
			var xmlWeather:XML = m_weatherMap[String(i_weatherStyleId)] as XML;
			if (xmlWeather==null)
				return null;
			load("Styles/" + SDK_VER + "/"+xmlWeather.@weatherSwf, false);
			return FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration(xmlWeather.@weatherClass);
		}
		
		public function loadFont(i_family:String):void
		{
			var swf:String = "Styles/" + SDK_VER + "/Fonts/Font_" + i_family.replace(/[ \-!•™&:.,()\[\]`']/g, "") + ".swf";
			
			load(swf, false);  //?? true
		}
		
		public function fontsCompleted(i_familyMap:Object):Boolean
		{
			for each(var family:String in i_familyMap)
			{
				var swf:String = "Styles/" + SDK_VER + "/Fonts/Font_" + family.replace(/[ -!•™&:.,()\[\]`']/g, "") + ".swf";
				if (isCompleted(swf)==false)
					return false;
			}
			return true;
		}
		
		public function get fontFamilyList():Array
		{
			return m_fontFamilyList;
		}
		
		public function createFontItem():IFontItem
		{
			var fontItem:FontItem = new FontItem(this);
			return fontItem;
		}
	}
}