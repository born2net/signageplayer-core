function Table_station_ads(i_database)
{
    Table.call(this, i_database);
    this.m_name = "station_ads"
    this.m_fields = [{field:"branch_station_id", foriegn:"branch_stations", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"advertising_network"}
                ,{field:"advertising_description"}
                ,{field:"advertising_keys"}
                ,{field:"ad_rate_id", foriegn:"ad_rates", isNullAble:true}];
}

extend(Table, Table_station_ads);

Table_station_ads.prototype.createRecord = function()
{
	return new Rec_station_ad;
}

