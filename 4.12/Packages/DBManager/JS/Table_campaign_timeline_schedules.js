function Table_campaign_timeline_schedules(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_schedules"
    this.m_fields = [{field:"campaign_timeline_schedule_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"priorty"}
                ,{field:"start_date"}
                ,{field:"end_date"}
                ,{field:"repeat_type"}
                ,{field:"week_days"}
                ,{field:"custom_duration"}
                ,{field:"duration"}
                ,{field:"start_time"}
                ,{field:"pattern_enabled"}
                ,{field:"pattern_name"}];
}

extend(Table, Table_campaign_timeline_schedules);

Table_campaign_timeline_schedules.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_schedule;
}

