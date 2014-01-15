package
{
	import flash.utils.Dictionary;
	
	public class BoardTemplate
	{
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_viewerService:IViewerService;
		
		private var m_viewers:Object = new Object();
		
		public function BoardTemplate(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_viewerService = m_framework.ServiceBroker.QueryService("ViewerService") as IViewerService;
		}
		
		public function addBoardTemplateViewer(i_hBoardTemplateViewer:int):void
		{
			var recBoardTemplateViewer:Rec_board_template_viewer = 
				m_dataBaseManager.table_board_template_viewers.getRecord(i_hBoardTemplateViewer);


			var viewer:ViewerInfo = new ViewerInfo();			
			m_viewers[i_hBoardTemplateViewer] = viewer;
			viewer.width = recBoardTemplateViewer.pixel_width;
			viewer.height = recBoardTemplateViewer.pixel_height;
			viewer.x = recBoardTemplateViewer.pixel_x;
			viewer.y = recBoardTemplateViewer.pixel_y;
			viewer.order = recBoardTemplateViewer.viewer_order;
		}
		
		public function getBoardTemplateViewer(i_chanel:Channel, i_hBoardTemplateViewer:int):IViewer
		{
			var viewerInfo:ViewerInfo = m_viewers[i_hBoardTemplateViewer];
			if (viewerInfo==null)
				return null; //???
			var viewer:IViewer = m_viewerService.createViewer(	i_chanel, 
																viewerInfo.x,
																viewerInfo.y,
																viewerInfo.width,
																viewerInfo.height,
																viewerInfo.order);
			return viewer;
		} 
		
		public function dispose():void
		{
			m_framework = null;
			m_viewerService = null; 
			m_dataBaseManager = null;
			m_viewers = null;
		}
	}
}