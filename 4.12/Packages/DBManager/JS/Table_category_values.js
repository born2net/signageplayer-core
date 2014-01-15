function Table_category_values(i_database)
{
    Table.call(this, i_database);
    this.m_name = "category_values"
    this.m_fields = [{field:"category_value_id", foriegn:"category_values", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"parent_category_value_id"}
                ,{field:"category_value"}];
}

extend(Table, Table_category_values);

Table_category_values.prototype.createRecord = function()
{
	return new Rec_category_value;
}

