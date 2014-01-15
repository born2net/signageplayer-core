function Table_ad_local_packages(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_local_packages"
    this.m_fields = [{field:"ad_local_package_id", foriegn:"ad_local_packages", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"enabled"}
                ,{field:"package_name"}
                ,{field:"use_date_range"}
                ,{field:"start_date"}
                ,{field:"end_date"}];
}

extend(Table, Table_ad_local_packages);

Table_ad_local_packages.prototype.createRecord = function()
{
	return new Rec_ad_local_package;
}

