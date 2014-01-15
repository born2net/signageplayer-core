package
{
    public class Table_campaign_timeline_board_viewer_channels extends Table
    {
        public function Table_campaign_timeline_board_viewer_channels(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_timeline_board_viewer_channels"
            m_fields = [{field:"campaign_timeline_board_viewer_channel_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_board_template_id", foriegn:"campaign_timeline_board_templates", isNullAble:false}
                ,{field:"board_template_viewer_id", foriegn:"board_template_viewers", isNullAble:false}
                ,{field:"campaign_channel_id", foriegn:"campaign_channels", isNullAble:false}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_timeline_board_viewer_channel
        {
            return getRec(i_primaryKey) as Rec_campaign_timeline_board_viewer_channel;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_timeline_board_viewer_channel;
		}
    }
}

