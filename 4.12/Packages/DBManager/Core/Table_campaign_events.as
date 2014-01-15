package
{
    public class Table_campaign_events extends Table
    {
        public function Table_campaign_events(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_events"
            m_fields = [{field:"campaign_event_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:true}
                ,{field:"sender_name"}
                ,{field:"event_name"}
                ,{field:"event_condition"}
                ,{field:"command_name"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:true}
                ,{field:"command_params"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_event
        {
            return getRec(i_primaryKey) as Rec_campaign_event;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_event;
		}
    }
}

