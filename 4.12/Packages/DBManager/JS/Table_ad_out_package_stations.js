function Table_ad_out_package_stations(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_out_package_stations"
    this.m_fields = [{field:"ad_out_package_station_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_out_package_id", foriegn:"ad_out_packages", isNullAble:false}
                ,{field:"ad_out_subdomain"}
                ,{field:"ad_out_business_id"}
                ,{field:"ad_out_station_id"}
                ,{field:"days_mask"}
                ,{field:"hour_start"}
                ,{field:"hour_end"}];
}

extend(Table, Table_ad_out_package_stations);

Table_ad_out_package_stations.prototype.createRecord = function()
{
	return new Rec_ad_out_package_station;
}

