package
{
    public class Table_campaign_timeline_sequences extends Table
    {
        public function Table_campaign_timeline_sequences(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timeline_sequences"
            m_fields = [{field:"campaign_timeline_sequence_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"sequence_index"}
                ,{field:"sequence_count"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline_sequence
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline_sequence;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline_sequence;
		}
    }
}

