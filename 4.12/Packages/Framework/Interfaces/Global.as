package
{
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary 
	
	public class Global
	{
		private static var m_frameworkMap:Dictionary = new Dictionary();
		
		public static function registerFramework(i_stage:Stage, i_framework:IFramework):void
		{
			m_frameworkMap[i_stage] = i_framework;
		}

		public static function getFramework(i_ctrl:DisplayObject):IFramework
		{
			return m_frameworkMap[i_ctrl.stage] as IFramework;
		}
	}
}