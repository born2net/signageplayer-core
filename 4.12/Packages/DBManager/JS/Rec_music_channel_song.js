function Rec_music_channel_song()
{
    Record.call(this);

    this.music_channel_song_id;
    this.music_channel_id = (-1);
    this.resource_id = (-1);

}

extend(Record, Rec_music_channel_song);
