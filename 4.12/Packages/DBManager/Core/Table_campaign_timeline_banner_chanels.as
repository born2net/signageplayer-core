package
{
    public class Table_campaign_timeline_banner_chanels extends Table
    {
        public function Table_campaign_timeline_banner_chanels(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timeline_banner_chanels"
            m_fields = [{field:"campaign_timeline_banner_chanel_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_banner_id", foriegn:"campaign_banners"}
                ,{field:"campaign_timeline_chanel_id", foriegn:"campaign_timeline_chanels"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline_banner_chanel
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline_banner_chanel;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline_banner_chanel;
		}
    }
}

