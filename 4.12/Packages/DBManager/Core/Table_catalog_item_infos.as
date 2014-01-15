package
{
    public class Table_catalog_item_infos extends Table
    {
        public function Table_catalog_item_infos(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "catalog_item_infos"
            m_fields = [{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"info0"}
                ,{field:"info1"}
                ,{field:"info2"}
                ,{field:"info3"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_catalog_item_info
        {
            return getRec(i_primaryKey) as Rec_catalog_item_info;
        }

		public override function createRecord():Record
		{
			return new Rec_catalog_item_info;
		}
    }
}

