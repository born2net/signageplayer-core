package
{
	import flash.events.IEventDispatcher;
	
	public interface IStateBroker extends IEventDispatcher
	{
		function SetState(i_sender:Object, i_name:String, i_value:Object):void;
		function RemoveState(i_sender:Object, i_name:String):void;
		function GetState(i_name:String):Object;
	}
}