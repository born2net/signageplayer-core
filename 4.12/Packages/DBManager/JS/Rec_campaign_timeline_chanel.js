function Rec_campaign_timeline_chanel()
{
    Record.call(this);

    this.campaign_timeline_chanel_id = (-1);
    this.campaign_timeline_id = (-1);
    this.chanel_name = "CH";
    this.chanel_color = 0;
    this.random_order = false;
    this.repeat_to_fit = false;
    this.fixed_players_length = true;

}

extend(Record, Rec_campaign_timeline_chanel);
