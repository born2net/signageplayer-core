function Table_campaign_timeline_chanel_players(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_chanel_players"
    this.m_fields = [{field:"campaign_timeline_chanel_player_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_chanel_id", foriegn:"campaign_timeline_chanels", isNullAble:false}
                ,{field:"player_offset_time"}
                ,{field:"player_duration"}
                ,{field:"player_id"}
                ,{field:"player_editor_id"}
                ,{field:"player_data"}
                ,{field:"mouse_children"}
                ,{field:"ad_local_content_id", foriegn:"ad_local_contents", isNullAble:true}];
}

extend(Table, Table_campaign_timeline_chanel_players);

Table_campaign_timeline_chanel_players.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_chanel_player;
}

