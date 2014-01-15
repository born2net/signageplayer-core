package
{
    public class Table_music_channels extends Table
    {
        public function Table_music_channels(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "music_channels"
            m_fields = [{field:"music_channel_id", foriegn:"music_channels", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"music_channel_name"}
                ,{field:"access_key"}
                ,{field:"tree_path"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_music_channel
        {
            return getRec(i_primaryKey) as Rec_music_channel;
        }

		public override function createRecord():Record
		{
			return new Rec_music_channel;
		}
    }
}

