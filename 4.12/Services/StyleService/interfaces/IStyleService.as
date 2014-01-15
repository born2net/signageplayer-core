package
{
	import flash.events.IEventDispatcher;
	import mx.styles.CSSStyleDeclaration;
	
	public interface IStyleService extends IEventDispatcher
	{
		function load(i_url:String, i_update:Boolean, i_override:Boolean=false):void;
		function isCompleted(i_url:String):Boolean;
		function allCompleted():Boolean;
		
		function get weatherList():XMLList;
		function getWeatherCSS(i_weatherStyleId:int):CSSStyleDeclaration;
		
		function loadFont(i_family:String):void;
		function fontsCompleted(i_familyMap:Object):Boolean;
		
		function get fontFamilyList():Array;
		
		function createFontItem():IFontItem;
	}
}