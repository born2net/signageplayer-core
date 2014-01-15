package
{
    public class Table_board_templates extends Table
    {
        public function Table_board_templates(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "board_templates"
            m_fields = [{field:"board_template_id", foriegn:"board_templates", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_id", foriegn:"boards", isNullAble:false}
                ,{field:"template_name"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_board_template
        {
            return getRec(i_primaryKey) as Rec_board_template;
        }

		public override function createRecord():Record
		{
			return new Rec_board_template;
		}
    }
}

