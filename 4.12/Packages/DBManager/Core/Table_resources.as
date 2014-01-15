package
{
    public class Table_resources extends Table
    {
        public function Table_resources(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "resources"
            m_fields = [{field:"resource_id", foriegn:"resources", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"resource_name"}
                ,{field:"resource_type"}
                ,{field:"resource_pixel_width"}
                ,{field:"resource_pixel_height"}
                ,{field:"default_player"}
                ,{field:"snapshot"}
                ,{field:"resource_total_time"}
                ,{field:"resource_date_created"}
                ,{field:"resource_date_modified"}
                ,{field:"resource_trust"}
                ,{field:"resource_public"}
                ,{field:"resource_bytes_total"}
                ,{field:"resource_module"}
                ,{field:"tree_path"}
                ,{field:"access_key"}
                ,{field:"resource_html"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_resource
        {
            return getRec(i_primaryKey) as Rec_resource;
        }

		public override function createRecord():Record
		{
			return new Rec_resource;
		}
    }
}

