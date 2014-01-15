package
{
    public class Table_campaign_channel_players extends Table
    {
        public function Table_campaign_channel_players(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_channel_players"
            m_fields = [{field:"campaign_channel_player_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_channel_id", foriegn:"campaign_channels", isNullAble:false}
                ,{field:"player_offset_time"}
                ,{field:"player_duration"}
                ,{field:"player_data"}
                ,{field:"mouse_children"}
                ,{field:"ad_local_content_id", foriegn:"ad_local_contents", isNullAble:true}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_channel_player
        {
            return getRec(i_primaryKey) as Rec_campaign_channel_player;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_channel_player;
		}
    }
}

