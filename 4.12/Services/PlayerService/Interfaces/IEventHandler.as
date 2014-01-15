package  
{
	public interface IEventHandler
	{
		function get senderName():String;
		function set senderName(i_senderName:String):void;
		
		function get eventCondition():String;
		function set eventCondition(i_eventCondition:String):void;
		
		function get commandName():String;
		function set commandName(i_commandName:String):void;
		
		function get commandParams():XML;
		function set commandParams(i_commandParams:XML):void;
			
		function onEvent(i_eventType:String, i_eventParam:Object):void
	}
}
