function Table_ad_in_domains(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_in_domains"
    this.m_fields = [{field:"ad_in_domain_id", foriegn:"ad_in_domains", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_out_domain"}
                ,{field:"accept_new_business"}];
}

extend(Table, Table_ad_in_domains);

Table_ad_in_domains.prototype.createRecord = function()
{
	return new Rec_ad_in_domain;
}

