package
{
	public class Rec_resource extends Record
	{
		public function Rec_resource()
		{
		}
		
        public var resource_id:int=(-1)
        public var resource_name:String="Resource"
        public var resource_type:String
        public var resource_pixel_width:int=0
        public var resource_pixel_height:int=0
        public var default_player:int
        public var snapshot:String
        public var resource_total_time:Number=0
        public var resource_date_created:Number
        public var resource_date_modified:Number
        public var resource_trust:Boolean=false
        public var resource_public:Boolean=false
        public var resource_bytes_total:Number=0
        public var resource_module:Boolean=false
        public var tree_path:String=""
        public var access_key:int=0
        public var resource_html:Boolean=false

	}
}
