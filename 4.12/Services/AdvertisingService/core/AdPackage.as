package
{
	public class AdPackage implements IAdPackage
	{
		private var m_adDomainBusiness:AdDomainBusiness;
		private var m_packageId:int;
		private var m_name:String;
		private var m_startDate:Date;
		private var m_endDate:Date;
		
		private var m_adPackageStations:Object = new Object();
		private var m_adPackageContents:Array = new Array();
		
		public function AdPackage(i_adDomainBusiness:AdDomainBusiness, i_packageId:int)
		{
			m_adDomainBusiness = i_adDomainBusiness;
			m_packageId = i_packageId;
		}
		
		public function get packageId():int
		{
			return m_packageId;
		}
		
		public function update(i_contents:Array, i_xmlPackage:XML):void
		{
			m_name = i_xmlPackage.@name;
			var date1:Array = i_xmlPackage.@startDate.split('/');
			var date2:Array = i_xmlPackage.@endDate.split('/');
			
			m_startDate = new Date(date1[2], int(date1[0])-1, date1[1]);
			m_endDate = new Date(date2[2], int(date2[0])-1, int(date2[1])+1);
			
			var adContent:AdExtContent;
			for each(var xmlContent:XML in i_xmlPackage.Contents.*)
			{
				var contentId:int = xmlContent.@id;
				adContent = new AdExtContent(this, contentId, xmlContent);
				m_adPackageContents.push(adContent);
				adContent.update(xmlContent);
				
				i_contents.push(adContent);
			}
			
			for each(var xmlStation:XML in i_xmlPackage.Stations.*)
			{
				var packageStationId:int = xmlStation.@packageStationId;
				var toStationId:int = xmlStation.@toStationId;
				var adStation:AdStation = new AdStation(this, packageStationId, toStationId);
				m_adPackageStations[packageStationId] = adStation;
				adStation.update(xmlStation);
			}
		}
		
		public function get adDomainBusiness():IAdDomainBusiness
		{
			return m_adDomainBusiness;
		}
		
		public function get name():String
		{
			return m_name;
		}

		public function get startDate():Date
		{
			return m_startDate;
		}

		public function get endDate():Date
		{
			return m_endDate;
		}
		
		public function get contents():Array
		{
			return m_adPackageContents; 
		}
		
		public function getPackageStation(i_adPackageStationId:int):IAdStation
		{
			return m_adPackageStations[i_adPackageStationId]; 
		}
		
		public function needToPlay(i_date:Date, i_packageStationId:int):Boolean
		{
			var day:int = 1<<int(i_date.day);
			var hour:int = i_date.hours;
			var seconds:Number = i_date.minutes * 60 +  i_date.seconds;
			if (i_date>=startDate && i_date<=endDate)
			{
				for each(var adStation:AdStation in m_adPackageStations)
				{
					if (adStation.toStationId==i_packageStationId)
					{
						if (hour>=adStation.hourStart && hour<=adStation.hourEnd &&	(adStation.daysMask & day)!=0 )
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
	}
}