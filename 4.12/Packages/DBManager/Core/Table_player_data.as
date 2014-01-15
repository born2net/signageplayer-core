package
{
    public class Table_player_data extends Table
    {
        public function Table_player_data(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "player_data"
            m_fields = [{field:"player_data_id", foriegn:"player_data", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"player_data_value"}
                ,{field:"player_data_public"}
                ,{field:"tree_path"}
                ,{field:"source_code"}
                ,{field:"access_key"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_player_data
        {
            return getRec(i_primaryKey) as Rec_player_data;
        }

		public override function createRecord():Record
		{
			return new Rec_player_data;
		}
    }
}

