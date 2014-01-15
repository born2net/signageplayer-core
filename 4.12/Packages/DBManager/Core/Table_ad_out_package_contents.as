package
{
    public class Table_ad_out_package_contents extends Table
    {
        public function Table_ad_out_package_contents(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_out_package_contents"
            m_fields = [{field:"ad_out_package_content_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_out_package_id", foriegn:"ad_out_packages", isNullAble:false}
                ,{field:"resource_id", foriegn:"resources", isNullAble:true}
                ,{field:"player_data_id", foriegn:"player_data", isNullAble:true}
                ,{field:"duration"}
                ,{field:"reparations_per_hour"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_out_package_content
        {
            return getRec(i_primaryKey) as Rec_ad_out_package_content;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_out_package_content;
		}
    }
}

