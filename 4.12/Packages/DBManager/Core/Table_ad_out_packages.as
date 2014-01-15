package
{
    public class Table_ad_out_packages extends Table
    {
        public function Table_ad_out_packages(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_out_packages"
            m_fields = [{field:"ad_out_package_id", foriegn:"ad_out_packages", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"package_name"}
                ,{field:"start_date"}
                ,{field:"end_date"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_out_package
        {
            return getRec(i_primaryKey) as Rec_ad_out_package;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_out_package;
		}
    }
}

