package
{
	public class RssData
	{
		private var m_data:String;
		private var m_createdDate:Date;
		private var m_expiredTime:Number;
		
		public function RssData(i_data:String, i_expiredTime:Number, i_createdDate:Date)
		{
			m_data = i_data;
			m_expiredTime = i_expiredTime;
			m_createdDate = i_createdDate;
		}
		
		public function get data():String
		{
			return m_data;
		}
		
		public function get expiredTime():Number
		{
			return m_expiredTime;
		}
		
		public function get liveTime():Number
		{
			return ((new Date()).time - m_createdDate.time) / 60000;
		}
		
		public function get createdTime():Number
		{
			return m_createdDate.time;
		}
	}
}