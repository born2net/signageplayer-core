package
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.events.FlexEvent;
	import spark.components.TextInput;

	public class TextInputPath extends TextInput
	{
		private var m_showReadOnlyBorder:Boolean = true;
		
		public function TextInputPath()
		{
			super();
			restrict="A-Za-z0-9 _/";
			addEventListener(FlexEvent.ENTER, onTextInput);
			addEventListener(FocusEvent.FOCUS_OUT, onTextInput);
		}
		
		public function get showReadOnlyBorder():Boolean
		{
			return m_showReadOnlyBorder;
		}
		
		public function set showReadOnlyBorder(i_showReadOnlyBorder:Boolean):void
		{
			m_showReadOnlyBorder = i_showReadOnlyBorder;
			invalidateProperties();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			setStyle("borderStyle", (editable || m_showReadOnlyBorder) ? "solid" : "none");
		}
		
		
		protected function onTextInput(event:Event):void
		{
			if (text.substr(0, 1)=="/")
				text = text.substring(1);
				
			if (text.substr(text.length-1, 1)=="/")
				text = text.substr(0, text.length-1);		
		}
	}
}
