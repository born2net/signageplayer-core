package
{
	public interface IServicesBroker
	{
		function RegisterService(i_serviceName:String, i_service:Object):void;
		function QueryService(i_serviceName:String):Object;
	}
}