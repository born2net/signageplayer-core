package
{
	public class Rec_campaign extends Record
	{
		public function Rec_campaign()
		{
		}
		
        public var campaign_id:int=(-1)
        public var campaign_name:String="Campaign"
        public var campaign_playlist_mode:int=0
        public var kiosk_mode:Boolean=false
        public var kiosk_key:String="esc"
        public var kiosk_timeline_id:int
        public var kiosk_wait_time:Number=5
        public var mouse_interrupt_mode:Boolean=false
        public var tree_path:String=""
        public var access_key:int=0

	}
}
