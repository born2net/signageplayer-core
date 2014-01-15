package
{
    public class Table_category_values extends Table
    {
        public function Table_category_values(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "category_values"
            m_fields = [{field:"category_value_id", foriegn:"category_values", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
				,{field:"parent_category_value_id", foriegn:"category_values", isNullAble:true, pk:"category_value_id"}
                ,{field:"category_value"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_category_value
        {
            return getRec(i_primaryKey) as Rec_category_value;
        }

		public override function createRecord():Record
		{
			return new Rec_category_value;
		}
    }
}

