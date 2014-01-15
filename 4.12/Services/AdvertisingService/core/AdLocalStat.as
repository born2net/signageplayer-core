package
{
	public class AdLocalStat extends AdStat implements IAdLocalStat
	{
		private var m_adLocalContentId:int;
		
		
		public function AdLocalStat(i_adLocalContentId:int, i_rate:Number)
		{
			super(i_rate);
			m_adLocalContentId = i_adLocalContentId;
		}
		
		
		public override function flush():XML
		{
			var xmlStat:XML = super.flush();
			xmlStat.@local = "1";
			xmlStat.@contentId = m_adLocalContentId;
			return xmlStat;
		}

	}
}
