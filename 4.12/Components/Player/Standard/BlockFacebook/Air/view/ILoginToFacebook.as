package view
{
	import flash.events.IEventDispatcher;
	
	public interface ILoginToFacebook extends IEventDispatcher
	{
		function init(param:Object):void;
		function logout():void;
	}
}