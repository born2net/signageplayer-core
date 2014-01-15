package
{
	public class Rec_ad_local_package extends Record
	{
		public function Rec_ad_local_package()
		{
		}
		
        public var ad_local_package_id:int
        public var enabled:Boolean=true
        public var package_name:String="Package"
        public var use_date_range:Boolean=false
        public var start_date:Date= new Date()
        public var end_date:Date= new Date()

	}
}
