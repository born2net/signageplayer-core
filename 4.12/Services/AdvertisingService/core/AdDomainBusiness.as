package
{
	public class AdDomainBusiness implements IAdDomainBusiness
	{
		private var m_adDomain:IAdDomain;
		private var m_businessId:int;
		private var m_businessName:String = "BBB";
		private var m_adPackageMap:Object = new Object();
		private var m_stationMap:Object = new Object();
		
		public function AdDomainBusiness(i_adDomain:IAdDomain, i_businessId:int)
		{
			m_adDomain = i_adDomain;
			m_businessId = i_businessId;
		}
		
		public function update(i_xmlBusiness:XML, i_contents:Array):void
		{
			m_businessName = i_xmlBusiness.@name;
			for each(var xmlPackage:XML in i_xmlBusiness.Packages.*)
			{
				var packageId:int = xmlPackage.@id;
				var adPackage:AdPackage = new AdPackage(this, packageId);
				m_adPackageMap[packageId] = adPackage;
				adPackage.update(i_contents, xmlPackage);
			}
			for each(var xmlStation:XML in i_xmlBusiness.Stations.*)
			{
				var stationId:int = int(xmlStation.@id);
				m_stationMap[stationId] = new AdDomainBusinessStation(stationId, xmlStation);
			}
		}
		
		public function get adDomain():IAdDomain
		{
			return m_adDomain;
		}
		
		public function get businessId():int
		{
			return m_businessId;
		}
		
		public function get name():String
		{
			return m_businessName;
		}
		
		public function getAdPackage(i_packageId:int):IAdPackage
		{
			return 	m_adPackageMap[i_packageId];
		}

		public function getStation(i_stationId:int):IAdDomainBusinessStation
		{
			return m_stationMap[i_stationId];
		}
	}
}
