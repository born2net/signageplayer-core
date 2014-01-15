package
{
	public class EmbeddedItem implements IRssItem
	{
		private var m_xmlItem:XML;
		
		public function EmbeddedItem(i_xmlItem:XML)
		{
			m_xmlItem = i_xmlItem;
		}
		
		public function get xml():XML
		{
			return m_xmlItem; 
		}
		
		public function getMediaPath():String
		{
			return null;
		} 
		
		public function getMediaDuration():Number
		{
			return -1;
		}
	}
}