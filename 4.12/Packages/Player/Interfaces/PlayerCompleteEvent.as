package
{
	import flash.events.Event;
	
	public class PlayerCompleteEvent extends Event
	{
		public static const PLAYER_COMPLETE:String = "player_complete_event";
				
		private var m_player:IPlayer;		
				
		public function PlayerCompleteEvent(i_type:String, i_player:IPlayer)
		{
			super(i_type);
			m_player = i_player;
		}


		public function get player():IPlayer
		{
			return m_player;
		}
	}
}