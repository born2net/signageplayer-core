package
{
	public class HourStats
	{
		private var m_year:int;
		private var m_month:int;
		private var m_day:int;
		private var m_hour:int;
		
		private var m_extStats:Array;
		private var m_localStats:Object;
		
		
		public function HourStats(i_year:int, i_month:int, i_day:int, i_hour:int)
		{
			m_year = i_year;
			m_month = i_month;
			m_day = i_day;
			m_hour = i_hour;
		}
		
		public function createExtStats():void
		{
			m_extStats = new Array();
		}
		
		public function getExtStats():Array
		{
			return m_extStats;
		}
		
		public function getLocalStats():Object
		{
			if (m_localStats==null)
				m_localStats = new Object();
			return m_localStats;
		}
		
		public function flushStats():XML
		{
			var xmlHourStas:XML = <HourStas/>;
			xmlHourStas.@year = m_year.toString();
			xmlHourStas.@month = m_month.toString();
			xmlHourStas.@day = m_day.toString();
			xmlHourStas.@hour = m_hour.toString();
			
			var adStat:AdStat;
			var xmlStat:XML;
			
			xmlHourStas.@ext = (m_extStats!=null) ? "1" : "0";
			xmlHourStas.@local = (m_localStats!=null) ? "1" : "0";
			
			if (m_extStats!=null)
			{
				for each(adStat in m_extStats)
				{
					xmlStat = adStat.flush();
					xmlHourStas.appendChild(xmlStat);
				}
			}
			if (m_localStats!=null)
			{
				for each(adStat in m_localStats)
				{
					xmlStat = adStat.flush();
					xmlHourStas.appendChild(xmlStat);
				}
			}
			
			return xmlHourStas;
		}
	}
}