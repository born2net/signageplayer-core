function Rec_branch_station()
{
    Record.call(this);

    this.branch_station_id = (-1);
    this.branch_id = (-1);
    this.campaign_board_id;
    this.station_name = "Station";
    this.reboot_exceed_mem_enabled = false;
    this.reboot_exceed_mem_value = 1;
    this.reboot_time_enabled = true;
    this.reboot_time_value = 0;
    this.reboot_error_enabled = false;
    this.monitor_standby_enabled = false;
    this.monitor_standby_from = 3600;
    this.monitor_standby_to = 14400;
    this.location_address;
    this.location_long = (-1);
    this.location_lat = (-1);
    this.map_type;
    this.map_zoom = 4;
    this.station_selected;
    this.advertising_description;
    this.advertising_keys;
    this.reboot_exceed_mem_action = 1;
    this.reboot_time_action = 2;
    this.reboot_error_action = 1;
    this.station_mode = 1;
    this.power_mode = 0;
    this.power_on_day1 = 25200;
    this.power_off_day1 = 68400;
    this.power_on_day2 = 25200;
    this.power_off_day2 = 68400;
    this.power_on_day3 = 25200;
    this.power_off_day3 = 68400;
    this.power_on_day4 = 25200;
    this.power_off_day4 = 68400;
    this.power_on_day5 = 25200;
    this.power_off_day5 = 68400;
    this.power_on_day6 = 25200;
    this.power_off_day6 = 68400;
    this.power_on_day7 = 25200;
    this.power_off_day7 = 68400;
    this.send_notification = false;
    this.frame_rate = 24;
    this.quality = 2;
    this.transition_enabled = true;
    this.zwave_config;
    this.lan_server_enabled = false;
    this.lan_server_ip;
    this.lan_server_port = 9999;

}

extend(Record, Rec_branch_station);
