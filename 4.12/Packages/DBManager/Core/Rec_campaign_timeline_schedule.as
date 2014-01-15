package
{
	public class Rec_campaign_timeline_schedule extends Record
	{
		public function Rec_campaign_timeline_schedule()
		{
		}
		
        public var campaign_timeline_schedule_id:int=(-1)
        public var campaign_timeline_id:int=(-1)
        public var priorty:int=0
        public var start_date:Date= new Date(2007, 10, 24)
        public var end_date:Date= new Date(2007, 10, 25)
        public var repeat_type:int=0
        public var week_days:int=0
        public var custom_duration:Boolean=false
        public var duration:Number=0
        public var start_time:Number=0
        public var pattern_enabled:Boolean=true
        public var pattern_name:String="pattern"

	}
}
