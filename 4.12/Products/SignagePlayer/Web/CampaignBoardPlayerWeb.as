package
{
	import mx.core.IVisualElementContainer;
	
	public class CampaignBoardPlayerWeb extends CampaignBoardPlayer
	{
		import mx.events.ModuleEvent; 
		import mx.rpc.events.ResultEvent;
		import mx.rpc.events.FaultEvent;

		private var m_componentLoader:ComponentLoader;

		public function CampaignBoardPlayerWeb(i_framework:IFramework, i_container:IVisualElementContainer, i_transitionEnabled:Boolean)
		{
			super(i_framework);
			m_viewerService = new ViewerServiceWeb(i_framework, i_container);
			m_framework.ServiceBroker.RegisterService("ViewerService", m_viewerService);
		}


		public override function initTableData():void
		{
			super.initTableData();
			start();
		}
	}
}
