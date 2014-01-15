package
{
    public class Table_campaign_boards extends Table
    {
        public function Table_campaign_boards(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "campaign_boards"
            m_fields = [{field:"campaign_board_id", foriegn:"campaign_boards", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_id", foriegn:"boards", isNullAble:false}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"campaign_board_name"}
                ,{field:"allow_public_view"}
                ,{field:"admin_public_view"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_campaign_board
        {
            return getRec(i_primaryKey) as Rec_campaign_board;
        }

		public override function createRecord():Record
		{
			return new Rec_campaign_board;
		}
    }
}

