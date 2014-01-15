function Table_campaign_timeline_board_viewer_channels(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_board_viewer_channels"
    this.m_fields = [{field:"campaign_timeline_board_viewer_channel_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_board_template_id", foriegn:"campaign_timeline_board_templates", isNullAble:false}
                ,{field:"board_template_viewer_id", foriegn:"board_template_viewers", isNullAble:false}
                ,{field:"campaign_channel_id", foriegn:"campaign_channels", isNullAble:false}];
}

extend(Table, Table_campaign_timeline_board_viewer_channels);

Table_campaign_timeline_board_viewer_channels.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_board_viewer_channel;
}

