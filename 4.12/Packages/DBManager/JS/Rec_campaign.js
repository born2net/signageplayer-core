function Rec_campaign()
{
    Record.call(this);

    this.campaign_id = (-1);
    this.campaign_name = "Campaign";
    this.campaign_playlist_mode = 0;
    this.kiosk_mode = false;
    this.kiosk_key = "esc";
    this.kiosk_timeline_id = -1;
    this.kiosk_wait_time = (5);
    this.mouse_interrupt_mode = false;
    this.tree_path = "";
    this.access_key = 0;

}

extend(Record, Rec_campaign);
