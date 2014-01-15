package
{
	public class AdOutPackage
	{
		private var m_adOuPackageId:int;
		private var m_adOutPackageStationMap:Object;
		
		public function AdOutPackage(i_adOuPackageId:int, i_xmlAdOutPackage:XML)
		{
			m_adOuPackageId = i_adOuPackageId;
			m_adOutPackageStationMap = new Object();
			for each(var xmlPackageStation:XML in i_xmlAdOutPackage.*)
			{
				var adOutPackageStationId:int = xmlPackageStation.@id;
				var status:int = xmlPackageStation.@status;
				m_adOutPackageStationMap[adOutPackageStationId] = status;
			}
		}
		
		public function getAdOutPackageStationStatus(i_packageStationId:int):int
		{
			return m_adOutPackageStationMap[i_packageStationId];
		}
	}
}