package Menu
{
	import mx.styles.CSSStyleDeclaration;

	public class SparkToolBar extends SparkMenuBar
	{
		public function SparkToolBar()
		{
			super();
			focusEnabled = false;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			var css:CSSStyleDeclaration = styleManager.getStyleDeclaration("SparkTookBar" );
			if (css!=null)
			{
				setStyle("contentBackgroundColor", css.getStyle("backgroundColor"));
			}
			
			setStyle("selectionColor", 0xB9B9B9);
			setStyle("rollOverColor", 0xB9B9B9);
		}		
	}
}