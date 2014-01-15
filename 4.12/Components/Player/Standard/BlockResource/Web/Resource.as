package
{
	public class Resource
	{
		private var m_hResource:int = -1;
		
		public function Resource(i_hResource:int)
		{
			m_hResource = i_hResource;
		}
		
		public function get hResource():int
		{
			return m_hResource;
		}
	}
}