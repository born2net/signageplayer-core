function Table_board_templates(i_database)
{
    Table.call(this, i_database);
    this.m_name = "board_templates"
    this.m_fields = [{field:"board_template_id", foriegn:"board_templates", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_id", foriegn:"boards", isNullAble:false}
                ,{field:"template_name"}];
}

extend(Table, Table_board_templates);

Table_board_templates.prototype.createRecord = function()
{
	return new Rec_board_template;
}

