package
{
	public class BoardTimelineManager extends TimelineManager
	{
		private var m_boardManager:BoardManager
		
		private var  m_hCampaignBoard:int;
		
		public function BoardTimelineManager(i_framework:IFramework, i_hCampaign:int, i_hBoard:int, i_hCampaignBoard:int)
		{
			super(i_framework, i_hCampaign);
			m_hCampaignBoard = i_hCampaignBoard;
			m_boardManager = new BoardManager(i_framework, i_hBoard);
		}
		
		public override function init(i_campaignChannles:Object):void
		{
			var timeline:TimelinePlayer;
			var recChanel:Rec_campaign_timeline_chanel;
			var recCampaignTimeline:Rec_campaign_timeline;
			
			var templeteKeys:Array = m_dataBaseManager.table_campaign_timeline_board_templates.getAllPrimaryKeys();
			for each(var hTemplate:int in templeteKeys) 
			{
				var recTemplate:Rec_campaign_timeline_board_template = m_dataBaseManager.table_campaign_timeline_board_templates.getRecord(hTemplate);
				if (recTemplate.campaign_board_id!=m_hCampaignBoard)
					continue;
				
				recCampaignTimeline = m_dataBaseManager.table_campaign_timelines.getRecord(recTemplate.campaign_timeline_id);
				if (recCampaignTimeline.campaign_id!=m_hCampaign)
					continue;				
				
				if (m_timelines[recTemplate.campaign_timeline_id]==null)
					m_timelines[recTemplate.campaign_timeline_id] = new BoardTimelinePlayer(m_framework, recTemplate.campaign_timeline_id, m_boardManager);
				(m_timelines[recTemplate.campaign_timeline_id] as BoardTimelinePlayer).addTemplate(i_campaignChannles, hTemplate); 
			}
			
			var recCampaignTimelineBoardTemplate:Rec_campaign_timeline_board_template;
			var template:TimelineTemplate;

			// populate Local viewer channels
			var viewerChanelKeys:Array = m_dataBaseManager.table_campaign_timeline_board_viewer_chanels.getAllPrimaryKeys();
			for each(var hViewerChanel:int in viewerChanelKeys) 
			{
				var recViewerChanel:Rec_campaign_timeline_board_viewer_chanel = m_dataBaseManager.table_campaign_timeline_board_viewer_chanels.getRecord(hViewerChanel);
				recCampaignTimelineBoardTemplate = m_dataBaseManager.table_campaign_timeline_board_templates.getRecord(recViewerChanel.campaign_timeline_board_template_id);
				
				if (recCampaignTimelineBoardTemplate==null)
					continue;
				
				if (recCampaignTimelineBoardTemplate.campaign_board_id!=m_hCampaignBoard)
					continue;
				
				recCampaignTimeline = m_dataBaseManager.table_campaign_timelines.getRecord(recCampaignTimelineBoardTemplate.campaign_timeline_id);
				if (recCampaignTimeline.campaign_id!=m_hCampaign)
					continue;					
				
				
				if (recCampaignTimelineBoardTemplate!=null) //???
				{
					timeline = m_timelines[recCampaignTimelineBoardTemplate.campaign_timeline_id];
					if (timeline!=null) //???
					{
						template = (timeline as BoardTimelinePlayer).getTemplate(recViewerChanel.campaign_timeline_board_template_id);
						template.addLocalViewerChanel(hViewerChanel);
					}
				}
			}
			
			// populate Common viewer channels
			var commonViewerChannelKeys:Array = m_dataBaseManager.table_campaign_timeline_board_viewer_channels.getAllPrimaryKeys();
			for each(var hCommonViewerChanel:int in commonViewerChannelKeys)
			{
				var recCommonViewerChannel:Rec_campaign_timeline_board_viewer_channel = m_dataBaseManager.table_campaign_timeline_board_viewer_channels.getRecord(hCommonViewerChanel);
				recCampaignTimelineBoardTemplate = m_dataBaseManager.table_campaign_timeline_board_templates.getRecord(recCommonViewerChannel.campaign_timeline_board_template_id);
				if (recCampaignTimelineBoardTemplate==null)
					continue;
				
				
				recCampaignTimeline = m_dataBaseManager.table_campaign_timelines.getRecord(recCampaignTimelineBoardTemplate.campaign_timeline_id);
				if (recCampaignTimeline.campaign_id!=m_hCampaign)
					continue;					
				
				
				if (recCampaignTimelineBoardTemplate!=null) //???
				{
					timeline = m_timelines[recCampaignTimelineBoardTemplate.campaign_timeline_id];
					if (timeline!=null) //???
					{
						template = (timeline as BoardTimelinePlayer).getTemplate(recCommonViewerChannel.campaign_timeline_board_template_id);
						if (template!=null)
						{
							template.addCommonViewerChanel(hCommonViewerChanel);
						}
					}
				}

			}


			super.init(i_campaignChannles);			
			
			
			m_boardManager.init(); //???
		}
		
		public override function dispose():void
		{
			super.dispose();
			if (m_boardManager!=null)
			{
				m_boardManager.dispose();
				m_boardManager = null;
			}
		}
	}
}