package
{
    public class Table_ad_in_domain_business_package_stations extends Table
    {
        public function Table_ad_in_domain_business_package_stations(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_in_domain_business_package_stations"
            m_fields = [{field:"ad_in_domain_business_package_station_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_in_domain_business_package_id", foriegn:"ad_in_domain_business_packages", isNullAble:false}
                ,{field:"ad_package_station_id"}
                ,{field:"accept_status"}
                ,{field:"suspend_modified_station"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_in_domain_business_package_station
        {
            return getRec(i_primaryKey) as Rec_ad_in_domain_business_package_station;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_in_domain_business_package_station;
		}
    }
}

