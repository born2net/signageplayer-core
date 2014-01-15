function Table_campaign_channels(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_channels"
    this.m_fields = [{field:"campaign_channel_id", foriegn:"campaign_channels", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"chanel_name"}
                ,{field:"chanel_color"}
                ,{field:"random_order"}
                ,{field:"repeat_to_fit"}
                ,{field:"fixed_players_length"}];
}

extend(Table, Table_campaign_channels);

Table_campaign_channels.prototype.createRecord = function()
{
	return new Rec_campaign_channel;
}

