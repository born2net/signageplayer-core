function Table_ad_in_domain_business_packages(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_in_domain_business_packages"
    this.m_fields = [{field:"ad_in_domain_business_package_id", foriegn:"ad_in_domain_business_packages", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_in_domain_business_id", foriegn:"ad_in_domain_businesses", isNullAble:false}
                ,{field:"ad_package_id"}
                ,{field:"accept_new_station"}
                ,{field:"suspend_modified_package_date"}
                ,{field:"suspend_modified_content"}];
}

extend(Table, Table_ad_in_domain_business_packages);

Table_ad_in_domain_business_packages.prototype.createRecord = function()
{
	return new Rec_ad_in_domain_business_package;
}

