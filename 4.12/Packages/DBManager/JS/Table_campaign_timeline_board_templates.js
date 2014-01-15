function Table_campaign_timeline_board_templates(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_board_templates"
    this.m_fields = [{field:"campaign_timeline_board_template_id", foriegn:"campaign_timeline_board_templates", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"board_template_id", foriegn:"board_templates", isNullAble:false}
                ,{field:"campaign_board_id", foriegn:"campaign_boards", isNullAble:false}
                ,{field:"template_offset_time"}
                ,{field:"template_duration"}];
}

extend(Table, Table_campaign_timeline_board_templates);

Table_campaign_timeline_board_templates.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_board_template;
}

