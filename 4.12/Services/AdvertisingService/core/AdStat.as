package
{
	public class AdStat implements IAdStat
	{
		protected var m_rate:Number = 0;
		protected var m_actualCount:int;
		protected var m_totalTime:Number;
		protected var m_MPH:Number;

		private var m_startTime:Number;
		private var m_width:Number;
		private var m_height:Number;
		
		
		public function AdStat(i_rate:Number)
		{
			m_rate = i_rate;
			m_actualCount = 0;
			m_totalTime = 0;
			m_MPH = 0;
		}
		
		
		private function getTime():Number
		{
			return new Date().time;
		}
		
		public function beginPlay(i_width:Number, i_height:Number):void
		{
			m_width = i_width;
			m_height = i_height;
			m_startTime = getTime();
			m_actualCount++;
		}
		
		public function updatePlay(i_width:Number, i_height:Number):void
		{
			m_width = i_width;
			m_height = i_height;
			var updateTime:Number = getTime();
			var duration:Number = (int((updateTime - m_startTime) / 100)) / 10;
			if (duration>0)
			{
				m_startTime = updateTime;
				m_totalTime += duration;
				var mph:Number = (int((m_width * m_height * duration) / 3600)) / 1000000;
				m_MPH += mph;
			}
		}
		
		public function finishPlay():void
		{
			var finishTime:Number = getTime();
			var duration:Number = (int((finishTime - m_startTime) / 100)) / 10;
			m_totalTime += duration;
			var mph:Number = (int((m_width * m_height * duration) / 3600)) / 1000000;
			m_MPH += mph;			
		}
		
		
		
		public function flush():XML
		{
			var xmlStat:XML = <Stat/>;
			xmlStat.@rate = m_rate;
			xmlStat.@count = m_actualCount;
			xmlStat.@totalTime = m_totalTime;
			xmlStat.@MPH = m_MPH;
			
			m_actualCount = 0;
			m_totalTime = 0;
			m_MPH = 0;
			
			return xmlStat;
		}

	}
}