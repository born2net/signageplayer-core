package
{
	public interface IPlayerEventService
	{
		/*
		function compile():String;
		function setVar(i_varName:String, i_value:Object):void;
		function getVar(i_varName:String):Object;
		function callFunction(i_functionName:String, i_value:Number):Boolean;
		function get lastError():String;
		*/
		
		function registerEventHandler(i_eventHandler:IEventHandler):void;
		function unregisterEventHandler(i_eventHandler:IEventHandler):void;
		function sendEvent(i_playerName:String, i_eventName:String, i_eventParam:Object):void;
	}
}