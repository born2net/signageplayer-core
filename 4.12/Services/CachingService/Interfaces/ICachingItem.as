package
{
	import flash.events.IEventDispatcher;

	public interface ICachingItem extends IEventDispatcher
	{
		function get url():String;
		function set url(i_url:String):void;
		function get expireDuration():Number;
		function set expireDuration(i_expireDuration:Number):void;
		function get version():String;
		function set version(i_version:String):void;
		
		function get tag():int;
		function set tag(i_tag:int):void;
		
		
		function cache(i_force:Boolean = false):Boolean;
		function get source():String;
		function get data():String;
		function get lastDownload():Number;
		
		function get cached():Boolean;
		function get type():String;
	}
}
