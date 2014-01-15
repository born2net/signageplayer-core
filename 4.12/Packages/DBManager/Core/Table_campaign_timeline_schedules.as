package
{
    public class Table_campaign_timeline_schedules extends Table
    {
        public function Table_campaign_timeline_schedules(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timeline_schedules"
            m_fields = [{field:"campaign_timeline_schedule_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"priorty"}
                ,{field:"start_date"}
                ,{field:"end_date"}
                ,{field:"repeat_type"}
                ,{field:"week_days"}
                ,{field:"custom_duration"}
                ,{field:"duration"}
                ,{field:"start_time"}
                ,{field:"pattern_enabled"}
                ,{field:"pattern_name"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline_schedule
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline_schedule;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline_schedule;
		}
    }
}

