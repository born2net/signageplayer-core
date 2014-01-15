package
{
    public class Table_branch_stations extends Table
    {
        public function Table_branch_stations(i_database:DataBaseManager)
        {
            super(i_database);
            m_name = "branch_stations"
            m_fields = [{field:"branch_station_id", foriegn:"branch_stations", isNullAble:false}
                ,{field:"changelist_id"}
                ,{field:"change_type"}
                ,{field:"branch_id"}
                ,{field:"campaign_board_id", foriegn:"campaign_boards", isNullAble:true}
                ,{field:"station_name"}
                ,{field:"reboot_exceed_mem_enabled"}
                ,{field:"reboot_exceed_mem_value"}
                ,{field:"reboot_time_enabled"}
                ,{field:"reboot_time_value"}
                ,{field:"reboot_error_enabled"}
                ,{field:"monitor_standby_enabled"}
                ,{field:"monitor_standby_from"}
                ,{field:"monitor_standby_to"}
                ,{field:"location_address"}
                ,{field:"location_long"}
                ,{field:"location_lat"}
                ,{field:"map_type"}
                ,{field:"map_zoom"}
                ,{field:"station_selected"}
                ,{field:"advertising_description"}
                ,{field:"advertising_keys"}
                ,{field:"reboot_exceed_mem_action"}
                ,{field:"reboot_time_action"}
                ,{field:"reboot_error_action"}
                ,{field:"station_mode"}
                ,{field:"power_mode"}
                ,{field:"power_on_day1"}
                ,{field:"power_off_day1"}
                ,{field:"power_on_day2"}
                ,{field:"power_off_day2"}
                ,{field:"power_on_day3"}
                ,{field:"power_off_day3"}
                ,{field:"power_on_day4"}
                ,{field:"power_off_day4"}
                ,{field:"power_on_day5"}
                ,{field:"power_off_day5"}
                ,{field:"power_on_day6"}
                ,{field:"power_off_day6"}
                ,{field:"power_on_day7"}
                ,{field:"power_off_day7"}
                ,{field:"send_notification"}
                ,{field:"frame_rate"}
                ,{field:"quality"}
                ,{field:"transition_enabled"}
                ,{field:"zwave_config"}
                ,{field:"lan_server_enabled"}
                ,{field:"lan_server_ip"}
                ,{field:"lan_server_port"}];
        }
		
        public function getRecord(i_primaryKey:int):Rec_branch_station
        {
            return getRec(i_primaryKey) as Rec_branch_station;
        }

		public override function createRecord():Record
		{
			return new Rec_branch_station;
		}
    }
}

