package
{
    public class Table_catalog_item_categories extends Table
    {
        public function Table_catalog_item_categories(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "catalog_item_categories"
            m_fields = [{field:"catalog_item_category_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"category_value_id", foriegn:"category_values", isNullAble:false}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_catalog_item_category
        {
            return getRec(i_primaryKey) as Rec_catalog_item_category;
        }

		public override function createRecord():Record
		{
			return new Rec_catalog_item_category;
		}
    }
}

