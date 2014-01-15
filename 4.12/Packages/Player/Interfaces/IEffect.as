package
{
	public interface IEffect extends ISerializable
	{
		function clear():void;
		function start():void;
		function stop():void;
		function pause():void;
		function get seek():Number;
		function set seek(i_seek:Number):void;
		function enableEffect():void;
		function onFrame(i_time:Number):void;
	}
}