function Table_catalog_items(i_database)
{
    Table.call(this, i_database);
    this.m_name = "catalog_items"
    this.m_fields = [{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"item_name"}
                ,{field:"ad_local_content_id", foriegn:"ad_local_contents", isNullAble:true}];
}

extend(Table, Table_catalog_items);

Table_catalog_items.prototype.createRecord = function()
{
	return new Rec_catalog_item;
}

