package
{
	import mx.collections.ArrayCollection;
	import mx.core.IUIComponent;
	import mx.core.IVisualElementContainer;

	public interface IPlayerLoader extends ISerializable, IEditor, IProviderItem, IUIComponent
	{ 
		function start():void;
		function stop():void;
		function pause():void;
		function clear():void;
		
		function set modified(i_modified:Boolean):void;
		function get modified():Boolean;
		
		function get playerName():String;  // shoube be call eventName
		function set playerName(i_playerName:String):void;  // shoube be call eventName	
		function get interactive():Boolean;
		function set interactive(i_interactive:Boolean):void;
		
		function get label():String;
		function set label(i_label:String):void;
		function get player():IPlayer;
		function onFrame(i_time:Number):void;
		
		function get embedded():Boolean;
		
		function createEventHandler(i_senderName:String, i_eventCondition:String, i_commandName:String, i_commandParams:XML):IEventHandler;
		function get eventHandlers():ArrayCollection;
		
		function sendEvent(i_senderName:String, i_eventName:String, i_eventParam:Object):void;
	}
}