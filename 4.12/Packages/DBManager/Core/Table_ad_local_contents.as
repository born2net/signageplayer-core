package
{
    public class Table_ad_local_contents extends Table
    {
        public function Table_ad_local_contents(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_local_contents"
            m_fields = [{field:"ad_local_content_id", foriegn:"ad_local_contents", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_local_package_id", foriegn:"ad_local_packages", isNullAble:false}
                ,{field:"enabled"}
                ,{field:"content_name"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_local_content
        {
            return getRec(i_primaryKey) as Rec_ad_local_content;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_local_content;
		}
    }
}

