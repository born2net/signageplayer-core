package
{
    public class Table_station_ads extends Table
    {
        public function Table_station_ads(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "station_ads"
            m_fields = [{field:"branch_station_id", foriegn:"branch_stations", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"advertising_network"}
                ,{field:"advertising_description"}
                ,{field:"advertising_keys"}
                ,{field:"ad_rate_id", foriegn:"ad_rates", isNullAble:true}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_station_ad
        {
            return getRec(i_primaryKey) as Rec_station_ad;
        }

		public override function createRecord():Record
		{
			return new Rec_station_ad;
		}
    }
}

