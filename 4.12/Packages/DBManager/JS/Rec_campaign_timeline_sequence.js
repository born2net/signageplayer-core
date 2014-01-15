function Rec_campaign_timeline_sequence()
{
    Record.call(this);

    this.campaign_timeline_sequence_id;
    this.campaign_id = (-1);
    this.campaign_timeline_id = (-1);
    this.sequence_index;
    this.sequence_count;

}

extend(Record, Rec_campaign_timeline_sequence);
