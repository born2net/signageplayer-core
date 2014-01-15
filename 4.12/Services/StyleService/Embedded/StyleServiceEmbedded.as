package
{
	public class StyleServiceEmbedded extends StyleService
	{
		public function StyleServiceEmbedded(i_framework:IFramework, i_requestFontList:Boolean)
		{
			super(i_framework, i_requestFontList);
		}
		
		protected override function loadNext():void
		{
			if (m_count>0)
			{
				m_count--;
				var cssData:Array = m_loadingQueue.shift();
				m_currentUrl = cssData[0];
				m_styleCompletes[m_currentUrl] = true;
				dispatchEvent(new ServiceStyleEvent(ServiceStyleEvent.COMPLETE, m_currentUrl, 100) );
			}			
		}
	}
}