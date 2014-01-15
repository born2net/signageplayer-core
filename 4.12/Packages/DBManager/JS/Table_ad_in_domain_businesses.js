function Table_ad_in_domain_businesses(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_in_domain_businesses"
    this.m_fields = [{field:"ad_in_domain_business_id", foriegn:"ad_in_domain_businesses", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_in_domain_id", foriegn:"ad_in_domains", isNullAble:false}
                ,{field:"ad_out_business_id"}
                ,{field:"accept_new_package"}];
}

extend(Table, Table_ad_in_domain_businesses);

Table_ad_in_domain_businesses.prototype.createRecord = function()
{
	return new Rec_ad_in_domain_business;
}

