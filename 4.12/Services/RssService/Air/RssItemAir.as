package
{
	import flash.filesystem.File;
	
	public class RssItemAir extends RssItem
	{
		private var m_mediaDest:File;
		private var m_title:String;
		private var m_mediaFileName:String = null;
		
		public function RssItemAir(i_xmlItem:XML, i_mediaDest:File, i_title:String)
		{
			super(i_xmlItem);
			m_mediaDest = i_mediaDest;
			m_title = i_title;
			if (m_mediaUrl!=null)
			{
				var array:Array = m_mediaUrl.split(".");
				var ext:String = array[array.length-1];
				var filename:String = m_mediaUrl.substr(0, m_mediaUrl.length-ext.length);
				filename = filename.toLocaleLowerCase();
				var myPattern:RegExp = /[\/~:|?&=.\-_() ]/g;
				m_mediaFileName = filename.replace(myPattern, "");
				m_mediaFileName = m_mediaFileName + "." + ext;
			}
		}

		public override function getMediaPath():String
		{
			if (m_mediaFileName==null)
				return null;
			var file:File = m_mediaDest.resolvePath(m_mediaFileName);
			var mediaPath:String = "app-storage:/Rss/"+m_title+"/"+m_mediaFileName;
			return (file.exists) ? mediaPath : getMediaUrl();
		}
		
		public function getMediaFileName():String
		{
			return m_mediaFileName;	
		}
	}
}