package
{
    public class Table_board_template_viewers extends Table
    {
        public function Table_board_template_viewers(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "board_template_viewers"
            m_fields = [{field:"board_template_viewer_id", foriegn:"board_template_viewers", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_template_id", foriegn:"board_templates", isNullAble:false}
                ,{field:"viewer_name"}
                ,{field:"pixel_x"}
                ,{field:"pixel_y"}
                ,{field:"pixel_width"}
                ,{field:"pixel_height"}
                ,{field:"enable_gaps"}
                ,{field:"viewer_order"}
                ,{field:"locked"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_board_template_viewer
        {
            return getRec(i_primaryKey) as Rec_board_template_viewer;
        }

		public override function createRecord():Record
		{
			return new Rec_board_template_viewer;
		}
    }
}

