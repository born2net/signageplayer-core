function Table_catalog_item_categories(i_database)
{
    Table.call(this, i_database);
    this.m_name = "catalog_item_categories"
    this.m_fields = [{field:"catalog_item_category_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"catalog_item_id", foriegn:"catalog_items", isNullAble:false}
                ,{field:"category_value_id", foriegn:"category_values", isNullAble:false}];
}

extend(Table, Table_catalog_item_categories);

Table_catalog_item_categories.prototype.createRecord = function()
{
	return new Rec_catalog_item_category;
}

