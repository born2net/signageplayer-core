package
{
	import flash.events.IEventDispatcher;
	
	public interface IPlayerOutline extends IEventDispatcher
	{
		function getPlayersCount():int;
		function getPlayerLabel(i_index:int):String;
		function setPlayerLabel(i_index:int, i_label:String):void;
		function getPlayerIcon(i_index:int):Class;
		function getPlayerLocked(i_index:int):Boolean;
		function setPlayerLocked(i_index:int, i_locked:Boolean):void;
		function getGroupName():String;
		
		function getPlayerLoaderAt(i_index:int):IPlayerLoader;
		
		
		function get selectedPlayer():int;
		function set selectedPlayer(i_index:int):void;
		function swapPlayers(i_index1:int, i_index2:int):void;
		function deletePlayer(i_index:int):void;
	}
}