function Table_boards(i_database)
{
    Table.call(this, i_database);
    this.m_name = "boards"
    this.m_fields = [{field:"board_id", foriegn:"boards", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_name"}
                ,{field:"board_pixel_width"}
                ,{field:"board_pixel_height"}
                ,{field:"monitor_orientation_enabled"}
                ,{field:"monitor_orientation_index"}
                ,{field:"access_key"}
                ,{field:"tree_path"}];
}

extend(Table, Table_boards);

Table_boards.prototype.createRecord = function()
{
	return new Rec_board;
}

