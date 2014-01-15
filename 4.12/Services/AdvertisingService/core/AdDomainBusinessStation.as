package
{
	public class AdDomainBusinessStation implements IAdDomainBusinessStation
	{
		private var m_stationName:String;
		
		public function AdDomainBusinessStation(i_stationId:int, i_xmlStation:XML)
		{
			m_stationName = i_xmlStation.@name;
		}
		
		public function get name():String
		{
			return m_stationName;
		}
			
	}
}

