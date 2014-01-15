package
{
	public class TimelineTemplate
	{
		private var m_framework:IFramework;
		private var m_dataBaseManager:DataBaseManager;
		private var m_viewerService:IViewerService;
		public  var m_hCampaignTimelineBoardTemplate:int;
		private var m_boardManager:BoardManager;
		private var m_chanles:Object;
		private var m_campaignChannels:Object;
		private var m_localViewerChannels:Array = new Array();
		private var m_commonViewerChannels:Array = new Array();
		
		public var template_offset_time:Number;
		
		public function TimelineTemplate(i_framework:IFramework, i_hCampaignTimelineBoardTemplate:int, i_campaignChannels:Object, i_chanles:Object, i_boardManager:BoardManager)
		{
			m_framework = i_framework;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_viewerService = m_framework.ServiceBroker.QueryService("ViewerService") as IViewerService;
			m_hCampaignTimelineBoardTemplate = i_hCampaignTimelineBoardTemplate;
			m_campaignChannels = i_campaignChannels;
			m_chanles = i_chanles;
			m_boardManager = i_boardManager;
			
			var recCampaignTimelineBoardTemplate:Rec_campaign_timeline_board_template = m_dataBaseManager.table_campaign_timeline_board_templates.getRecord(m_hCampaignTimelineBoardTemplate);
			template_offset_time = recCampaignTimelineBoardTemplate.template_offset_time;
		}
		
		public function addLocalViewerChanel(i_hLocalViewerChanel:int):void
		{
			m_localViewerChannels.push(i_hLocalViewerChanel);
		}

		public function addCommonViewerChanel(i_hCommonViewerChanel:int):void
		{
			m_commonViewerChannels.push(i_hCommonViewerChanel);
		}
		
		public function start():void
		{
			m_viewerService.hideAllViewers(); //???
			
			var recCampaignTimelineBoardTemplate:Rec_campaign_timeline_board_template = m_dataBaseManager.table_campaign_timeline_board_templates.getRecord(m_hCampaignTimelineBoardTemplate);
			var boardTemplate:BoardTemplate = m_boardManager.getTemplate(recCampaignTimelineBoardTemplate.board_template_id);
			
			var chanel:Channel;
			var viewer:IViewer;
			
			// Local channels
			var recViewerChanel:Rec_campaign_timeline_board_viewer_chanel;
			for each(var hViewerChanel:int in m_localViewerChannels)
			{
				recViewerChanel = m_dataBaseManager.table_campaign_timeline_board_viewer_chanels.getRecord(hViewerChanel);
				chanel = m_chanles[recViewerChanel.campaign_timeline_chanel_id];
				viewer = boardTemplate.getBoardTemplateViewer(chanel, recViewerChanel.board_template_viewer_id);
				if (viewer==null)
					continue; //???
			}
			
			// Common channels
			var recCommonViewerChannel:Rec_campaign_timeline_board_viewer_channel;
			for each(var hCommonViewerChannel:int in m_commonViewerChannels)
			{
				recCommonViewerChannel = m_dataBaseManager.table_campaign_timeline_board_viewer_channels.getRecord(hCommonViewerChannel);
				chanel = m_campaignChannels[recCommonViewerChannel.campaign_channel_id];
				viewer = boardTemplate.getBoardTemplateViewer(chanel, recCommonViewerChannel.board_template_viewer_id);
				if (viewer==null)
					continue; //???
			}
			
			m_viewerService.orderViewers();
		}
		
		public function stop():void
		{
			for each(var chanel:Channel in m_chanles)
			{
				chanel.unassignViewers();
			}
			m_viewerService.hideAllViewers();
		}
		
		public function dispose():void
		{
			m_framework = null;
			m_dataBaseManager = null;
			m_viewerService = null;
			m_boardManager = null;
			m_chanles = null;
			m_localViewerChannels = null;
		}
	}
}