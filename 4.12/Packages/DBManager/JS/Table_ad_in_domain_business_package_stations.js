function Table_ad_in_domain_business_package_stations(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_in_domain_business_package_stations"
    this.m_fields = [{field:"ad_in_domain_business_package_station_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_in_domain_business_package_id", foriegn:"ad_in_domain_business_packages", isNullAble:false}
                ,{field:"ad_package_station_id"}
                ,{field:"accept_status"}
                ,{field:"suspend_modified_station"}];
}

extend(Table, Table_ad_in_domain_business_package_stations);

Table_ad_in_domain_business_package_stations.prototype.createRecord = function()
{
	return new Rec_ad_in_domain_business_package_station;
}

