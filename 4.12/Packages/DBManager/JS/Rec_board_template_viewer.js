function Rec_board_template_viewer()
{
    Record.call(this);

    this.board_template_viewer_id = (-1);
    this.board_template_id = (-1);
    this.viewer_name = "Viewer";
    this.pixel_x = 0;
    this.pixel_y = 0;
    this.pixel_width = 100;
    this.pixel_height = 100;
    this.enable_gaps = false;
    this.viewer_order = 0;
    this.locked = false;

}

extend(Record, Rec_board_template_viewer);
