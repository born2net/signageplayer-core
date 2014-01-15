function Rec_campaign_timeline_chanel_player()
{
    Record.call(this);

    this.campaign_timeline_chanel_player_id = (-1);
    this.campaign_timeline_chanel_id = (-1);
    this.player_offset_time = 0;
    this.player_duration = 60;
    this.player_id = (-1);
    this.player_editor_id = (-1);
    this.player_data;
    this.mouse_children = false;
    this.ad_local_content_id = (-1);

}

extend(Record, Rec_campaign_timeline_chanel_player);
