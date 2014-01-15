package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayList;
	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.Base64Encoder;
	
	public class AdvertisingService extends EventDispatcher implements IAdvertisingService
	{
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_loaderManager:ILoaderManager;
		protected var m_resourceService:IResourceService;
		protected var m_businessDomain:String
		
		private var m_adReport:AdReport;
		
		private var m_businessId:int = -1;
		private var m_stationId:int = -1;
		
		private var m_stationRate:Rate;
		
		private var m_adSubDomainMap:Object;
		private var m_businessesToLoad:Array = new Array();
		
		private var m_adOutBusinessMap:Object;
		
		private var m_contents:Array;
		
		private var m_playIndex:int = -1;
		private var m_workingHour:String = null;
		
		private var m_hourMap:Object = new Object();
		
		
		private var m_oldDate:Date;
		private var m_curDate:Date;
		private var m_curSeconds:int;
		
		private var m_GetBusinessAds:PostService;
		private var m_FlushStationStats:PostService;

		
		private var m_businessAdsFnc:Function;
		private var m_businessAdsData:Object;
		
		
		private var m_xmlFlashStats:XML = null;
		private var m_flushing:Boolean = false;
		private var m_panddingStats:Boolean = false;
		
		
		public function AdvertisingService(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_loaderManager = m_framework.ServiceBroker.QueryService("LoaderManager") as ILoaderManager;
			m_resourceService = m_framework.ServiceBroker.QueryService("ResourceService") as IResourceService;
			m_businessDomain = m_framework.StateBroker.GetState("businessDomain") as String;
			
			m_adReport = createAdReport();
			
			
			
			m_GetBusinessAds = new PostService("http://"+m_businessDomain+"/WebService/AdvertisingService.asmx", "GetBusinessAds", "i_businessId", "i_stationId");
			m_GetBusinessAds.addEventListener(FaultEvent.FAULT, onBusinessAdsFault);
			m_GetBusinessAds.addEventListener("result", onBusinessAdsResult);
			
			m_FlushStationStats = new PostService("http://"+m_businessDomain+"/WebService/AdvertisingService.asmx", "FlushStationStats", "i_stationStats");
			m_FlushStationStats.addEventListener(FaultEvent.FAULT, onFlushStationStatsFault);
			m_FlushStationStats.addEventListener("result", onFlushStationStatsResult);
			
			m_oldDate = new Date();
		} 
		
		
		public function setStationRates(i_rateMap:String, hourRate0:Number, hourRate1:Number, hourRate2:Number, hourRate3:Number):void
		{
			m_stationRate = new Rate(i_rateMap, hourRate0, hourRate1, hourRate2, hourRate3);
		}
		
		public function getLocalPackages():ArrayList
		{
			var localPackageList:ArrayList = new ArrayList();
			var keys:Array = m_dataBaseManager.table_ad_local_packages.getAllPrimaryKeys();
			for each(var hAdLocalPackage:int in keys)
			{
				var recAdLocalPackage:Rec_ad_local_package = m_dataBaseManager.table_ad_local_packages.getRecord(hAdLocalPackage);
				if (recAdLocalPackage.enabled==false)
					continue;
				
				var localPackage:Object = new Object();
				localPackage.hAdLocalPackage = recAdLocalPackage.ad_local_package_id;
				localPackage.label = recAdLocalPackage.package_name;
				localPackageList.addItem(localPackage);
			}
			return localPackageList;
		}
		
		
		
		public function get adReport():IAdReport
		{
			return m_adReport;
		}
		
		protected function createAdReport():AdReport
		{
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			return new AdReport(m_framework, this, m_businessDomain, businessId);
		}
		
		public function getBusiness(i_domain:String, i_businessId:int):IAdDomainBusiness
		{
			if (m_adSubDomainMap==null)
				return null;
			
			for each(var adDomain:AdDomain in m_adSubDomainMap)
			{
				var adDomainBusiness:IAdDomainBusiness = adDomain.getAdDomainBusiness(i_businessId);
				if (adDomainBusiness!=null)
					return adDomainBusiness;
			}
			
			return null;
		}
		
		public function getAdOutPackageStationStatus(i_businessId:int, i_packageId:int, i_packageStationId:int):int
		{
			if (m_adOutBusinessMap==null)
				return 0;
			var adOutBusiness:AdOutBusiness = m_adOutBusinessMap[i_businessId];
			if (adOutBusiness==null)
				return 0;
			return adOutBusiness.getAdOutPackageStationStatus(i_packageId, i_packageStationId);
		}
		
		public function requestBusinessAds(i_businessId:int, i_stationId:int, i_callbackFnc:Function, i_callbackData:Object):void
		{
			clearAll();
			
			m_businessId = i_businessId;
			m_stationId = i_stationId;
			m_businessAdsFnc = i_callbackFnc;
			m_businessAdsData = i_callbackData;
			m_GetBusinessAds.call(i_businessId, i_stationId);
		}
		
		private function onBusinessAdsFault(event:FaultEvent):void
		{
			m_businessAdsFnc(false, m_businessAdsData);
		}
		
		private function onBusinessAdsResult(event:ResultEvent):void
		{
			var xmlResult:XML = XML(event.result);
			if (xmlResult.children().length()==0)
			{
				//Alert.show("GetBusinessAds return null");
				m_businessAdsFnc(false, m_businessAdsData);
				return;
			}
			m_adSubDomainMap = new Object();
			m_contents = new Array();
			
			
			
			for each(var xmlDomain:XML in xmlResult.Domains.*)
			{
				var subdomain:String = xmlDomain.@domain;
				var domain:String = subdomain.substr(subdomain.lastIndexOf('.', subdomain.lastIndexOf('.')-1)+1);
				var adDomain:AdDomain = m_adSubDomainMap[subdomain];
				if (adDomain==null)
				{
					m_adSubDomainMap[subdomain] = adDomain = new AdDomain(subdomain);	
				}
				adDomain.update(xmlDomain, m_businessesToLoad, m_contents);
			}
			
			
			m_adOutBusinessMap = new Object();
			for each(var xmlAdOutBusiness:XML in xmlResult.AdOutStatus.*)
			{
				var adOutBusinessId:int = xmlAdOutBusiness.@id;
				m_adOutBusinessMap[adOutBusinessId] = new AdOutBusiness(adOutBusinessId, xmlAdOutBusiness);
			}
			
			loadNextBusiness();		
		}
		
		private function loadNextBusiness():void
		{
			if (m_businessesToLoad.length==0)
			{
				setToMyBusiness();
				m_businessAdsFnc(true, m_businessAdsData);
				return;
			}
			var domainBusiness:Array = m_businessesToLoad.shift();
			var domain:String = String(domainBusiness[0]);
			var businessId:int = int(domainBusiness[1]);
			
			
			if (m_dataBaseManager.getDataBase(domain, businessId)==null)
			{
				m_dataBaseManager.createDataBase(domain, businessId);
			}
			
			m_loaderManager.selectDomainBusiness(domain, businessId);
			var tableRequest:ITableRequest = createTableRequest();
			//???m_loaderManager.request(tableRequest, true, true, false, onTableData);
			m_loaderManager.request(tableRequest, true, true, true, onTableData);
		}
		
		private function setToMyBusiness():void
		{
			var businessDomain:String = m_framework.StateBroker.GetState("businessDomain") as String;
			var businessDbName:String = String(m_framework.StateBroker.GetState("businessDbName"));
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			var businessResource:String = businessDomain + "/Resources/";
			m_loaderManager.selectDomainBusiness(businessDomain, businessId);
			m_resourceService.selectDomainBusiness(businessDomain, businessId);
		}
		
		protected function onTableData(i_result:Boolean):void
		{
			if (i_result==false)
			{
				trace("Warning: SignageStudioCtrl.mxml, onTableData()");
				return; // should never get here;					
			}
			loadNextBusiness();
		}
		
		private function createTableRequest():ITableRequest
		{
			var tableRequest:ITableRequest = m_loaderManager.CreateTableRequest();
			tableRequest.add("resources", "");
			tableRequest.add("player_data", "");
			return tableRequest;
		}
		
		
		public function  getPlayList():Array
		{
			var playList:Array;
			var year:int = m_curDate.fullYear;
			var month:int = m_curDate.month + 1;
			var date:int = m_curDate.date;
			var hour:int = m_curDate.hours;
			var key:String = year + "." +  month + "." + date + "." + hour;
			
			var hourStats:HourStats = m_hourMap[key] as HourStats;
			if (hourStats==null)
			{
				m_hourMap[key] = hourStats = new HourStats(year, month, date, hour);
			}
			
			if (m_workingHour==key)
			{
				playList = hourStats.getExtStats();
			}
			else
			{
				var rate:Number = 0;
				if (m_stationId==-1)
				{
					
				}
				else
				{
					if (m_stationRate!=null)
					{
						rate = m_stationRate.getRate(m_curDate);
					}
				}

				
				m_workingHour=key;
				
				hourStats.createExtStats();
				playList = hourStats.getExtStats();
				 
				if (m_contents!=null)
				{
					for(var i:int=0; i<m_contents.length; i++)
					{
						var adContent:AdExtContent = m_contents[i];
						if (m_stationId==-1 || AdPackage(adContent.adPackage).needToPlay(m_curDate, m_stationId))
						{
							var stat:AdExtStat = new AdExtStat(adContent, rate, m_curSeconds); //??? 
							playList.push(stat);
						}
					}
				}
			}
				
			return playList;
		}
		
		
		
		public function get nextExtStat():IAdExtStat
		{
			flushStatWhenRequired();
			
			
			m_curSeconds = m_curDate.minutes * 60 +  m_curDate.seconds;
			
			var playList:Array = getPlayList();
			
			for(var i:int=0;i<playList.length;i++)
			{
				m_playIndex++;
				if (m_playIndex>=playList.length)
					m_playIndex=0;
				var adStat:IAdExtStat = playList[m_playIndex];
				if (adStat.playNow(m_curSeconds)==true)
					return adStat;
			}
			return null;
		}
		
		
		
		
		
		public function getLocalStat(i_hAdLocalContent:int):IAdLocalStat
		{
			if (m_stationId==-1)
				return null;
			
			flushStatWhenRequired();
			
			var rate:Number = 0;
			if (m_stationId!=-1)
			{
				if (m_stationRate!=null)
				{
					rate = m_stationRate.getRate(m_curDate);
				}
			}

			
			var year:int = m_curDate.fullYear;
			var month:int = m_curDate.month + 1;
			var date:int = m_curDate.date;
			var hour:int = m_curDate.hours;
			var key:String = year + "." +  month + "." + date + "." + hour;
			var hourStats:HourStats = m_hourMap[key] as HourStats;
			if (hourStats==null)
			{
				m_hourMap[key] = hourStats = new HourStats(year, month, date, hour);
			}
			
			var localStats:Object = hourStats.getLocalStats();
			var stat:AdLocalStat = localStats[i_hAdLocalContent];
			if (stat==null)
			{
				setToMyBusiness();
				var recAdLocalContent:Rec_ad_local_content = m_dataBaseManager.table_ad_local_contents.getRecord(i_hAdLocalContent);
				if (recAdLocalContent.enabled)
				{
					localStats[i_hAdLocalContent] = stat = new AdLocalStat(recAdLocalContent.native_id, rate);
				}
			}
			 
			return stat;
		}
		
		
		
		private function flushStatWhenRequired():void
		{
			m_curDate = new Date();
			if (m_oldDate==null)
				m_oldDate = m_curDate;
			
			//if (m_curDate.time-m_oldDate.time>600000)  // every 10 min
			if (m_curDate.time-m_oldDate.time>60000)  // every 1 min ???????
			{ 
				m_oldDate = m_curDate;
				flushStats();
			}
		}
		
		
		public function flushStats():void
		{
			if (m_stationId==-1 || m_curDate==null)
				return;
			
			if (m_flushing)
				return;
			
			m_oldDate = m_curDate;
			
			if (m_xmlFlashStats==null)
			{
				var year:int = m_curDate.fullYear;
				var month:int = m_curDate.month + 1;
				var date:int = m_curDate.date;
				var hour:int = m_curDate.hours;
				var curKey:String = year + "." +  month + "." + date + "." + hour;
				
				
				m_xmlFlashStats = <StationStats/>;
				m_xmlFlashStats.@businessId = m_businessId;
				m_xmlFlashStats.@stationId = m_stationId;
				var removeKeys:Array = new Array();
				for(var key:String in m_hourMap)
				{
					var hourStats:HourStats = m_hourMap[key] as HourStats;
					var xmlHourStas:XML = hourStats.flushStats();
					
					m_xmlFlashStats.appendChild(xmlHourStas);
					
					if (curKey!=key)
					{
						removeKeys.push(key);
					}
				}
				
				for each(var removeKey:String in removeKeys)
				{
					delete m_hourMap[removeKey];
				}
			}
			
			var base64Encoder:Base64Encoder = new Base64Encoder();
			base64Encoder.encodeUTFBytes(m_xmlFlashStats.toXMLString());
			m_FlushStationStats.call(base64Encoder.toString());
			
			m_flushing = true;
		}
		
		private function onFlushStationStatsFault(event:FaultEvent):void
		{
			m_flushing = false;
			m_panddingStats = true;
		}
		
		private function onFlushStationStatsResult(event:ResultEvent):void
		{
			m_flushing = false;
			
			if (Boolean(XML(event.result).toString()=="true"))
			{
				m_xmlFlashStats = null;
				
				if (m_panddingStats)
				{
					m_panddingStats = false;
					flushStats();
				}
			}
		}
		
		
		private function clearAll():void
		{
			var removeKeys:Array = new Array();
			for(var key:String in m_hourMap)
			{
				removeKeys.push(key);
			}
			
			for each(var removeKey:String in removeKeys)
			{
				delete m_hourMap[removeKey];
			}
		}
		
	}
}

