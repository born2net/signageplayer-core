package
{
	import mx.core.IVisualElementContainer;

	
	public interface IPlayerTransitionService
	{
		function createPlayerTransition(i_container:IVisualElementContainer):IPlayerTransition;
	}
}