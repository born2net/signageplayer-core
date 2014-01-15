function Table_ad_local_contents(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_local_contents"
    this.m_fields = [{field:"ad_local_content_id", foriegn:"ad_local_contents", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_local_package_id", foriegn:"ad_local_packages", isNullAble:false}
                ,{field:"enabled"}
                ,{field:"content_name"}];
}

extend(Table, Table_ad_local_contents);

Table_ad_local_contents.prototype.createRecord = function()
{
	return new Rec_ad_local_content;
}

