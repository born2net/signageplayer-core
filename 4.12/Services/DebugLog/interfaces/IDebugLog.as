package
{
	import flash.events.IEventDispatcher;
	
	public interface IDebugLog extends IEventDispatcher
	{
		function addInfo(i_message:String):void;
		function addWarning(i_message:String):void;
		function addError(i_message:String):void;
		function addException(error:Error):void;
		function flush():void;
		function setParam(i_param:String, i_value:String):void;
		function set showAlert(i_showAlert:Boolean):void;
		function get showAlert():Boolean;
	}
}