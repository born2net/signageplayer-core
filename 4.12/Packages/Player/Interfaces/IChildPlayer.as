package
{
	public interface IChildPlayer
	{
		function set framework(i_framework:Object):void;
		function get framework():Object;
		function getPropertyDefinitions():XML;
		function set data(i_data:Object):void
		function get data():Object
		function refresh():void
		function start():void
		function stop():void
		function dispose():void;
	}
}