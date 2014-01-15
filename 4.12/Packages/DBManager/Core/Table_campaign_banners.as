package
{
    public class Table_campaign_banners extends Table
    {
        public function Table_campaign_banners(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_banners"
            m_fields = [{field:"campaign_banner_id", foriegn:"campaign_banners"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns"}
                ,{field:"banner_name"}
                ,{field:"banner_width"}
                ,{field:"banner_height"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_banner
        {
            return getRec(i_primaryKey) as Rec_campaign_banner;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_banner;
		}
    }
}

