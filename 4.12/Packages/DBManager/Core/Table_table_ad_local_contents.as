package
{
    public class Table_table_ad_local_contents extends Table
    {
        public function Table_table_ad_local_contents(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "table_ad_local_contents"
            m_fields = [];
        }
		
        public function getRecord(i_primaryKey:int):Rec_table_ad_local_content
        {
            return getRec(i_primaryKey) as Rec_table_ad_local_content;
        }

		public override function createRecord():Record
		{
			return new Rec_table_ad_local_content;
		}
    }
}

