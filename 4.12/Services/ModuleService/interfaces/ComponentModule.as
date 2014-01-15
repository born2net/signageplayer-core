package
{
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	
	import spark.modules.Module;

	
	public class ComponentModule extends Module implements IComponentModule
	{
		protected var m_framework:IFramework;
		protected var m_autoDispose:Boolean = true;
		protected var m_disposed:Boolean = false;
		
		private var m_params:Object;
		
		public function ComponentModule()
		{
			moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
			super(); 
			percentHeight = 100;
			percentWidth = 100;
			minHeight=0;
			minWidth=0;
			addEventListener(FlexEvent.PREINITIALIZE, onPreInitialize);
		}
		
		public function get framework():IFramework
		{
			return m_framework;
		}
		
		
		public function set framework(i_framework:IFramework):void
		{
			m_framework = i_framework;
		}
		
		
		private function onPreInitialize(event:FlexEvent):void
		{
			initModule();
			
			if (m_autoDispose)
				addEventListener(FlexEvent.REMOVE, onRemove);
		}

		public function set params(i_params:Object):void
		{
			m_params = i_params;
		}
		
		public function get params():Object
		{
			return m_params;
		}
		
		public function initModule():void
		{
		}	
		
		private function onRemove(event:FlexEvent):void
		{
			dispose();
		}
		
		public function dispose():void
		{
			if (m_disposed==false)
			{
				m_disposed = true;
				removeEventListener(FlexEvent.PREINITIALIZE, onPreInitialize);
				if (m_autoDispose)
				{
					removeEventListener(FlexEvent.REMOVE, onRemove);
				}
				onDispose();
			}
		}
		
		protected function onDispose():void
		{
			removeAllElements();
		}
	}
}