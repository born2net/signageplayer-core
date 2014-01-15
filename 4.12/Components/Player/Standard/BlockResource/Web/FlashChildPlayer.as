package
{
	import flash.display.MovieClip;
	
	public class FlashChildPlayer implements IChildPlayer
	{
		private var m_player:MovieClip;
		
		public function FlashChildPlayer(i_player:MovieClip)
		{
			m_player = i_player;
		}
		
		public function set framework(i_framework:Object):void
		{
			m_player.framework = i_framework;
		}
		
		public function get framework():Object
		{
			return m_player.framework;
		}
		
		public function getPropertyDefinitions():XML
		{
			return m_player.getPropertyDefinitions();
		}
		
		public function set data(i_data:Object):void
		{
			m_player.data = i_data;
		}
		
		public function get data():Object
		{
			return m_player.data;
		}
		
		public function refresh():void
		{
			m_player.refresh();
		}
		
		public function start():void
		{
			m_player.start();
		}
		
		public function stop():void
		{
			m_player.stop();
		}
		
		public function dispose():void
		{
			m_player.dispose();
		}
	}
}