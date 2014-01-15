package
{
    public class Table_campaign_timeline_chanels extends Table
    {
        public function Table_campaign_timeline_chanels(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timeline_chanels"
            m_fields = [{field:"campaign_timeline_chanel_id", foriegn:"campaign_timeline_chanels", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"chanel_name"}
                ,{field:"chanel_color"}
                ,{field:"random_order"}
                ,{field:"repeat_to_fit"}
                ,{field:"fixed_players_length"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline_chanel
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline_chanel;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline_chanel;
		}
    }
}

