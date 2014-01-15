package
{
	import flash.events.IEventDispatcher;
	
	public interface IPlayer extends IEventDispatcher, IEffect
	{
		function get propertyPages():Array;
		
		function get keepPlaying():Boolean;
		function set keepPlaying(i_keepPlaying:Boolean):void;
		
		function get playerLoader():IPlayerLoader;
		function set playerLoader(i_playerLoader:IPlayerLoader):void;
	}
}
 