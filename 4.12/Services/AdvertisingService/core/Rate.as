package
{
	public class Rate
	{
		private var m_map:Array;
		private var m_rates:Array;
		
		public function Rate(i_rateMap:String, hourRate0:Number, hourRate1:Number, hourRate2:Number, hourRate3:Number)
		{
			m_map = i_rateMap.split('');
			m_rates = new Array();
			m_rates[0] = hourRate0;
			m_rates[1] = hourRate1;
			m_rates[2] = hourRate2;
			m_rates[3] = hourRate3;
		}
		
		public function getRate(i_date:Date):Number
		{
			var index:int = i_date.day * 24 + i_date.hours  
			
			return m_rates[ int(m_map[index]) ];
		}
	}
}
