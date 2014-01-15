package
{
    public class Table_catalog_item_resources extends Table
    {
        public function Table_catalog_item_resources(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "catalog_item_resources"
            m_fields = [{field:"catalog_item_resource_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"resource_id", foriegn:"resources", isNullAble:false}
                ,{field:"resource_group"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_catalog_item_resource
        {
            return getRec(i_primaryKey) as Rec_catalog_item_resource;
        }

		public override function createRecord():Record
		{
			return new Rec_catalog_item_resource;
		}
    }
}

