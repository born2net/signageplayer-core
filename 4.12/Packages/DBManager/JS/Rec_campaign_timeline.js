function Rec_campaign_timeline()
{
    Record.call(this);

    this.campaign_timeline_id = (-1);
    this.campaign_id = (-1);
    this.timeline_name = "Timeline";
    this.timeline_duration = 60;

}

extend(Record, Rec_campaign_timeline);
