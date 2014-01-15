package
{
	public class AdDomain implements IAdDomain
	{
		private var m_domain:String
		private var m_domainBusinessMap:Object = new Object();
		
		public function AdDomain(i_domain:String)
		{
			m_domain = i_domain;
		}
		
		public function update(i_xmlDomain:XML, i_businessesToLoad:Object, i_contents:Array):void
		{
			var domain:String = i_xmlDomain.@domain;
			for each(var xmlBusiness:XML in i_xmlDomain.*)
			{
				var businessId:int = xmlBusiness.@id;
				
				
				var adDomainBusiness:AdDomainBusiness = new AdDomainBusiness(this, businessId);
				if (m_domainBusinessMap[businessId]==null)
				{
					m_domainBusinessMap[businessId] = adDomainBusiness;
					var adIn:Boolean = (xmlBusiness.@adIn=="1");
					if (adIn)
					{
						i_businessesToLoad.push( [domain, businessId] );
					}
				}
				adDomainBusiness.update(xmlBusiness, i_contents);
			}
		}
		
		public function get name():String
		{
			return m_domain;
		}
		
		public function getAdDomainBusiness(i_businessId:int):AdDomainBusiness
		{
			return m_domainBusinessMap[	i_businessId ];
		}
		
	}
}