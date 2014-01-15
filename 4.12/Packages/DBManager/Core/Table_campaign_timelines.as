package
{
    public class Table_campaign_timelines extends Table
    {
        public function Table_campaign_timelines(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timelines"
            m_fields = [{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"timeline_name"}
                ,{field:"timeline_duration"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline;
		}
    }
}

