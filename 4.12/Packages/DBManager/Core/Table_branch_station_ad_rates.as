package
{
    public class Table_branch_station_ad_rates extends Table
    {
        public function Table_branch_station_ad_rates(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "branch_station_ad_rates"
            m_fields = [{field:"branch_station_ad_rate_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"branch_station_id", foriegn:"branch_stations"}
                ,{field:"day_from"}
                ,{field:"day_to"}
                ,{field:"rate_hour_0"}
                ,{field:"rate_hour_1"}
                ,{field:"rate_hour_2"}
                ,{field:"rate_hour_3"}
                ,{field:"rate_hour_4"}
                ,{field:"rate_hour_5"}
                ,{field:"rate_hour_6"}
                ,{field:"rate_hour_7"}
                ,{field:"rate_hour_8"}
                ,{field:"rate_hour_9"}
                ,{field:"rate_hour_10"}
                ,{field:"rate_hour_11"}
                ,{field:"rate_hour_12"}
                ,{field:"rate_hour_13"}
                ,{field:"rate_hour_14"}
                ,{field:"rate_hour_15"}
                ,{field:"rate_hour_16"}
                ,{field:"rate_hour_17"}
                ,{field:"rate_hour_18"}
                ,{field:"rate_hour_19"}
                ,{field:"rate_hour_20"}
                ,{field:"rate_hour_21"}
                ,{field:"rate_hour_22"}
                ,{field:"rate_hour_23"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_branch_station_ad_rate
        {
            return getRec(i_primaryKey) as Rec_branch_station_ad_rate;
        }

		public override function createRecord():Record
		{
			return new Rec_branch_station_ad_rate;
		}
    }
}

