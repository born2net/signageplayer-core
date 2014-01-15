function Table_campaigns(i_database)
{
    Table.call(this, i_database);
    this.m_name = "campaigns"
    this.m_fields = [{field:"campaign_id", foriegn:"campaigns", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"campaign_name"}
                ,{field:"campaign_playlist_mode"}
                ,{field:"kiosk_mode"}
                ,{field:"kiosk_key"}
                ,{field:"kiosk_timeline_id"}
                ,{field:"kiosk_wait_time"}
                ,{field:"mouse_interrupt_mode"}
                ,{field:"tree_path"}
                ,{field:"access_key"}];
}

extend(Table, Table_campaigns);

Table_campaigns.prototype.createRecord = function()
{
	return new Rec_campaign;
}

