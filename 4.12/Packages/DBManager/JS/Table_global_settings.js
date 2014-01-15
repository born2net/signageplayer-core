function Table_global_settings(i_database)
{
    Table.call(this, i_database);
    this.m_name = "global_settings"
    this.m_fields = [{field:"param_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"param_key"}
                ,{field:"param_value"}];
}

extend(Table, Table_global_settings);

Table_global_settings.prototype.createRecord = function()
{
	return new Rec_global_setting;
}

