package
{
    public class Table_campaign_timeline_board_templates extends Table
    {
        public function Table_campaign_timeline_board_templates(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timeline_board_templates"
            m_fields = [{field:"campaign_timeline_board_template_id", foriegn:"campaign_timeline_board_templates", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"board_template_id", foriegn:"board_templates", isNullAble:false}
                ,{field:"campaign_board_id", foriegn:"campaign_boards", isNullAble:false}
                ,{field:"template_offset_time"}
                ,{field:"template_duration"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline_board_template
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline_board_template;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline_board_template;
		}
    }
}

