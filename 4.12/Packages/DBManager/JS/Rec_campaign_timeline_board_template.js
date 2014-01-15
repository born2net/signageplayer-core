function Rec_campaign_timeline_board_template()
{
    Record.call(this);

    this.campaign_timeline_board_template_id = (-1);
    this.campaign_timeline_id = (-1);
    this.board_template_id = (-1);
    this.campaign_board_id = (-1);
    this.template_offset_time = 0;
    this.template_duration = 60;

}

extend(Record, Rec_campaign_timeline_board_template);
