package
{
	import flash.display.DisplayObject;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	import mx.utils.Base64Encoder;
	
	
	public class TransactionSubmit extends Transaction
	{
		private var m_cryptoService:ICryptoService;
		private var m_fileReferenceMap:OrderedMap;
		
		private var m_dataBaseService:WebService = new WebService();
		
		private var m_policy:String;
    	private var m_signature:String;
    	private var m_resourceService:ResourceService;
		private var m_fileReference:FileReference;
		private var m_loadProgress:LoadProgress;
		private var m_totalUploadSize:int;
		private var m_curUploadSize:int;
		private var m_tmpResourceSize:int;
		private var m_s3PostRequest:S3PostRequest;
    	private var m_timeoutTimer:Timer;
    	private var m_uploadPath:String;
    	
		
		public function TransactionSubmit(i_framework:IFramework, i_businessUrl:String, i_businessId:int,
			i_submitCallback:Function, i_fileReferenceMap:OrderedMap)
		{
			super(i_framework, i_businessUrl, i_businessId, i_submitCallback);
			m_cryptoService = m_framework.ServiceBroker.QueryService("CryptoService") as ICryptoService;
			m_fileReferenceMap = i_fileReferenceMap;
			//m_dataBaseService.GetAmazonPolicy.addEventListener("result", onAmazonPolicy);
			
			m_dataBaseService.useProxy = false;
			m_dataBaseService.addEventListener(FaultEvent.FAULT, onWebServiceFault);
			m_businessDomain = m_framework.StateBroker.GetState("businessDomain") as String;
			m_dataBaseService.loadWSDL("http://"+m_businessDomain+"/WebService/DataBaseService.asmx?wsdl");
			
			
			m_dataBaseService.BeginSubmit.addEventListener("result", onBeginSubmit);
			m_dataBaseService.KeepSession.addEventListener("result", onKeepSession);
			m_dataBaseService.GetUploadFolder.addEventListener("result", onUploadFolder);
			m_dataBaseService.CommitSubmit.addEventListener("result", onCommitSubmit);
			m_dataBaseService.UploadSnapshot.addEventListener("result", onUploadSnapshot);
			m_dataBaseService.UploadResource.addEventListener("result", onUploadResource);
			
						
			m_resourceService = m_framework.ServiceBroker.QueryService("ResourceService") as ResourceService;
			m_loadProgress = PopUpManager.createPopUp(UIComponent(i_framework.StateBroker.GetState("topWindow")), LoadProgress, true) as LoadProgress;
            PopUpManager.centerPopUp(m_loadProgress);
			m_totalUploadSize = 0;
			m_curUploadSize = 0;
			m_tmpResourceSize = 0;

			var appVersion:String = String(m_framework.StateBroker.GetState("version"));
			var appType:String = (m_framework.StateBroker.GetState("airPlayer")==true) ? "Air" : "Web"; 
			m_dataBaseService.BeginSubmit(m_businessId, "MediaSignage_BusinessesA", appVersion, appType);
		}
		
		private function onWebServiceFault(event:FaultEvent):void
		{
			m_debugLog.addWarning("TransactionSubmit.as\n"+event.toString());
			/*M???
			AlertEx.showOk(UIComponent(m_framework.StateBroker.GetState("topWindow")),
				ResourceManager.getInstance().getString('customer','alert.text.submitFail'),
				ResourceManager.getInstance().getString('customer','alert.title.submitFail'));
			*/
		}
		
		private function onTimeoutTimer(event:TimerEvent):void
		{
			m_dataBaseService.KeepSession(); // reset to 5 min
		}
		
		private function onKeepSession(event:ResultEvent):void
		{
			if (event.result==false)
			{
				m_debugLog.addWarning("KeepSession Fail");
				closeTransaction();					
			}
		}
		
		private function onBeginSubmit(event:ResultEvent):void
		{
			m_timeoutTimer =  new Timer(5 * 60 * 1000); // call every 5 min.
			m_timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeoutTimer);
			m_timeoutTimer.start();
			
			var count:int = m_fileReferenceMap.count;
			for(var i:int;i<count;i++)
			{
				var hResource:int = int(m_fileReferenceMap.getKeyAt(i));
				m_databaseManager.selectDomainBusiness(m_businessDomain, m_businessId);
				var recResource:Rec_resource = m_databaseManager.table_resources.getRecord(hResource);
				var file:Object = m_fileReferenceMap.getValue(hResource);
				if (file is FileReference)
				{
					var fileReference:FileReference = FileReference(file);		
					m_totalUploadSize += fileReference.size;
				}
				else
				{
					m_totalUploadSize += recResource.resource_bytes_total;
				}
			}
			
			m_dataBaseService.GetUploadFolder();
		}

		private function onUploadFolder(event:ResultEvent):void
		{
			m_uploadPath = event.result as String;
			nextUpload();
		}
		
        private function nextUpload():void
        {
        	var snapshots:Dictionary = ResourceService(m_resourceService).getSnapshots();
	       	var key:String = null; 
        	for(key in snapshots)
        		break;
			if (key!=null)
			{
				uploadSnapshots();
				return;
			}
			
			if (m_fileReferenceMap.count>0)
			{
				uploadFiles();
				return;
			}        	
			
			submit();
        }
		
		
		private function exit(i_result:Boolean, i_messageTitle:String, i_messageText:String):void
		{
			PopUpManager.removePopUp(m_loadProgress);
   			m_loadProgress = null;					
			removeTimer();
   			var callback:Function = m_callback; 
   			m_callback = null;
   			callback(i_result, i_messageTitle, i_messageText);
		}
		
		private function onLastChangelistId(event:ResultEvent):void
		{
			var dbChangelistId:int = int(event.result);
			var curChangelistId:int = m_databaseManager.lastChangelist;
			if (dbChangelistId>curChangelistId)
			{
				exit(false, "Submit Ignored", "you need to sync before submit");	
			}
			else
			{
				submit();
			}
		}
		
		private function submit():void
		{
			var resourcesHostingType:int = int(m_framework.StateBroker.GetState("resourcesHostingType"));
			if (resourcesHostingType==0)
			{
				submitData();
			}
			else
			{
				var userName:String = m_framework.StateBroker.GetState("userName") as String;
				var userPassword:String = m_framework.StateBroker.GetState("userPassword") as String;
				m_cryptoService.businessEncrypt(onEncryptAmazonPolicy, userName, userPassword);
			}
		}
		
		private function onEncryptAmazonPolicy(i_encryptRequest:IEncryptRequest):void
		{
			m_dataBaseService.GetAmazonPolicy(i_encryptRequest.output);	
		}
		
		private function onCommitSubmit(event:ResultEvent):void
		{
			if (event.result==null)
			{
				m_debugLog.addError("Submit to the server fail");
				closeTransaction();	
				return;
			}
			else if (String(event.result).substr(0, 13)=="no_privilege:")
			{/*M???
				Alert.show (
					String(event.result).substring(13), 
					"Submit to the server denied",
					Alert.OK,
					UIComponent(m_framework.StateBroker.GetState("topWindow")));
				*/
				closeTransaction();	
				return;
			}
			else if (String(event.result).substr(0, 19)=="licenses_exception:")
			{
				/*M???
				Alert.show (
					String(event.result).substring(19), 
					"Can not add new signage player",
					Alert.OK,
					UIComponent(m_framework.StateBroker.GetState("topWindow")));
				*/
				closeTransaction();	
				return;
			}
			
			var xmlTable:XML;
			m_databaseManager.selectDomainBusiness(m_businessDomain, m_businessId);
			var primaryToTables:Object = m_databaseManager.getPrimaryToTableMap();
			 
			
   			var xmlTables:XML = new XML(event.result);
			//Alert.show(xmlTables.toXMLString());
   			var changelistId:int = int(xmlTables.@lastChangelistId)
   			m_databaseManager.lastChangelist = changelistId;
   			for each(xmlTable in xmlTables.*)
   			{
   				var field:String = xmlTable.@name;
				var tableList:Array = primaryToTables[field];
				for each(var table:Table in tableList)
				{
	   				for each( var xmlRec:XML in xmlTable.*)
	   				{
	   					var handle:int = xmlRec.@handle;
	   					var id:int = xmlRec.@id;
	   					var rec:Record = table.getRec(handle);
						if (rec!=null)
						{
	   						rec.native_id = id;
	   						table.setRecordId(handle, id);;
						}
	   				}
				}
   			}
   			m_databaseManager.commitChanges(changelistId);
			
			closeTransaction();
		}
		
		private function uploadFiles():void
		{
			if (m_fileReferenceMap.count>0)
			{
				var hResource:int = int(m_fileReferenceMap.getKeyAt(0));
				var recResource:Rec_resource = m_databaseManager.table_resources.getRecord(hResource);
				var filename:String = hResource+"."+recResource.resource_type;
				m_loadProgress.fileName.text = recResource.resource_name;
				
				var file:Object = m_fileReferenceMap.getValue(hResource);
				if (file is FileReference)
				{
					m_fileReference = FileReference(file);
					m_fileReferenceMap.remove(hResource);
					
					if (m_fileReference!=null)
					{
						var resourcesHostingType:int = int(m_framework.StateBroker.GetState("resourcesHostingType"));
						if (resourcesHostingType==0)
						{
							postBusinessServer(filename);
						}
						else if (resourcesHostingType==1)
						{
							postAmazonServer(filename);
						}
		   			}
		   			else
		   			{
		   			}
		  		}
		  		else // file is String (url)
		  		{
		  			m_tmpResourceSize = recResource.resource_bytes_total;
		  			uploadResource(filename, String(file));
		  			m_fileReferenceMap.remove(hResource);
		  		}
   			}
   			else
   			{
   				m_fileReferenceMap = null;
   				m_fileReference = null;
   			}
		}
		
        private function openHandler(event:Event):void
        {
			m_loadProgress.fileProgress.value = 0;
        }
		
        private function progressHandler(event:ProgressEvent):void 
        {   
			m_loadProgress.fileProgress.value = event.bytesLoaded / event.bytesTotal;
			m_loadProgress.totalProgress.value = (m_curUploadSize+event.bytesLoaded) / m_totalUploadSize;
        }
        
        private function completeHandler(event:Event):void
        {
			m_loadProgress.fileName.text = "";
			
	        m_curUploadSize += m_fileReference.size;
        	nextUpload();
        }
        
        private function onCompleteData(event:DataEvent):void
        {
        }

        // only called if there is an  error detected by flash player browsing or uploading a file   
        private function ioErrorHandler(event:IOErrorEvent):void
        {
            //trace('And IO Error has occured:' +  event);
            m_debugLog.addWarning("ioError\n"+String(event));
        }    
        
        // only called if a security error detected by flash player such as a sandbox violation
        private function securityErrorHandler(event:SecurityErrorEvent):void
        {
            m_debugLog.addWarning("Security Error\n"+String(event));
        }

        //  after a file upload is complete or attemted the server will return an http status code, code 200 means all is good anything else is bad.
        private function httpStatusHandler(event:HTTPStatusEvent):void 
        {
            if (event.status != 200)
            {
                m_debugLog.addWarning("Status Error\n"+String(event));
            }
        }
        
        
        private function uploadResource(i_fileName:String, i_url:String):void
        {
			m_loadProgress.fileProgress.value = 0;
			var userName:String = m_framework.StateBroker.GetState("userName") as String;
			var userPassword:String = m_framework.StateBroker.GetState("userPassword") as String;
			m_cryptoService.businessEncrypt(onEncryptUploadResource, userName, userPassword, i_fileName, i_url);        	
		}		  			

		private function onEncryptUploadResource(i_encryptRequest:IEncryptRequest):void
        {
    		m_dataBaseService.UploadResource(i_encryptRequest.output);
        }        
        
        private function uploadSnapshots():void
        {
        	try
        	{
				if (ResourceService==null)
					return;		
				var userName:String = m_framework.StateBroker.GetState("userName") as String;
				var userPassword:String = m_framework.StateBroker.GetState("userPassword") as String;
		       	var snapshots:Dictionary = ResourceService(m_resourceService).getSnapshots(); //???
		       	var key:String = null; 
	        	for(key in snapshots)
	        	{
	        		break;
	        	}
	        	
	        	if (key!=null)
	        	{
	        		var keyLista:Array = key.split("_");
	        		var tableName:String = keyLista[0];
	        		var group:String = keyLista[1];
	        		var handle:int = int(keyLista[2]);
	        		var rec:Record = m_databaseManager.getTable(tableName).getRec(handle);
	        		if (rec==null)  
	        		{
	        			// case: 1. add new resource 2. capture 3. deleted resource 4. save
	        			delete snapshots[key];
	        			nextUpload();
	        			return;
	        		}
	        		var encryptRequest:IEncryptRequest;
	        		if (rec.native_id==-1)
	        		{
	        			encryptRequest = m_cryptoService.businessEncrypt(onEncryptUploadSnapshot, userName, userPassword, "new", tableName, group, handle.toString()+".png");
	        		}
	        		else
	        		{
	        			encryptRequest = m_cryptoService.businessEncrypt(onEncryptUploadSnapshot, userName, userPassword, "update", tableName, group, rec.native_id.toString()+".png");
	        		}
	        		encryptRequest.data = key;
	        	}
	        }
	        catch(error:Error)
	        {
	        	m_debugLog.addException(error);
	        }
        }
        
        private function onEncryptUploadSnapshot(i_encryptRequest:IEncryptRequest):void
        {
        	var snapshots:Dictionary = ResourceService(m_resourceService).getSnapshots(); //???
        	var key:String = String(i_encryptRequest.data);
    		m_dataBaseService.UploadSnapshot(i_encryptRequest.output, snapshots[key]);
    		delete snapshots[key];
        }
        
        private function onUploadSnapshot(event:ResultEvent):void
        {
        	nextUpload();
        }
        
        private function onUploadResource(event:ResultEvent):void
        {
        	m_curUploadSize += m_tmpResourceSize;
			m_loadProgress.totalProgress.value = m_curUploadSize / m_totalUploadSize;
        	nextUpload(); 
        }
        
        ///////////////
        private function postBusinessServer(i_filename:String):void
        {
			var userName:String = m_framework.StateBroker.GetState("userName") as String;
			var userPassword:String = m_framework.StateBroker.GetState("userPassword") as String;
			m_cryptoService.businessEncrypt(businessUpload, userName, userPassword, i_filename, m_uploadPath);
        }
        
        private function businessUpload(i_encryptRequest:IEncryptRequest):void
        {
			var uploadURL:URLRequest = new URLRequest();
			var variables:URLVariables = new URLVariables(); //variables to passed along to the file upload handler on the server.
	        variables.encryptedData = i_encryptRequest.output;
	        uploadURL.url = "http://" + m_businessDomain+"/WebService/MyUpload.aspx"; //??? https
	        uploadURL.method = "GET"; 
	        uploadURL.data = variables;
	        uploadURL.contentType = "multipart/form-data";
            m_fileReference.addEventListener(Event.OPEN, openHandler);
            m_fileReference.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            m_fileReference.addEventListener(Event.COMPLETE, completeHandler);
            m_fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
            m_fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
            m_fileReference.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
            m_fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);
            m_fileReference.upload(uploadURL);
        }
        
        
		private function postAmazonServer(i_filename:String):void 
		{
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			var accessKeyId:String = "01C3C4TMNJBQPVV0PM02";
			var bucket:String = "media_signage_business"+businessId;
			var key:String = "resources/"+i_filename;
            var options:S3PostOptions = new S3PostOptions();
            options.secure = false;
            options.acl = "public-read";
            options.contentType = "image/jpeg";
            options.policy = m_policy;
            options.signature = m_signature;
			
			
            // create the post request
            m_s3PostRequest = new S3PostRequest(accessKeyId, bucket, key, options);
            
            // hook up the user interface
            m_s3PostRequest.addEventListener(Event.OPEN, openHandler);
            m_s3PostRequest.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            m_s3PostRequest.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            m_s3PostRequest.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            m_s3PostRequest.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);
            try 
            {
                // submit the post m_s3PostRequest
                m_s3PostRequest.upload(m_fileReference);
            } 
            catch(e:Error) 
            {
            	m_debugLog.addWarning("postAmazonServer Error\n"+e.toString());
            }
        }
        
		private function onAmazonPolicy(event:ResultEvent):void
		{
			var xmlPolicy:XML = XML(event.result);
			m_policy 	= xmlPolicy.@policy;
			m_signature = xmlPolicy.@signature;
			submitData();
		}
		
		private function submitData():void
		{
			var xmlChangelist:XML = m_databaseManager.getChangelist();
			var userName:String = m_framework.StateBroker.GetState("userName") as String;
			var userPassword:String = m_framework.StateBroker.GetState("userPassword") as String;
			var changeList:String = xmlChangelist.toXMLString();
			var encryptRequest:IEncryptRequest = m_cryptoService.businessEncrypt(doSubmitData, userName, userPassword, getChecksum(changeList));
			var base64Encoder:Base64Encoder = new Base64Encoder();
			base64Encoder.encodeUTFBytes(changeList);
			encryptRequest.data = base64Encoder.toString();
		}
		
		private function doSubmitData(i_encryptRequest:IEncryptRequest):void
		{
			m_dataBaseService.CommitSubmit(i_encryptRequest.output, i_encryptRequest.data)
		}
		
		private function getChecksum(i_changeList:String):Number
		{
			var checksum:Number = 0;
			for(var i:int=0; i<i_changeList.length;i++)
			{
				checksum+=int(i_changeList.charCodeAt(i));
			}
			return checksum;
		}
		
		protected function closeTransaction():void
		{
   			PopUpManager.removePopUp(m_loadProgress);
   			m_loadProgress = null;
   			removeTimer();
			finish();
		}
		
		private function removeTimer():void
		{
			if (m_timeoutTimer!=null)
			{
	   			m_timeoutTimer.stop();
	   			m_timeoutTimer.removeEventListener(TimerEvent.TIMER, onTimeoutTimer);
	   			m_timeoutTimer = null;
	  		}
		}
	}
}