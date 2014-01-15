function Table_music_channel_songs(i_database)
{
    Table.call(this, i_database);
    this.m_name = "music_channel_songs"
    this.m_fields = [{field:"music_channel_song_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"music_channel_id", foriegn:"music_channels", isNullAble:false}
                ,{field:"resource_id", foriegn:"resources", isNullAble:false}];
}

extend(Table, Table_music_channel_songs);

Table_music_channel_songs.prototype.createRecord = function()
{
	return new Rec_music_channel_song;
}

