package
{
	public class TimelineChannel extends Channel
	{
		public function TimelineChannel(i_framework:IFramework)
		{
			super(i_framework);
			m_commonChannel = false;
		}

		public override function init(i_hChannel:int):void
		{
			super.init(i_hChannel);
			var recCampaignTimelineChanel:Rec_campaign_timeline_chanel = m_dataBaseManager.table_campaign_timeline_chanels.getRecord(m_hChannel);
			m_randomOrder = recCampaignTimelineChanel.random_order;
			m_repeatToFit = recCampaignTimelineChanel.repeat_to_fit;
			m_fixedPlayerLength = recCampaignTimelineChanel.fixed_players_length;
		}
	}
}