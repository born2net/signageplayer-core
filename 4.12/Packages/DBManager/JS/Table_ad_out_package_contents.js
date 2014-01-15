function Table_ad_out_package_contents(i_database)
{
    Table.call(this, i_database);
    this.m_name = "ad_out_package_contents"
    this.m_fields = [{field:"ad_out_package_content_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"ad_out_package_id", foriegn:"ad_out_packages", isNullAble:false}
                ,{field:"resource_id", foriegn:"resources", isNullAble:true}
                ,{field:"player_data_id", foriegn:"player_data", isNullAble:true}
                ,{field:"duration"}
                ,{field:"reparations_per_hour"}];
}

extend(Table, Table_ad_out_package_contents);

Table_ad_out_package_contents.prototype.createRecord = function()
{
	return new Rec_ad_out_package_content;
}

