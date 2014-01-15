package
{
    public class Table_global_settings extends Table
    {
        public function Table_global_settings(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "global_settings"
            m_fields = [{field:"param_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"param_key"}
                ,{field:"param_value"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_global_setting
        {
            return getRec(i_primaryKey) as Rec_global_setting;
        }

		public override function createRecord():Record
		{
			return new Rec_global_setting;
		}
    }
}

