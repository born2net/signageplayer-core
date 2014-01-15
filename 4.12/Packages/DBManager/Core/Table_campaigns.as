package
{
    public class Table_campaigns extends Table
    {
        public function Table_campaigns(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaigns"
            m_fields = [{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_name"}
                ,{field:"campaign_playlist_mode"}
                ,{field:"kiosk_mode"}
                ,{field:"kiosk_key"}
				,{field:"kiosk_timeline_id", foriegn:"campaign_timelines", isNullAble:true, pk:"campaign_timeline_id"}
                ,{field:"kiosk_wait_time"}
                ,{field:"mouse_interrupt_mode"}
                ,{field:"tree_path"}
                ,{field:"access_key"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign
        {
            return getRec(i_primaryKey) as Rec_campaign;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign;
		}
    }
}

