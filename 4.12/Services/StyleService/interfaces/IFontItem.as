package
{
	import mx.core.UIComponent;

	public interface IFontItem
	{
		function load(i_xmlFont:XML):void;
		function save():XML;
		
		function get fontFamilyList():Array;
		function set fontSize(i_fontSize:Number):void;
		function get fontSize():Number;
		function set fontColor(i_fontColor:uint):void;
		function get fontColor():uint;
		function get fontFamily():String;
		function set fontFamily(i_fontFamily:String):void;
		function set fontWeight(i_fontWeight:String):void;
		function get fontWeight():String;
		function set fontStyle(i_fontStyle:String):void;
		function get fontStyle():String;
		function set textDecoration(i_textDecoration:String):void;
		function get textDecoration():String;
		function set textAlign(i_textAlign:String):void;
		function get textAlign():String;
		
		function applyStyles(i_component:UIComponent):void;
	}
}