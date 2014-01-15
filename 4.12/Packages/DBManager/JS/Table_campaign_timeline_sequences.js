function Table_campaign_timeline_sequences(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaign_timeline_sequences"
    this.m_fields = [{field:"campaign_timeline_sequence_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"campaign_timeline_id", foriegn:"campaign_timelines", isNullAble:false}
                ,{field:"sequence_index"}
                ,{field:"sequence_count"}];
}

extend(Table, Table_campaign_timeline_sequences);

Table_campaign_timeline_sequences.prototype.createRecord = function()
{
	return new Rec_campaign_timeline_sequence;
}

