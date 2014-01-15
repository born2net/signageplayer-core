function Table_campaign_timeline_channels(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_channels"
    this.m_fields = [{field:"campaign_timeline_channel_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}];
}

extend(Table, Table_campaign_timeline_channels);

Table_campaign_timeline_channels.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_channel;
}

