function Table_campaign_timeline_chanels(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_chanels"
    this.m_fields = [{field:"campaign_timeline_chanel_id", foriegn:"campaign_timeline_chanels", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"chanel_name"}
                ,{field:"chanel_color"}
                ,{field:"random_order"}
                ,{field:"repeat_to_fit"}
                ,{field:"fixed_players_length"}];
}

extend(Table, Table_campaign_timeline_chanels);

Table_campaign_timeline_chanels.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_chanel;
}

