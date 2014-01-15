package
{
	public class AdExtStat extends AdStat implements IAdExtStat
	{
		private var m_adContent:AdExtContent;
		private var m_expectedCount:int = 0;
		
		
		public function AdExtStat(i_adContent:AdExtContent, i_rate:Number, i_curSeconds:Number)
		{
			super(i_rate);
			m_adContent = i_adContent;
			m_expectedCount = (i_curSeconds/3600) * m_adContent.reparationsPerHour;
		}
		
		public function get adContent():IAdExtContent
		{
			return m_adContent;
		}
		
		public function playNow(i_curSeconds:Number):Boolean
		{
			var expectedCount:int = (i_curSeconds/3600) * m_adContent.reparationsPerHour;
			if (expectedCount>=m_expectedCount)
			{
				m_expectedCount++;
				return true;
			}
			return false;
		}
		
		public override function flush():XML
		{
			var xmlStat:XML = super.flush();
			xmlStat.@domain = m_adContent.adPackage.adDomainBusiness.adDomain.name;
			xmlStat.@businessId = m_adContent.adPackage.adDomainBusiness.businessId;
			xmlStat.@packageId = m_adContent.adPackage.packageId;
			xmlStat.@contentId = m_adContent.contentId;
			
			return xmlStat;
		}
	}
}