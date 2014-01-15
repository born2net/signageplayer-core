package
{
    public class Table_ad_local_packages extends Table
    {
        public function Table_ad_local_packages(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_local_packages"
            m_fields = [{field:"ad_local_package_id", foriegn:"ad_local_packages", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"enabled"}
                ,{field:"package_name"}
                ,{field:"use_date_range"}
                ,{field:"start_date"}
                ,{field:"end_date"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_local_package
        {
            return getRec(i_primaryKey) as Rec_ad_local_package;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_local_package;
		}
    }
}

