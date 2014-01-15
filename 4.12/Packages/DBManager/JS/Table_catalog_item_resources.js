function Table_catalog_item_resources(i_database)
{
    Table.call(this, i_database);
    this.m_name = "catalog_item_resources"
    this.m_fields = [{field:"catalog_item_resource_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"resource_id", foriegn:"resources", isNullAble:false}
                ,{field:"resource_group"}];
}

extend(Table, Table_catalog_item_resources);

Table_catalog_item_resources.prototype.createRecord = function()
{
	return new Rec_catalog_item_resource;
}

