function Table_board_template_viewers(i_database)
{
    Table.call(this, i_database);
    this.m_name = "board_template_viewers"
    this.m_fields = [{field:"board_template_viewer_id", foriegn:"board_template_viewers", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_template_id", foriegn:"board_templates", isNullAble:false}
                ,{field:"viewer_name"}
                ,{field:"pixel_x"}
                ,{field:"pixel_y"}
                ,{field:"pixel_width"}
                ,{field:"pixel_height"}
                ,{field:"enable_gaps"}
                ,{field:"viewer_order"}
                ,{field:"locked"}];
}

extend(Table, Table_board_template_viewers);

Table_board_template_viewers.prototype.createRecord = function()
{
	return new Rec_board_template_viewer;
}

