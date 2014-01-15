package
{
	public class AdOutBusiness
	{
		private var m_adOutBusinessId:int;
		private var m_adOutPackageMap:Object;
		
		public function AdOutBusiness(i_adOutBusinessId:int, i_xmlAdOutBusiness:XML)
		{
			m_adOutBusinessId = i_adOutBusinessId;
			m_adOutPackageMap = new Object();
			for each(var xmlAdOutPackage:XML in i_xmlAdOutBusiness.*)
			{ 
				var adOuPackageId:int = xmlAdOutPackage.@id;
				m_adOutPackageMap[adOuPackageId] = new AdOutPackage(adOuPackageId, xmlAdOutPackage);
			}
		}
		
		public function getAdOutPackageStationStatus(i_packageId:int, i_packageStationId:int):int
		{
			var adOutPackage:AdOutPackage = m_adOutPackageMap[i_packageId];
			if (adOutPackage==null)
				return 0;
			return adOutPackage.getAdOutPackageStationStatus(i_packageStationId);
		}
	}
}