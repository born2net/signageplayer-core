function Table_campaign_events(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_events"
    this.m_fields = [{field:"campaign_event_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:true}
                ,{field:"sender_name"}
                ,{field:"event_name"}
                ,{field:"event_condition"}
                ,{field:"command_name"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:true}
                ,{field:"command_params"}];
}

extend(Table, Table_campaign_events);

Table_campaign_events.prototype.createRecord = function()
{
	return new Rec_campaign_event;
}

