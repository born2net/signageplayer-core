package
{
	public class AdvertisingServiceAir extends AdvertisingService
	{
		public function AdvertisingServiceAir(i_framework:IFramework)
		{
			super(i_framework);
		}
		
		protected override function createAdReport():AdReport
		{
			var businessId:int = int(m_framework.StateBroker.GetState("businessId"));
			return new AdReportAir(m_framework, this, m_businessDomain, businessId);
		}
	}
}