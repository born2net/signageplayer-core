package
{
	import mx.core.IVisualElementContainer;

	public class PlayerTransitionService implements IPlayerTransitionService
	{
		protected var m_framework:IFramework;
		
		public function PlayerTransitionService(i_framework:IFramework)
		{
			m_framework = i_framework;
		}
		
		public function createPlayerTransition(i_container:IVisualElementContainer):IPlayerTransition
		{
			return new PlayerTransition(m_framework, i_container);
		}
	}
}