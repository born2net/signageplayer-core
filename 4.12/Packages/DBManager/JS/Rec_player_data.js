function Rec_player_data()
{
    Record.call(this);

    this.player_data_id = (-1);
    this.player_data_value;
    this.player_data_public = false;
    this.tree_path = "";
    this.source_code;
    this.access_key = 0;

}

extend(Record, Rec_player_data);
