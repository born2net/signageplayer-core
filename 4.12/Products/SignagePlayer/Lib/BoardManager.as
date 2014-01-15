package
{
	import flash.utils.Dictionary;
	
	public class BoardManager
	{
		private var m_framework:IFramework;
		private var m_databaseManager:DataBaseManager;
		private var m_templates:Object = new Object();
		private var m_hBoard:int;
		
		
		public function BoardManager(i_framework:IFramework, i_hBoard:int)
		{
			m_framework = i_framework;
			m_hBoard = i_hBoard;
			m_databaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
		}
		
		public function init():void
		{
			var recBoardTemplate:Rec_board_template;
			var templeteKeys:Array = m_databaseManager.table_board_templates.getAllPrimaryKeys();
			for each(var hTemplate:int in templeteKeys) 
			{
				recBoardTemplate = m_databaseManager.table_board_templates.getRecord(hTemplate);
				if (recBoardTemplate.board_id!=m_hBoard)
					continue;
				
				addTemplate(hTemplate);
			}
			var viewerKeys:Array = m_databaseManager.table_board_template_viewers.getAllPrimaryKeys();
			for each(var hViewer:int in viewerKeys)
			{
				var recBoardTemplateViewer:Rec_board_template_viewer = m_databaseManager.table_board_template_viewers.getRecord(hViewer);
				
				recBoardTemplate = m_databaseManager.table_board_templates.getRecord(recBoardTemplateViewer.board_template_id);
				if (recBoardTemplate==null)
					continue;
				
				if (recBoardTemplate.board_id!=m_hBoard)
					continue;				
				
				var boardTemplate:BoardTemplate = getTemplate(recBoardTemplateViewer.board_template_id);
				if (boardTemplate!=null) // ??? No need to check after fixing the sql statment!
					boardTemplate.addBoardTemplateViewer(hViewer);
			}
		}
		
		public function addTemplate(i_hBoardTemplate:int):void
		{
			m_templates[i_hBoardTemplate] = new BoardTemplate(m_framework);
		}
		
		public function getTemplate(i_hBoardTemplate:int):BoardTemplate
		{
			return m_templates[i_hBoardTemplate];
		}
		
		public function dispose():void
		{
			m_framework = null;
			m_databaseManager = null;
			if (m_templates!=null)
			{
				for each(var boardTemplate:BoardTemplate in m_templates)
				{
					boardTemplate.dispose();
				}
				m_templates = null;
			}
		}
	}
}