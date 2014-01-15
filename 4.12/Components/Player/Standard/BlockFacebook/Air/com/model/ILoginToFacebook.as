package com.model
{
	import flash.events.IEventDispatcher;
	
	public interface ILoginToFacebook extends IEventDispatcher
	{
		function init(param:Object):void;
		function logout():void;
	}
}