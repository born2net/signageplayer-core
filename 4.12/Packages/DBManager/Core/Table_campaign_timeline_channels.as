package
{
    public class Table_campaign_timeline_channels extends Table
    {
        public function Table_campaign_timeline_channels(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timeline_channels"
            m_fields = [{field:"campaign_timeline_channel_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline_channel
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline_channel;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline_channel;
		}
    }
}

