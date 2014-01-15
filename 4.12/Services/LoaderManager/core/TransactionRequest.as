package
{
	//M??? import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.Base64Encoder;
	
	public class TransactionRequest extends Transaction implements ITransactionRequest
	{
		private var m_tableRequest:ITableRequest;
		private var m_fromChangelist:int = 0;
		private var m_updateTables:Boolean = true;
		private var m_reqDeleted:Boolean = false;
		private var m_updateLastChangelist:Boolean;
		private var m_RequestData:PostService;
		private var m_persistBank:String;
		private var m_persistKey:String;
		private var m_persistent:IPersistent;
		private var m_online:Boolean;
		
		public function TransactionRequest(i_framework:IFramework, i_businessDomain:String, i_businessId:int,
			i_tableRequest:ITableRequest, i_fromChangelist:int, i_updateLastChangelist:Boolean, i_updateTables:Boolean, i_reqDeleted:Boolean, i_requestCallback:Function)
		{
			super(i_framework, i_businessDomain, i_businessId, i_requestCallback);
			m_tableRequest = i_tableRequest;
			m_fromChangelist = i_fromChangelist;
			m_updateLastChangelist = i_updateLastChangelist;
			m_updateTables = i_updateTables;
			m_reqDeleted = i_reqDeleted;	
			
			m_online = false;
			
			m_persistent = m_framework.ServiceBroker.QueryService("Persistent") as IPersistent;
			
			m_databaseManager.selectDomainBusiness(m_businessDomain, m_businessId);
 
			m_RequestData = new PostService("http://"+m_businessDomain+"/WebService/DataBaseService.asmx", "RequestData3", "i_business", "i_businessDbName", "i_xmlTableRequest", "i_fromChangelist", "i_reqDeleted");
			m_RequestData.addEventListener("result", onRequestDataResult);
			m_RequestData.addEventListener(FaultEvent.FAULT, onRequestDataFault);
		}
		
		public function request():void
		{
			m_RequestData.call(m_businessId, "MediaSignage_BusinessesA", getBase64TableRequest(), m_fromChangelist, m_reqDeleted); //???
		}

		public function persistRequest(i_persistBank:String, i_persistKey:String):void
		{
			m_persistBank = i_persistBank;
			m_persistKey = i_persistKey;
			m_RequestData.call(m_businessId, "MediaSignage_BusinessesA", getBase64TableRequest(), m_fromChangelist, m_reqDeleted);
		}
		
		private function getBase64TableRequest():String
		{
			var base64Encoder:Base64Encoder = new Base64Encoder();
			base64Encoder.encodeUTFBytes(TableRequest(m_tableRequest).tableRequest.toXMLString());
			return base64Encoder.toString();
		}
		
		public function get online():Boolean
		{
			return m_online;
		}
		
		private function onRequestDataFault(event:FaultEvent):void
		{
			m_online = false;
			if (m_persistent!=null && m_persistBank!=null && m_persistKey!=null)
			{
				var xmlResult:XML = m_persistent.getValueAsXML(m_persistBank, m_persistKey);
				if (xmlResult==null)
				{
					m_RequestData.post(3);
					return;
				}
				applyRequestData(xmlResult.copy());
			}
			else
			{
				var callback:Function = m_callback;
				m_callback = null;
				m_result = false;
				callback(this);
			}
		}

		private function onRequestDataResult(event:ResultEvent):void
		{
			var xmlResult:XML = XML(event.result);
			if (xmlResult.name()=="Result")
			{
				m_online = true;
				if (m_persistent!=null && m_persistBank!=null && m_persistKey!=null)
				{
					m_persistent.setValue(m_persistBank, m_persistKey, xmlResult.copy());
				}
				applyRequestData(xmlResult);
			}
			else  // Restricted internet connection 
			{
				// M??? Alert.show("Restricted internet connection 2", "onRequestDataResult");
				m_online = false;
				if (m_persistent!=null && m_persistBank!=null && m_persistKey!=null)
				{
					xmlResult = m_persistent.getValueAsXML(m_persistBank, m_persistKey);
					if (xmlResult==null)
					{
						m_RequestData.post(3);
						return;
					}
					applyRequestData(xmlResult.copy());
				}
			}
			
		}
		
		private function applyRequestData(i_xmlResult:XML):void
		{
			var xmlTable:XML;
			if (m_updateLastChangelist)
			{
				var lastChangelistId:int = i_xmlResult.@lastChangelistId;
				m_databaseManager.lastChangelist = lastChangelistId;
			}
			
			if (m_updateTables==true)
			{
				m_databaseManager.selectDomainBusiness(m_businessDomain, m_businessId);
				m_databaseManager.loadTables(i_xmlResult);
			}
			
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