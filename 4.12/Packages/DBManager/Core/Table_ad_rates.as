package
{
    public class Table_ad_rates extends Table
    {
        public function Table_ad_rates(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "ad_rates"
            m_fields = [{field:"ad_rate_id", foriegn:"ad_rates", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_rate_name"}
                ,{field:"ad_rate_map"}
                ,{field:"hour_rate0"}
                ,{field:"hour_rate1"}
                ,{field:"hour_rate2"}
                ,{field:"hour_rate3"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_ad_rate
        {
            return getRec(i_primaryKey) as Rec_ad_rate;
        }

		public override function createRecord():Record
		{
			return new Rec_ad_rate;
		}
    }
}

