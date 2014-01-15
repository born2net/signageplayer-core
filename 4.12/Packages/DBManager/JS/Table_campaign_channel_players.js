function Table_campaign_channel_players(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_channel_players"
    this.m_fields = [{field:"campaign_channel_player_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_channel_id", foriegn:"campaign_channels", isNullAble:false}
                ,{field:"player_offset_time"}
                ,{field:"player_duration"}
                ,{field:"player_data"}
                ,{field:"mouse_children"}
                ,{field:"ad_local_content_id", foriegn:"ad_local_contents", isNullAble:true}];
}

extend(Table, Table_campaign_channel_players);

Table_campaign_channel_players.prototype.createRecord = function()
{
	return new Rec_campaign_channel_player;
}

