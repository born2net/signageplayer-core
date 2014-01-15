package
{
	public class RssItem implements IRssItem
	{
		protected var m_xmlItem:XML;
		
		protected var m_mediaUrl:String;
		protected var m_duration:Number = 0;
		
		public function RssItem(i_xmlItem:XML)
		{
			m_xmlItem = i_xmlItem;

			var media_content1:QName = new QName("http://search.yahoo.com/mrss/", "content");
			var media_content2:QName = new QName("http://search.yahoo.com/mrss", "content");
			if (XMLList(m_xmlItem.descendants(media_content1).@url).length()>0)
			{
				m_mediaUrl = m_xmlItem.descendants(media_content1).@url;
				if (XMLList(m_xmlItem.descendants(media_content1).@duration).length()>0)
				{
					m_duration = Number(m_xmlItem.descendants(media_content1).@duration);	
				}
			}
			else if (XMLList(m_xmlItem.descendants(media_content2).@url).length()>0)
			{
				m_mediaUrl = m_xmlItem.descendants(media_content2).@url;
				if (XMLList(m_xmlItem.descendants(media_content2).@duration).length()>0)
				{
					m_duration = Number(m_xmlItem.descendants(media_content2).@duration);	
				}
			}
			else if (XMLList(m_xmlItem.enclosure.@url).length()>0)
			{
				if (XMLList(m_xmlItem.enclosure.@type).length()>0)
				{
					m_mediaUrl = m_xmlItem.enclosure.@url;
				}
			}
		}

		public function getMediaPath():String
		{
			return m_mediaUrl;
		}
		
		public function getMediaUrl():String
		{
			return m_mediaUrl;
		}

		public function getMediaDuration():Number
		{
			return m_duration;
		}
		
		public function get xml():XML
		{
			return m_xmlItem;
		}
	}
}