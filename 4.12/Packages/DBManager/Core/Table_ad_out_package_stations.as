package
{
    public class Table_ad_out_package_stations extends Table
    {
        public function Table_ad_out_package_stations(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_out_package_stations"
            m_fields = [{field:"ad_out_package_station_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_out_package_id", foriegn:"ad_out_packages", isNullAble:false}
                ,{field:"ad_out_subdomain"}
                ,{field:"ad_out_business_id"}
                ,{field:"ad_out_station_id"}
                ,{field:"days_mask"}
                ,{field:"hour_start"}
                ,{field:"hour_end"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_out_package_station
        {
            return getRec(i_primaryKey) as Rec_ad_out_package_station;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_out_package_station;
		}
    }
}

