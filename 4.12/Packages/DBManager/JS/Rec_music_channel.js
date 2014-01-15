function Rec_music_channel()
{
    Record.call(this);

    this.music_channel_id;
    this.music_channel_name = "Channel";
    this.access_key = 0;
    this.tree_path = "";

}

extend(Record, Rec_music_channel);
