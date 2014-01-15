function Rec_board_template()
{
    Record.call(this);

    this.board_template_id = (-1);
    this.board_id = (-1);
    this.template_name = "Screen Division";

}

extend(Record, Rec_board_template);
