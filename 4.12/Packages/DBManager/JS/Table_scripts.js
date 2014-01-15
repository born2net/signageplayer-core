function Table_scripts(i_database)
{
    Table.call(this, i_database);
    this.m_name = "scripts"
    this.m_fields = [{field:"script_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"script_src"}];
}

extend(Table, Table_scripts);

Table_scripts.prototype.createRecord = function()
{
	return new Rec_script;
}

