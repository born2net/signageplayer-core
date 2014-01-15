function Rec_campaign_channel()
{
    Record.call(this);

    this.campaign_channel_id = (-1);
    this.campaign_id = (-1);
    this.chanel_name = "CH";
    this.chanel_color = 0;
    this.random_order = false;
    this.repeat_to_fit = true;
    this.fixed_players_length = true;

}

extend(Record, Rec_campaign_channel);
