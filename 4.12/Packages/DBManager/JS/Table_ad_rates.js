function Table_ad_rates(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_rates"
    this.m_fields = [{field:"ad_rate_id", foriegn:"ad_rates", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_rate_name"}
                ,{field:"ad_rate_map"}
                ,{field:"hour_rate0"}
                ,{field:"hour_rate1"}
                ,{field:"hour_rate2"}
                ,{field:"hour_rate3"}];
}

extend(Table, Table_ad_rates);

Table_ad_rates.prototype.createRecord = function()
{
	return new Rec_ad_rate;
}

