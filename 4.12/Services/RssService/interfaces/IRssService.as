package
{
	import flash.events.IEventDispatcher;
	
	public interface IRssService
	{
		function createRssRequest(i_url:String, i_minRefreshTime:Number, i_expiredTime:Number):IRssRequest;
	}
}