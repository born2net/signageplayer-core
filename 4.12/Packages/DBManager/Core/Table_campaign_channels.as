package
{
    public class Table_campaign_channels extends Table
    {
        public function Table_campaign_channels(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_channels"
            m_fields = [{field:"campaign_channel_id", foriegn:"campaign_channels", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"chanel_name"}
                ,{field:"chanel_color"}
                ,{field:"random_order"}
                ,{field:"repeat_to_fit"}
                ,{field:"fixed_players_length"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_channel
        {
            return getRec(i_primaryKey) as Rec_campaign_channel;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_channel;
		}
    }
}

