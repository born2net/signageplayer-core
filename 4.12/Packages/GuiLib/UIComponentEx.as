package
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class UIComponentEx extends UIComponent
	{
		protected var m_autoDispose:Boolean = true;
		protected var m_disposed:Boolean = false;
		
		public function UIComponentEx()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			if (m_autoDispose)
				addEventListener(FlexEvent.REMOVE, onRemove);
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
				if (m_autoDispose)
				{
					removeEventListener(FlexEvent.REMOVE, onDispose);
				}
				onDispose();
			}
		}
		
		protected function onDispose():void
		{
			
		}
	}
}