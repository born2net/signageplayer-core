package
{
	import flash.events.IEventDispatcher;

	public interface IPlayerLoaderService extends IEventDispatcher
	{
		function createPlayerLoader():IPlayerLoader;
	}
}
