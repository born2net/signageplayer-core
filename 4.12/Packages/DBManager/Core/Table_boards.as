package
{
    public class Table_boards extends Table
    {
        public function Table_boards(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "boards"
            m_fields = [{field:"board_id", foriegn:"boards", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_name"}
                ,{field:"board_pixel_width"}
                ,{field:"board_pixel_height"}
                ,{field:"monitor_orientation_enabled"}
                ,{field:"monitor_orientation_index"}
                ,{field:"access_key"}
                ,{field:"tree_path"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_board
        {
            return getRec(i_primaryKey) as Rec_board;
        }

		public override function createRecord():Record
		{
			return new Rec_board;
		}
    }
}

