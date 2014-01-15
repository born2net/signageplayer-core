function Table_campaign_timeline_board_viewer_chanels(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_board_viewer_chanels"
    this.m_fields = [{field:"campaign_timeline_board_viewer_chanel_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_board_template_id", foriegn:"campaign_timeline_board_templates", isNullAble:false}
                ,{field:"board_template_viewer_id", foriegn:"board_template_viewers", isNullAble:false}
                ,{field:"campaign_timeline_chanel_id", foriegn:"campaign_timeline_chanels", isNullAble:false}];
}

extend(Table, Table_campaign_timeline_board_viewer_chanels);

Table_campaign_timeline_board_viewer_chanels.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_board_viewer_chanel;
}

