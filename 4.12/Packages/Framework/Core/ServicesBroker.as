package
{
	import flash.utils.Dictionary;
	
	public class ServicesBroker implements IServicesBroker
	{
		private var m_services:Dictionary = new Dictionary();
		
		public function ServicesBroker()
		{
			
		}
		
		public function RegisterService(i_serviceName:String, i_service:Object):void
		{
			m_services[i_serviceName] = i_service;
		}
		
		public function QueryService(i_serviceName:String):Object
		{
			return m_services[i_serviceName];
			
		}
	}
}