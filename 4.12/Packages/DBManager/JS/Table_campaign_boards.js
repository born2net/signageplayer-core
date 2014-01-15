function Table_campaign_boards(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_boards"
    this.m_fields = [{field:"campaign_board_id", foriegn:"campaign_boards", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"board_id", foriegn:"boards", isNullAble:false}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"campaign_board_name"}
                ,{field:"allow_public_view"}
                ,{field:"admin_public_view"}];
}

extend(Table, Table_campaign_boards);

Table_campaign_boards.prototype.createRecord = function()
{
	return new Rec_campaign_board;
}

