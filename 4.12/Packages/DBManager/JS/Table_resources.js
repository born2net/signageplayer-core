function Table_resources(i_database)
{
    Table.call(this, i_database);
    this.m_name = "resources"
    this.m_fields = [{field:"resource_id", foriegn:"resources", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"resource_name"}
                ,{field:"resource_type"}
                ,{field:"resource_pixel_width"}
                ,{field:"resource_pixel_height"}
                ,{field:"default_player"}
                ,{field:"snapshot"}
                ,{field:"resource_total_time"}
                ,{field:"resource_date_created"}
                ,{field:"resource_date_modified"}
                ,{field:"resource_trust"}
                ,{field:"resource_public"}
                ,{field:"resource_bytes_total"}
                ,{field:"resource_module"}
                ,{field:"tree_path"}
                ,{field:"access_key"}
                ,{field:"resource_html"}];
}

extend(Table, Table_resources);

Table_resources.prototype.createRecord = function()
{
	return new Rec_resource;
}

