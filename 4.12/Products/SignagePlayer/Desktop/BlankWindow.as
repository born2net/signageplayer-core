package
{
	import flash.display.NativeWindowSystemChrome;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.ScrollPolicy;
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	
	public class BlankWindow extends Window
	{
		public function BlankWindow()
		{
			super();
			title = "Signage Player";
			showStatusBar = false;
			resizable = false;
			systemChrome = NativeWindowSystemChrome.NONE;
			setStyle("gripperPadding", 0); 
			setStyle("headerHeight", 0);
			setStyle("borderThickness", 0);
			setStyle("cornerRadius", 0);
			setStyle("backgroundColor", 0);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
		}
		 
		protected override function createChildren():void
		{
			super.createChildren();
		}
		
		private function onMouse(event:MouseEvent):void
		{
			FlexGlobals.topLevelApplication.dispatchEvent(event);
		}
	}
}