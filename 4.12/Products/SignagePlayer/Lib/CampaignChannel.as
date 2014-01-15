package
{
	public class CampaignChannel extends Channel
	{
		public function CampaignChannel(i_framework:IFramework)
		{
			super(i_framework);
			m_commonChannel = true;
		}

		public override function init(i_hChannel:int):void
		{
			super.init(i_hChannel);
			var recCampaignChannel:Rec_campaign_channel = m_dataBaseManager.table_campaign_channels.getRecord(m_hChannel);
			m_randomOrder = recCampaignChannel.random_order;
			m_repeatToFit = recCampaignChannel.repeat_to_fit;
			m_fixedPlayerLength = recCampaignChannel.fixed_players_length;
		}
	}
}