package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.XMLListCollection;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class AdReport extends EventDispatcher implements IAdReport
	{
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_advertiseService:IAdvertisingService;
		private var m_RequestReport:PostService;
		private var m_DeleteReport:PostService;
		
		
		private var m_businessId:int;
		
		private var m_year:int;
		private var m_month:int;
		private var m_requestReportCallback:Function;
		private var m_deleteReportCallback:Function
		private var m_reportCollection:XMLListCollection = null;
		private var m_reportData:Object = null;
		
		private var m_selectedDomain:String;
		private var m_selectedBusinessId:int;		
		private var m_selectedReport:Array;
		
		
		protected var m_aggregateHourly:Boolean;
		protected var m_aggregateDaily:Boolean;		
		protected var m_aggregatePackage:Boolean;
		protected var m_aggregateContent:Boolean;
		protected var m_aggregateStation:Boolean;
		
		protected var m_filterReportData:ArrayCollection;
		private var m_chartData:ArrayCollection;
		private var m_serieses:Object;
		private var m_totalCount:int = 0;
		private var m_totalTime:Number = 0;
		private var m_totalMPH:Number = 0;
		private var m_totalPrice:Number = 0;

		private var m_timeFormatter:TimeFormatter;
		private var m_formatterPrecision2:NumberFormatter;
			
		public function AdReport(i_framework:IFramework, i_advertiseService:IAdvertisingService, i_businessDomain:String, i_businessId:int)
		{
			m_framework = i_framework;
			m_businessId = i_businessId;
			m_advertiseService = i_advertiseService;
			
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			
			m_timeFormatter = new TimeFormatter();
			m_formatterPrecision2 = new NumberFormatter();
			m_formatterPrecision2.precision = 2;
			
			m_RequestReport = new PostService("http://"+i_businessDomain+"/WebService/AdvertisingService.asmx", "RequestReport", "i_businessId", "i_year", "i_month");
			m_RequestReport.addEventListener(FaultEvent.FAULT, onRequestReportFault);
			m_RequestReport.addEventListener("result", onRequestReportResult);
			
			m_DeleteReport = new PostService("http://"+i_businessDomain+"/WebService/AdvertisingService.asmx", "DeleteReport", "i_businessId", "i_fromDomain", "i_fromBusinessId", "i_year", "i_month");
			m_DeleteReport.addEventListener(FaultEvent.FAULT, onDeleteReportFault);
			m_DeleteReport.addEventListener("result", onDeleteReportResult);
		}
		
		public function requestReport(i_businessId:int, i_year:int, i_month:int, i_requestReportCallback:Function):void
		{
			m_year = i_year;
			m_month = i_month;
			m_requestReportCallback = i_requestReportCallback;
			m_RequestReport.call(i_businessId, i_year, i_month);
		}
		
		private function onRequestReportFault(event:FaultEvent):void
		{
			m_requestReportCallback(false);
			m_requestReportCallback = null;
		}
		
		private function onRequestReportResult(event:ResultEvent):void
		{
			m_reportData = new Object();
			m_reportCollection = new XMLListCollection();
			var xmlReport:XML = new XML(event.result);
			
			
			var extFields:Array = xmlReport.Fields.ExtStat.toString().split(',');
			var localFields:Array = xmlReport.Fields.LocalStat.toString().split(',');
			
			for each(var xmlDomain:XML in xmlReport.Data.*)
			{
				var nodeDomain:XML = <Domain/>;
				nodeDomain.@label = String(xmlDomain.@name);
				m_reportCollection.addItem(nodeDomain);
				for each(var xmlBusiness:XML in xmlDomain.*)
				{
					var businessId:int = int(xmlBusiness.@businessId);
					var nodeBusiness:XML = <Business/>;
					nodeBusiness.@id = businessId;
					nodeDomain.appendChild(nodeBusiness);
					
					if (businessId!=m_businessId)
					{
						nodeBusiness.@label = xmlBusiness.@businessName;
					}
					else
					{
						var businessName:String = m_framework.StateBroker.GetState("businessName") as String;
						nodeBusiness.@label = businessName + " (Local)";
					}
					var domainBusinessStats:Array = new Array();
					var hBranchStation:int;
					var recBranchStation:Rec_branch_station;
					for each(var xmlStat:XML in xmlBusiness.*)
					{
						var stat:Object = new Object();
						var i:int = 0;
						for each(var value:String in xmlStat.toString().split(','))
						{
							var statName:String = xmlStat.name();
							var fields:Array;
							var field:String;
							if (statName=="ExtStat")
							{
								field = extFields[ i++ ];
								
								if (field=="stationId")
								{
									hBranchStation = m_dataBaseManager.table_branch_stations.getHandle(int(value));
									recBranchStation = m_dataBaseManager.table_branch_stations.getRecord(hBranchStation);
									stat["stationName"] = recBranchStation.station_name;
								}
								
								stat[field] = value;
							}
							else
							{
								field = localFields[ i++ ];
								if (field=="localContentId")
								{
									stat["packageContentId"] = value;
									var hAdLocalContent:int = m_dataBaseManager.table_ad_local_contents.getHandle(int(value));
									var recAdLocalContent:Rec_ad_local_content = m_dataBaseManager.table_ad_local_contents.getRecord(hAdLocalContent);
									if (recAdLocalContent!=null)
									{
										var recAdLocalPackage:Rec_ad_local_package = m_dataBaseManager.table_ad_local_packages.getRecord(recAdLocalContent.ad_local_package_id);
										stat["contentName"] = recAdLocalContent.content_name;
										stat["packageId"] = recAdLocalPackage.package_name;
										stat["packageName"] = recAdLocalPackage.package_name;
									}
								}
								if (field=="stationId")
								{
									hBranchStation = m_dataBaseManager.table_branch_stations.getHandle(int(value));
									recBranchStation = m_dataBaseManager.table_branch_stations.getRecord(hBranchStation);
									stat["stationName"] = (recBranchStation!=null) ? recBranchStation.station_name : "[Deleted]";
								}
								stat[field] = value;
							}
							
						}
						domainBusinessStats.push(stat);
					}
					
					var key:String = String(xmlDomain.@name) + "." + String(xmlBusiness.@businessId);
					m_reportData[key] = domainBusinessStats;
				}
			}
			m_requestReportCallback(true);
			m_requestReportCallback = null;
		}
		
		public function get reportCollection():XMLListCollection
		{
			return m_reportCollection;
		}
		
		public function selectDomainBusiness(i_domain:String, i_businessId:int):void
		{
			m_selectedDomain = i_domain;
			m_selectedBusinessId = i_businessId;
			
			var reportKey:String = i_domain + "." + i_businessId;
			m_selectedReport = m_reportData[reportKey];
			m_totalCount = 0;
			m_totalTime = 0;
			m_totalMPH = 0;
			m_totalPrice = 0;
			var price:Number;
			
			for each(var stat:Object in  m_selectedReport)
			{
				var rate:Number = stat.rate;
				var duration:Number = stat.duration;
				price = int((rate * duration) / 0.36) / 10000;
				stat["price"] = price;
				m_totalCount += int(stat.counts);
				m_totalTime += duration;
				m_totalMPH += Number(stat.mph);
				m_totalPrice += price;
			}
			
			dispatchEvent( new Event("event_report_selected") );
		}
		
		public function createReportData(i_aggregateHourly:Boolean, i_aggregateDaily:Boolean, i_aggregatePackage:Boolean, i_aggregateContent:Boolean, i_aggregateStation:Boolean):void
		{
			m_aggregateHourly = i_aggregateHourly;
			m_aggregateDaily = i_aggregateDaily;
			m_aggregatePackage = i_aggregatePackage;
			m_aggregateContent = i_aggregateContent;
			m_aggregateStation = i_aggregateStation;
			
			var price:Number;
			var stat:Object;
			
			m_filterReportData = new ArrayCollection();
			var aggregateMap:Object = new Object();
			for each(stat in  m_selectedReport)
			{
				var key:String = "k";
				if (m_aggregateDaily==true)
				{
					key +=  "."  + stat.day;
				}
				if (m_aggregateHourly==true)
				{
					key += "." + stat.hour;
				}
				if (i_aggregatePackage==true)
				{
					key += "." + stat.packageId;
				}
				if (i_aggregateContent==true)
				{
					key += "." + stat.packageContentId;
				}
				if (i_aggregateStation==true)
				{
					key += "." + stat.stationId;
				}
				
				
				var aggregateStat:Object = aggregateMap[key];
				if (aggregateStat==null)
				{
					aggregateMap[key] = aggregateStat = new Object();
					aggregateStat.day = stat.day;
					aggregateStat.hour = stat.hour;
					aggregateStat.packageName = stat.packageName;
					aggregateStat.contentName = stat.contentName; 
					aggregateStat.stationName = stat.stationName;
					aggregateStat.rate = stat.rate;
					aggregateStat.counts = int(stat.counts);
					aggregateStat.duration = int(stat.duration);
					aggregateStat.mph = Number(stat.mph);
					aggregateStat.price = Number(stat.price);
					m_filterReportData.addItem(aggregateStat);
				}
				else
				{
					aggregateStat.counts = int(aggregateStat.counts) + int(stat.counts);
					aggregateStat.duration = int(aggregateStat.duration) + int(stat.duration);
					aggregateStat.mph = Number(aggregateStat.mph) + Number(stat.mph);
					aggregateStat.price = Number(aggregateStat.price) + Number(stat.price);
				}
			}
			
			for each(stat in m_filterReportData.source)
			{
				var day:int = stat.day;
				stat.dateLabel = m_month + "/" + day + "/" + m_year;
				var hour:int = stat.hour;
				stat.timeLabel = hour + ":" + "xx";  
				
				stat.durationLabel = m_timeFormatter.format( Number(stat.duration) );
				
				stat.avgMP = (stat.duration==0) ? 0 : m_formatterPrecision2.format( 3600 * Number(stat.mph) / Number(stat.duration) );
			}
			
			var sort:Sort = new Sort();
			sort.compareFunction = onCompareTime;
			m_filterReportData.sort = sort;
			m_filterReportData.refresh();
		}
		
		private function onCompareTime(a:Object, b:Object, array:Array = null):int
		{ 
			var t1:int = 0;
			var t2:int = 0;
			if (m_aggregateDaily && m_aggregateHourly)
			{
				t1 = Number(a.day) * 24 + Number(a.hour); 
				t2 = Number(b.day) * 24 + Number(b.hour);
			}
			else if (m_aggregateDaily)
			{
				t1 = Number(a.day);	
				t2 = Number(b.day);
			}
			else if (m_aggregateHourly)
			{
				t1 = Number(a.hour);	
				t2 = Number(b.hour);
			}
			if (t1==t2)
				return 0;
			return (t1<t2) ? -1 : 1;
		}		
		
		public function get reportData():ArrayCollection
		{
			return m_filterReportData;
		}
		
		public function exportReport():Boolean
		{
			return false;
		}
		
		
		public function deleteReport(i_deleteReportCallback:Function):void
		{
			m_deleteReportCallback = i_deleteReportCallback;
			m_DeleteReport.call(m_businessId, m_selectedDomain, m_selectedBusinessId, m_year, m_month);
		}
		
		
		private function onDeleteReportFault(event:FaultEvent):void
		{
			m_deleteReportCallback(false);
			m_deleteReportCallback = null;
		}
		
		private function onDeleteReportResult(event:ResultEvent):void
		{
			var reportKey:String = m_selectedDomain + "." + m_selectedBusinessId;
			delete m_reportData[reportKey];
			m_selectedReport = null;
			m_filterReportData = new ArrayCollection();
			m_totalCount = 0;
			m_totalTime = 0;
			m_totalMPH = 0;
			m_totalPrice = 0;
			
			
			m_deleteReportCallback(true);
			m_deleteReportCallback = null;
		}		
		
		public function createChartData(i_aggregateHourly:Boolean, i_aggregateDaily:Boolean, i_dsplay:String):void
		{
			m_serieses = new Object();
			var price:Number;
			var stat:Object;
			var pie:Boolean = (i_aggregateDaily==false && i_aggregateHourly==false);
			
			var array:Array = new Array();
			array.length = pie ? 0 : 744;
			
			var xMap:Object = new Object();
			var aggregateMap:Object = new Object();
			var maxIndex:int = -1;
			for each(stat in  m_selectedReport)
			{
				var key1:String = "k";
				if (i_aggregateDaily)
				{
					key1 +=  "."  + stat.day;
				}
				if (i_aggregateHourly)
				{
					key1 += "." + stat.hour;
				}
				var key2:String = "stat";
				
				var yKey:String;
				
				switch(i_dsplay)
				{
					case "Package":
						key2 += "_" + stat.packageId;
						yKey = pie ? "pie" : key2;
						if (m_serieses[yKey]==null)
						{
							m_serieses[yKey] = stat.packageName;
						}
						break;
					case "Content":
						key2 += "_" + stat.packageContentId;
						yKey = pie ? "pie" : key2;
						if (m_serieses[yKey]==null)
						{
							m_serieses[yKey] = stat.contentName;
						}
						break;
					case "Station":
						key2 += "_" + stat.stationId;
						yKey = pie ? "pie" : key2;
						if (m_serieses[yKey]==null)
						{
							m_serieses[yKey] = stat.stationName;
						}
						break;
				}
				var xKey:String = pie ? key2 : key1;
				var xField:Object = xMap[xKey];
				if (xField==null)
				{
					xMap[xKey] = xField = new Object();
					xField.day = stat.day;
					xField.hour = stat.hour;
					
					if (pie)
					{
						array.push(xField);
					}
					else
					{
						var index:int = 0;
						if (i_aggregateDaily==true && i_aggregateHourly==true)
						{
							index = int(stat.day) * 24 + int(stat.hour);
							xField.date=stat.day+";"+stat.hour;
						} 
						else if (i_aggregateDaily==true)
						{
							index = int(stat.hour);
							xField.date=stat.hour;
						}
						else if (i_aggregateHourly==true)
						{
							index = int(stat.hour);
							xField.date=stat.hour;
						}
						maxIndex = Math.max(maxIndex, index);
						array[index] = xField;
					}
				}
				var countsKey:String = yKey + "_counts";
				var durationKey:String = yKey + "_duration";
				var priceKey:String = yKey + "_price";
				
				if (xField[countsKey]==null)
					xField[countsKey]= int(stat.counts);
				else
					xField[countsKey]= xField[countsKey] + int(stat.counts);
				
				if (xField[durationKey]==null)
					xField[durationKey]= Number(stat.duration);
				else
					xField[durationKey]= xField[durationKey] + Number(stat.duration);
				
				if (xField[priceKey]==null)
					xField[priceKey]= Number(stat.price);
				else
					xField[priceKey]= xField[priceKey] + Number(stat.price);
			}
			if (pie==false)
			{
				array.length = maxIndex+1;
			}
			m_chartData = new ArrayCollection(array);
		}
		
		public function get chartData():ArrayCollection
		{
			return m_chartData;
		}
		
		public function get serieses():Object
		{
			return m_serieses;
		}
		
		public function get totalCount():int
		{
			return m_totalCount;
		}

		public function get totalTime():Number
		{
			return m_totalTime;
		}

		public function get totalMPH():Number
		{
			return m_totalMPH;
		}

		public function get totalPrice():Number
		{
			return m_totalPrice;
		}
	}
}
