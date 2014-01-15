package
{
    public class Table_catalog_items extends Table
    {
        public function Table_catalog_items(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "catalog_items"
            m_fields = [{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"item_name"}
                ,{field:"ad_local_content_id", foriegn:"ad_local_contents", isNullAble:true}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_catalog_item
        {
            return getRec(i_primaryKey) as Rec_catalog_item;
        }

		public override function createRecord():Record
		{
			return new Rec_catalog_item;
		}
    }
}

