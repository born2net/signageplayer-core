package
{
	import flash.events.Event;

	public class MyModuleEvent extends Event
	{
		public static var MODULE_BEGIN_LOADING:String = "event_module_begin_loading";
		private var m_url:String;
		
		public function MyModuleEvent(i_type:String, i_url:String)
		{
			super(i_type);
			m_url = i_url;
		}
		
		public function get url():String
		{
			return m_url;
		}
	}
}