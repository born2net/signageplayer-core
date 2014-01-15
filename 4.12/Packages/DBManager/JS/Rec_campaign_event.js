function Rec_campaign_event()
{
    Record.call(this);

    this.campaign_event_id = (-1);
    this.campaign_id = (-1);
    this.sender_name = "";
    this.event_name = "";
    this.event_condition = "";
    this.command_name = "";
    this.campaign_timeline_id = (-1);
    this.command_params = "";

}

extend(Record, Rec_campaign_event);
