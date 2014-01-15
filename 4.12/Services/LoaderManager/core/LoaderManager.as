package
{
	import flash.events.Event;
	import flash.net.FileReference;
	
	import mx.core.UIComponent;
	//M??? import mx.controls.Alert;
	
	public class LoaderManager implements ILoaderManager
	{
		private var m_framework:IFramework;
		private var m_databaseManager:DataBaseManager;
		private var m_businessDomain:String;
		private var m_businessId:int;
		private var m_fileReferenceMap:OrderedMap = new OrderedMap();
		private var m_persist:Boolean = false;
		
		public function LoaderManager(i_framework:IFramework, i_persist:Boolean)
		{ 
			m_framework = i_framework;
			m_persist = i_persist;
			m_databaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
		}
		
		public function addFileReference(i_hResource:int, i_fileReference:FileReference):void
		{
			m_fileReferenceMap.add(i_hResource, i_fileReference);
		}
		
		public function addFileUrl(i_hResource:int, i_url:String):void
		{
			m_fileReferenceMap.add(i_hResource, i_url);
		}		
		
		public function removeFileReference(i_hResource:int):void
		{
			m_fileReferenceMap.remove(i_hResource);
		}
		
		public function getFileType(i_hResource:int):String
		{
			return (m_fileReferenceMap.getValue(i_hResource) is FileReference) ? "FileReference" : "FileUrl";
		}
		
		public function getFileReference(i_hResource:int):FileReference
		{
			return FileReference(m_fileReferenceMap.getValue(i_hResource));
		}

		public function getFileUrl(i_hResource:int):String
		{
			return m_fileReferenceMap.getValue(i_hResource) as String;
		}

		
		public function CreateTableRequest():ITableRequest
		{
			return new TableRequest();
		}
		
		public function request(i_tableRequest:ITableRequest, i_fromLastChangelist:Boolean, i_updateLastChangelist:Boolean, i_reqDeleted:Boolean, i_requestCallback:Function):Boolean
		{
			var businessDomain:String = m_framework.StateBroker.GetState("businessDomain") as String;
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			if (m_businessDomain==businessDomain && m_businessId==businessId)
			{
				m_framework.StateBroker.dispatchEvent( new Event("event_before_request_data") );
			}
			
			var fromChangelist:int = 0;
			if (i_fromLastChangelist)
			{
				fromChangelist = m_databaseManager.lastChangelist
			}
			var transaction:TransactionRequest = new TransactionRequest(m_framework, m_businessDomain, m_businessId, i_tableRequest, fromChangelist, i_updateLastChangelist, true, i_reqDeleted, i_requestCallback);
			transaction.request();
			return true;			
		}	
		
		public function persistRequest(i_persistBank:String, i_persistKey:String, i_tableRequest:ITableRequest, i_fromLastChangelist:Boolean, i_updateLastChangelist:Boolean, i_updateTables:Boolean, i_reqDeleted:Boolean, i_requestCallback:Function):Boolean
		{
			var businessDomain:String = m_framework.StateBroker.GetState("businessDomain") as String;
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			if (m_businessDomain==businessDomain && m_businessId==businessId)
			{
				m_framework.StateBroker.dispatchEvent( new Event("event_before_request_data") );
			}


			var fromChangelist:int = 0;
			if (i_fromLastChangelist)
			{
				fromChangelist = m_databaseManager.lastChangelist;
			}
			var transaction:TransactionRequest = new TransactionRequest(m_framework, m_businessDomain, m_businessId, i_tableRequest, fromChangelist, i_updateLastChangelist, i_updateTables, i_reqDeleted, i_requestCallback);
			transaction.persistRequest(i_persistBank, i_persistKey);
			return true;			
		}	
		
		public function submit(i_submitCallback:Function):Boolean
		{
			m_framework.StateBroker.dispatchEvent( new Event("event_before_submit_data") );
			var userName:String = m_framework.StateBroker.GetState("userName") as String;
			var userPassword:String = m_framework.StateBroker.GetState("userPassword") as String;
				
			if (userName==null ||userPassword==null)  //???
			{
				/*M???
				Alert.show (
					"In order to submit your changes you need to create an account.", 
					"create an account",
					Alert.OK,
					UIComponent(m_framework.StateBroker.GetState("topWindow")));
				*/
				return false;
			}		

			var transaction:Transaction = new TransactionSubmit(m_framework, m_businessDomain, m_businessId, i_submitCallback, m_fileReferenceMap);			
			return true;
		}

		public function selectDomainBusiness(i_businessDomain:String, i_businessId:int):void
		{
			m_businessDomain 	= i_businessDomain;
			m_businessId 	= i_businessId;
			m_databaseManager.selectDomainBusiness(i_businessDomain, i_businessId);
		}
	}
}
