package 
{
	import flash.events.IEventDispatcher;
	
	public interface IFramework extends IEventDispatcher 
	{
		function get EventBroker():IEventDispatcher;
		function get ServiceBroker():IServicesBroker;
		function get StateBroker():IStateBroker;
	}
} 