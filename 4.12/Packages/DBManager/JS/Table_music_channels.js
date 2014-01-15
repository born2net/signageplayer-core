function Table_music_channels(i_database)
{
    Table.call(this, i_database);
    this.m_name = "music_channels"
    this.m_fields = [{field:"music_channel_id", foriegn:"music_channels", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"music_channel_name"}
                ,{field:"access_key"}
                ,{field:"tree_path"}];
}

extend(Table, Table_music_channels);

Table_music_channels.prototype.createRecord = function()
{
	return new Rec_music_channel;
}

