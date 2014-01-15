package
{
    public class Table_ad_in_domain_business_packages extends Table
    {
        public function Table_ad_in_domain_business_packages(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_in_domain_business_packages"
            m_fields = [{field:"ad_in_domain_business_package_id", foriegn:"ad_in_domain_business_packages", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_in_domain_business_id", foriegn:"ad_in_domain_businesses", isNullAble:false}
                ,{field:"ad_package_id"}
                ,{field:"accept_new_station"}
                ,{field:"suspend_modified_package_date"}
                ,{field:"suspend_modified_content"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_in_domain_business_package
        {
            return getRec(i_primaryKey) as Rec_ad_in_domain_business_package;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_in_domain_business_package;
		}
    }
}

