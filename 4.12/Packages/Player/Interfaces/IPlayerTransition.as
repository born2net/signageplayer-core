package
{
	public interface IPlayerTransition
	{
		function get playerLoader():IPlayerLoader;
		function load(i_xmlPlayer:XML, i_seek:Number):void;
		function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void;
		function tick(i_time:Number):void;
		function clean():void;
	}
}