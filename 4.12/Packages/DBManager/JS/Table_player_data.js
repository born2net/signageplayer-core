function Table_player_data(i_database)
{
    Table.call(this, i_database);
    this.m_name = "player_data"
    this.m_fields = [{field:"player_data_id", foriegn:"player_data", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"player_data_value"}
                ,{field:"player_data_public"}
                ,{field:"tree_path"}
                ,{field:"source_code"}
                ,{field:"access_key"}];
}

extend(Table, Table_player_data);

Table_player_data.prototype.createRecord = function()
{
	return new Rec_player_data;
}

