function Rec_board()
{
    Record.call(this);

    this.board_id = (-1);
    this.board_name = "S800x600";
    this.board_pixel_width = 800;
    this.board_pixel_height = 600;
    this.monitor_orientation_enabled = false;
    this.monitor_orientation_index = 0;
    this.access_key = 0;
    this.tree_path = "";

}

extend(Record, Rec_board);
