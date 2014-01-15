function Table_campaign_timelines(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timelines"
    this.m_fields = [{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"timeline_name"}
                ,{field:"timeline_duration"}];
}

extend(Table, Table_campaign_timelines);

Table_campaign_timelines.prototype.createRecord = function()
{
	return new Rec_campaign_timeline;
}

