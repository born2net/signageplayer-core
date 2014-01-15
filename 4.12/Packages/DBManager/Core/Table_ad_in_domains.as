package
{
    public class Table_ad_in_domains extends Table
    {
        public function Table_ad_in_domains(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_in_domains"
            m_fields = [{field:"ad_in_domain_id", foriegn:"ad_in_domains", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_out_domain"}
                ,{field:"accept_new_business"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_in_domain
        {
            return getRec(i_primaryKey) as Rec_ad_in_domain;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_in_domain;
		}
    }
}

