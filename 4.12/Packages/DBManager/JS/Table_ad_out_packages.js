function Table_ad_out_packages(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_out_packages"
    this.m_fields = [{field:"ad_out_package_id", foriegn:"ad_out_packages", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"package_name"}
                ,{field:"start_date"}
                ,{field:"end_date"}];
}

extend(Table, Table_ad_out_packages);

Table_ad_out_packages.prototype.createRecord = function()
{
	return new Rec_ad_out_package;
}

