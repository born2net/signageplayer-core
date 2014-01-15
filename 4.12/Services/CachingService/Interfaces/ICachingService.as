package
{
	import flash.events.IEventDispatcher;

	public interface ICachingService
	{
		function generateFileName(i_url:String):String;
		function getCachingItem(i_relativePath:String, i_fileName:String):ICachingItem;
		function removeCachingItem(i_cachingItem:ICachingItem):Boolean;
	}
}
