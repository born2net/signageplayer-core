package
{
	import flash.events.IEventDispatcher;
	
	public interface IRssRequest extends IEventDispatcher
	{
		function request():void;
		function get result():String;
		
		function shuffleItems():void;
		function getItemCount():int;
		function getItemAt(i_index:int):IRssItem;
	}
}