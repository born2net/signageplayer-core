function Table_catalog_item_infos(i_database)
{
    Table.call(this, i_database);
    this.m_name = "catalog_item_infos"
    this.m_fields = [{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"info0"}
                ,{field:"info1"}
                ,{field:"info2"}
                ,{field:"info3"}];
}

extend(Table, Table_catalog_item_infos);

Table_catalog_item_infos.prototype.createRecord = function()
{
	return new Rec_catalog_item_info;
}

