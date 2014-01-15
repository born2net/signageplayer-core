package
{
    public class Table_scripts extends Table
    {
        public function Table_scripts(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "scripts"
            m_fields = [{field:"script_id"}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"script_src"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_script
        {
            return getRec(i_primaryKey) as Rec_script;
        }

		public override function createRecord():Record
		{
			return new Rec_script;
		}
    }
}

