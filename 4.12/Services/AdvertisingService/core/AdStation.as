package
{
	public class AdStation implements IAdStation
	{
		private var m_adPackage:AdPackage; 
		private var m_packageStationId:int;
		private var m_toStationId:int;
		
		private var m_daysMask:int;
		private var m_hourStart:int;
		private var m_hourEnd:int;
		
		public function AdStation(i_adPackage:AdPackage, i_packageStationId:int, i_toStationId:int)
		{
			m_adPackage = i_adPackage;
			m_packageStationId = i_packageStationId;
			m_toStationId = i_toStationId;
		}

		public function get adPackage():IAdPackage
		{
			return m_adPackage;
		}
		
		public function get packageStationId():int
		{
			return m_packageStationId;
		}
		
		public function get toStationId():int
		{
			return m_toStationId;
		}
		
		public function update(i_xmlStation:XML):void
		{
			m_daysMask = i_xmlStation.@daysMask;
			m_hourStart = i_xmlStation.@hourStart;
			m_hourEnd = i_xmlStation.@hourEnd;
		}
		
		public function get daysMask():int
		{
			return m_daysMask;
		}
		
		public function get hourStart():int
		{
			return m_hourStart;
		}
		
		public function get hourEnd():int
		{
			return m_hourEnd;
		}
	}
}
