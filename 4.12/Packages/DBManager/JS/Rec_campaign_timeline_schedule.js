function Rec_campaign_timeline_schedule()
{
    Record.call(this);

    this.campaign_timeline_schedule_id = (-1);
    this.campaign_timeline_id = (-1);
    this.priorty = 0;
    this.start_date =  new Date(2007, 10, 24);
    this.end_date =  new Date(2007, 10, 25);
    this.repeat_type = 0;
    this.week_days = 0;
    this.custom_duration = false;
    this.duration = 0;
    this.start_time = 0;
    this.pattern_enabled = true;
    this.pattern_name = "pattern";

}

extend(Record, Rec_campaign_timeline_schedule);
