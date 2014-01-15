package
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	import mx.utils.Base64Encoder;
	
	public class ResourceService implements IResourceService
	{
		protected  var m_framework:IFramework;
		protected var m_loaderManager:ILoaderManager;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_cachingService:ICachingService;
		
		protected var m_resourcesHostingType:int = 0;
		protected var m_resourceUrl:String;
		
		protected var m_businessDomain:String;
		protected var m_businessId:int = -1;
		
		private var m_snapshots:Dictionary = new Dictionary();
		
		public function ResourceService(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_framework.EventBroker.addEventListener("EVENT_ACCOUNT_CREATED", onAccountCreated);
			init();
		}
		
		public function isAir():Boolean
		{
			return false;
		}
		
		
		private function onAccountCreated(event:Event):void
		{
			init();
		}
		
		protected function init():void 
		{
			m_cachingService = m_framework.ServiceBroker.QueryService("CachingService") as ICachingService;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_loaderManager = m_framework.ServiceBroker.QueryService("LoaderManager") as ILoaderManager;
			
			var businessDomain:String = m_framework.StateBroker.GetState("businessDomain") as String;
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			selectDomainBusiness(businessDomain, businessId);
		} 
		
		public function update():void
		{
			
		}
		
		public function selectDomainBusiness(i_businessDomain:String, i_businessId:int):void
		{
			m_businessDomain = i_businessDomain;
			m_businessId = i_businessId;
			
			var businessServer:Boolean = true;
			if (businessServer)
			{
				m_resourceUrl = "http://" + m_businessDomain + "/Resources/" +"business"+m_businessId+"/resources/";
			}
			else
			{
				//m_resourceUrl = "http://s3.amazonaws.com/media_signage_business"+m_businessId+"/resources/";
				m_resourceUrl = "http://s3.amazonaws.com/" + m_businessDomain + "/business" + m_businessId+"/resources/";
				
			}
		}
		
		public function getPathFromHandle(i_hResource:int):String
		{
			var url:String = null;
			try
			{
				var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
	
				if (recResource!=null)
				{
					if (recResource.native_id!=-1)
					{
						url = getPath(recResource);
					}
					else
					{
						if (m_loaderManager!=null)
						{
							url = m_loaderManager.getFileUrl(recResource.resource_id);
						}
					}
				}
			}
			catch(error:Error)
			{
				/*M???
				Alert.show (error.message, "ResourceService Error", Alert.OK, UIComponent(m_framework.StateBroker.GetState("topWindow")));
				*/
			}
			
			return url;
		}
		
		public function getUrlFromHandle(i_hResource:int):String
		{
			var url:String = null;
			try
			{
				var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
	
				if (recResource!=null)
				{
					if (recResource.native_id!=-1)
					{
						//url = super.getPath(recResource);
						url = m_resourceUrl + recResource.native_id + "." + recResource.resource_type;
					}
					else
					{
						if (m_loaderManager!=null)
						{
							url = m_loaderManager.getFileUrl(recResource.resource_id);
						}
					}
				}
			}	
			catch(error:Error)
			{
				/*M???
				Alert.show (error.message, "ResourceService Error", Alert.OK, UIComponent(m_framework.StateBroker.GetState("topWindow")));
				*/
			}
			
			return url;
		}
		
		public function getNameFromHandle(i_hResource:int):String
		{
			var name:String = null;
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if(recResource!=null)
			{
				name = recResource.resource_name;
			}
			return name;
			
		}
			
		public function getTypeFromHandle(i_hResource:int):String
		{
			var type:String = null;
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if(recResource!=null)
			{
				type = recResource.resource_type;
			}
			return type;
		}
		
		
		public function useHtmlContainer(i_hResource:int):Boolean
		{
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if (recResource==null)
				return false;
			if (recResource.resource_type=="pdf")
				return true;
			return (recResource!=null) ? recResource.resource_html : false;
		}
		
		public function isFlexModule(i_hResource:int):Boolean
		{
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			return (recResource!=null) ? recResource.resource_module : false;
		}
		
		public function isTrust(i_hResource:int):Boolean
		{
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			return (recResource!=null) ? recResource.resource_trust : false;
		}
		
		
		public function getPathFromId(i_resourceId:int):String
		{
			return "";
		}
		
		protected function getPath(i_recResource:Rec_resource):String
		{
			return m_resourceUrl + i_recResource.native_id + "." + i_recResource.resource_type;
		}
		

		public function addSnapshot(i_table:String, i_group:String, i_handle:int, i_data:ByteArray):void
		{
			m_snapshots[i_table+"_"+i_group+"_"+i_handle] = i_data;
			//m_framework.EventBroker.dispatchEvent( new Event("event_snapshot_added") );
			m_framework.EventBroker.dispatchEvent( new ResourceEvent(ResourceEvent.EVENT_RESOURCE_MONIFIED, i_handle) );
		}

		public function getSnapshots():Dictionary
		{
			return m_snapshots;
		}

		public function getSnapshotFromHandle(i_table:String, i_group:String, i_handle:int):Object
		{
			var data:Object = m_snapshots[i_table+"_"+i_group+"_"+i_handle];
			if (data==null)
			{
				var table:Table = m_dataBaseManager.getTable(i_table);	
				var record:Record = table.getRec(i_handle);
				var id:int = record.native_id;
				data = m_resourceUrl+i_group+"/"+id+".png";				
			}
			return data;;
		}

		protected function encode(i_data:ByteArray):String
		{
	 		var base64:Base64Encoder = new Base64Encoder();
	        base64.encodeBytes(i_data);
	        return base64.drain();
		}
		
		public function getTotalTime(i_hResource:int):Number
		{
			 var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			 return recResource.resource_total_time;
		} 
		
		public function setTotalTime(i_hResource:int, i_totalTime:Number):void
		{ 
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if (recResource!=null && recResource.resource_total_time==0 && isNaN(i_totalTime)==false && i_totalTime>0)
			{
				m_dataBaseManager.table_resources.openForEdit(i_hResource);
				recResource = m_dataBaseManager.table_resources.getRecord(i_hResource);
				recResource.resource_total_time = i_totalTime;
				m_framework.EventBroker.dispatchEvent( new ResourceEvent(ResourceEvent.EVENT_RESOURCE_MONIFIED, i_hResource) );
			}
		}
		
		public function setSize(i_hResource:int, i_width:int, i_height:int):void
		{
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if (recResource.resource_pixel_width!=i_width || recResource.resource_pixel_height!=i_height)
			{ 
				m_dataBaseManager.table_resources.openForEdit(i_hResource);
				recResource = m_dataBaseManager.table_resources.getRecord(i_hResource);
				recResource.resource_pixel_width = i_width;
				recResource.resource_pixel_height = i_height;			 
				m_framework.EventBroker.dispatchEvent( new ResourceEvent(ResourceEvent.EVENT_RESOURCE_MONIFIED, i_hResource) );
			}
		}

		public function getWidth(i_hResource:int):int
		{
			 var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			 return recResource.resource_pixel_width;
		} 

		public function getHeight(i_hResource:int):int
		{
			 var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			 return recResource.resource_pixel_height;
		} 
		
		public function setBytesTotal(i_hResource:int, i_bytesTotal:Number):void
		{
			var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			if (recResource.resource_bytes_total!=i_bytesTotal)
			{ 
				m_dataBaseManager.table_resources.openForEdit(i_hResource);
				recResource = m_dataBaseManager.table_resources.getRecord(i_hResource);
				recResource.resource_bytes_total = i_bytesTotal;
				m_framework.EventBroker.dispatchEvent( new ResourceEvent(ResourceEvent.EVENT_RESOURCE_MONIFIED, i_hResource) );
			}
		}
		
		public function getBytesTotal(i_hResource:int):Number
		{
			 var recResource:Rec_resource = m_dataBaseManager.table_resources.getRecord(i_hResource);
			 return recResource.resource_pixel_height;
		}
		
		public function clearCaching():void
		{
			
		}
	}
}