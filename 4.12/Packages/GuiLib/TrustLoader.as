package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	public class TrustLoader extends UIComponent
	{
		private var m_source:String;
		private var m_invalidateSource:Boolean = false;
		private var m_loader:Loader;
		private var m_urlLoader:URLLoader;
		
		public function TrustLoader()
		{
			super();
		}

		public function get source():String
		{
			return m_source;
		}
		
		public function set source(i_source:String):void
		{
			m_source = i_source;
			m_invalidateSource = true;
			invalidateProperties();
		}
		
		public function get content():Object
		{
			if (m_loader!=null)
				return m_loader.content;
			return null;	
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
		}

		protected override function commitProperties():void
		{
			super.commitProperties();
			if (m_invalidateSource)
			{
				m_invalidateSource = false;
				if (m_source!=null)
				{
					m_urlLoader = new URLLoader();
					m_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					m_urlLoader.addEventListener( Event.COMPLETE, onGigyaLoaded );
					m_urlLoader.load( new URLRequest( m_source ) );
				}
			}
		}
		
		private function onGigyaLoaded( e : Event ) : void 
		{
			if (m_urlLoader==null)
				return;
			
			m_urlLoader.removeEventListener( Event.COMPLETE, onGigyaLoaded );
			m_urlLoader = null;
			
            m_loader = new Loader();
            
            var context : LoaderContext = new LoaderContext();
            
        	context["allowLoadBytesCodeExecution"] = true;
        
        	m_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onAppExecuted );
        	m_loader.loadBytes( ByteArray( ( e.currentTarget as URLLoader ).data ), context );
		}
		
		private function onAppExecuted( e : Event ) : void 
		{
			if (m_loader==null)
				return;
			
			m_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onAppExecuted );
			
            addChild(m_loader);
            invalidateDisplayList();
            
            dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (m_loader!=null)
			{
				if (m_loader.content!=null)
				{
		            m_loader.content.scaleX = unscaledWidth/m_loader.contentLoaderInfo.width;
		            m_loader.content.scaleY = unscaledHeight/m_loader.contentLoaderInfo.height;
				}
			}
			
		}
		
		public function unloadAndStop(i_invokeGarbageCollector:Boolean):void
		{
			if (m_urlLoader!=null)
			{
				m_urlLoader.removeEventListener( Event.COMPLETE, onGigyaLoaded );
				m_urlLoader = null;
			}
			
			if (m_loader!=null)
			{
				m_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onAppExecuted );
				
				if (contains(m_loader))
				{
					removeChild(m_loader);
				}
				
                if ("unloadAndStop" in m_loader)
                {
                    m_loader["unloadAndStop"](i_invokeGarbageCollector);
                }
				if (m_loader.content!=null && ("unloadAndStop" in m_loader.content))
                {
                    m_loader.content["unloadAndStop"](i_invokeGarbageCollector);
                }                
                else 
                {
                    m_loader.unload();
                }                    
				
				m_source = null;
				m_loader = null;
			}
		}
		
	}
}
