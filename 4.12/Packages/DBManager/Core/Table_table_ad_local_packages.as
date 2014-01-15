package
{
    public class Table_table_ad_local_packages extends Table
    {
        public function Table_table_ad_local_packages(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "table_ad_local_packages"
            m_fields = [];
        }
		
        public function getRecord(i_primaryKey:int):Rec_table_ad_local_package
        {
            return getRec(i_primaryKey) as Rec_table_ad_local_package;
        }

		public override function createRecord():Record
		{
			return new Rec_table_ad_local_package;
		}
    }
}

