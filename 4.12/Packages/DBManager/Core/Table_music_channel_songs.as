package
{
    public class Table_music_channel_songs extends Table
    {
        public function Table_music_channel_songs(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "music_channel_songs"
            m_fields = [{field:"music_channel_song_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"music_channel_id", foriegn:"music_channels", isNullAble:false}
                ,{field:"resource_id", foriegn:"resources", isNullAble:false}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_music_channel_song
        {
            return getRec(i_primaryKey) as Rec_music_channel_song;
        }

		public override function createRecord():Record
		{
			return new Rec_music_channel_song;
		}
    }
}

