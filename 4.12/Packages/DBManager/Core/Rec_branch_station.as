package
{
	public class Rec_branch_station extends Record
	{
		public function Rec_branch_station()
		{
		}
		
        public var branch_station_id:int=(-1)
        public var branch_id:int=(-1)
        public var campaign_board_id:int
        public var station_name:String="Station"
        public var reboot_exceed_mem_enabled:Boolean=false
        public var reboot_exceed_mem_value:Number=1
        public var reboot_time_enabled:Boolean=true
        public var reboot_time_value:Number=0
        public var reboot_error_enabled:Boolean=false
        public var monitor_standby_enabled:Boolean=false
        public var monitor_standby_from:Number=3600
        public var monitor_standby_to:Number=14400
        public var location_address:String
        public var location_long:Number=(-1)
        public var location_lat:Number=(-1)
        public var map_type:String
        public var map_zoom:int=4
        public var station_selected:Boolean
        public var advertising_description:String
        public var advertising_keys:String
        public var reboot_exceed_mem_action:int=1
        public var reboot_time_action:int=2
        public var reboot_error_action:int=1
        public var station_mode:int=1
        public var power_mode:int=0
        public var power_on_day1:Number=25200
        public var power_off_day1:Number=68400
        public var power_on_day2:Number=25200
        public var power_off_day2:Number=68400
        public var power_on_day3:Number=25200
        public var power_off_day3:Number=68400
        public var power_on_day4:Number=25200
        public var power_off_day4:Number=68400
        public var power_on_day5:Number=25200
        public var power_off_day5:Number=68400
        public var power_on_day6:Number=25200
        public var power_off_day6:Number=68400
        public var power_on_day7:Number=25200
        public var power_off_day7:Number=68400
        public var send_notification:Boolean=false
        public var frame_rate:int=24
        public var quality:int=2
        public var transition_enabled:Boolean=true
        public var zwave_config:String
        public var lan_server_enabled:Boolean=false
        public var lan_server_ip:String
        public var lan_server_port:int=9999

	}
}
