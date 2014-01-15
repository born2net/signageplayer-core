package
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElementContainer;

	public class PlayerLoaderService extends EventDispatcher implements IPlayerLoaderService
	{
		protected var m_framework:IFramework;
		protected var m_styleService:IStyleService;
		protected var m_playerDataService:PlayerDataService;
		

		
		
		public function PlayerLoaderService(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_styleService = m_framework.ServiceBroker.QueryService("StyleService") as IStyleService;
			m_playerDataService = createPlayerDataService();
		}
		

		protected function createPlayerDataService():PlayerDataService
		{
			return new PlayerDataService(m_framework);
		}	
		
		
		public function get playerDataService():IPlayerDataService
		{
			return m_playerDataService;
		}
		
		public function createPlayerLoader():IPlayerLoader
		{
			var playerLoader:PlayerLoader = new PlayerLoader();
			playerLoader.framework = m_framework;
			return playerLoader;
		}
	}
}