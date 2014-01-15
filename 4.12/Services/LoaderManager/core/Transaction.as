package
{
	public class Transaction implements ITransaction
	{
		protected var m_framework:IFramework;
		protected var m_debugLog:IDebugLog;
		protected var m_databaseManager:DataBaseManager;
		protected var m_businessId:int;
		protected var m_businessDomain:String;
		protected var m_callback:Function;
		protected var m_result:Boolean;
		
		public function Transaction(i_framework:IFramework, i_businessDomain:String, i_businessId:int, i_callback:Function)
		{
			m_framework = i_framework;
			m_businessDomain = i_businessDomain;
			m_businessId = i_businessId; 
			m_callback = i_callback;
			
			m_result = false;
			
			m_databaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			
			m_databaseManager.selectDomainBusiness(i_businessDomain, i_businessId);
		}
		
		public function get result():Boolean
		{
			return m_result;
		}
		
		protected function finish():void
		{
			if (m_callback!=null)
			{
				var callback:Function = m_callback;
				m_callback = null;
				m_result = true;
				callback(this);
			}	
		}
	}
}