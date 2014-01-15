function Rec_campaign_board()
{
    Record.call(this);

    this.campaign_board_id = (-1);
    this.board_id = (-1);
    this.campaign_id = (-1);
    this.campaign_board_name = "Output";
    this.allow_public_view = false;
    this.admin_public_view = 0;

}

extend(Record, Rec_campaign_board);
