package
{
    public class Table_ad_in_domain_businesses extends Table
    {
        public function Table_ad_in_domain_businesses(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_in_domain_businesses"
            m_fields = [{field:"ad_in_domain_business_id", foriegn:"ad_in_domain_businesses", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_in_domain_id", foriegn:"ad_in_domains", isNullAble:false}
                ,{field:"ad_out_business_id"}
                ,{field:"accept_new_package"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_in_domain_business
        {
            return getRec(i_primaryKey) as Rec_ad_in_domain_business;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_in_domain_business;
		}
    }
}

