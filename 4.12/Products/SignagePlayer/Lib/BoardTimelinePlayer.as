package
{
	import flash.utils.Dictionary;
	
	public class BoardTimelinePlayer extends TimelinePlayer
	{
		private var m_templateList:Array = new Array();
		private var m_templateMap:Object = new Object();
		private var m_boardManager:BoardManager;
		private var m_tmplateIndex:int = -1;
		private var m_nextTemplateTime:Number = -1;
		
		public function BoardTimelinePlayer(i_framework:IFramework, i_hCampaignTimeline:int, i_boardManager:BoardManager)
		{
			super(i_framework, i_hCampaignTimeline);
			m_boardManager = i_boardManager;
		}
		
		public function addTemplate(i_campaignChannels:Object, i_hCampaignTimelineBoardTemplate:int):void // need to be sorted!!! ???
		{
			var template:TimelineTemplate = new TimelineTemplate(m_framework, i_hCampaignTimelineBoardTemplate, i_campaignChannels, m_chanles, m_boardManager);
			m_templateMap[i_hCampaignTimelineBoardTemplate] = template; 
			m_templateList.push(template);
		}

		public function getTemplateCount():int
		{
			return m_templateList.length;
		}
				
		public function getTemplateAt(i_index:int):int
		{
			return m_templateList[i_index];
		}

		public function getTemplate(i_hCampaignTimelineBoardTemplate:int):TimelineTemplate
		{
			return m_templateMap[i_hCampaignTimelineBoardTemplate];
		}
		

		public override function sort():void
		{
			super.sort();
			m_templateList.sortOn("template_offset_time", Array.NUMERIC); 
		}
		
		public override function play():void
		{
			super.play();
			m_tmplateIndex = -1;
			m_nextTemplateTime = -1;
		}
		
		public override function stop():void
		{
			super.stop();
			stopTemplate();
		}
		
		private function stopTemplate():void
		{
			if (m_tmplateIndex>-1)
			{
				var oldTemplate:TimelineTemplate = m_templateList[m_tmplateIndex];
				oldTemplate.stop();
			}
		}
		
		public override function tick(i_time:Number):Boolean
		{
			if (super.tick(i_time)==false)
				return false;
			
			try
			{
				if (m_offsetTime>m_nextTemplateTime)
				{
					m_tmplateIndex++;	
					var template:TimelineTemplate;	
					template = m_templateList[m_tmplateIndex];
					template.start();
					
					
					// next template
					template = m_templateList[m_tmplateIndex+1];
					if (template==null)
					{
						m_nextTemplateTime = 100000000;
					}
					else
					{
						var recCampaignTimelineBoardTemplate:Rec_campaign_timeline_board_template = m_dataBaseManager.table_campaign_timeline_board_templates.getRecord(template.m_hCampaignTimelineBoardTemplate);
						m_nextTemplateTime = recCampaignTimelineBoardTemplate.template_offset_time * 1000;
					}				
				}
			}
			catch(error:Error)
			{
				m_debugLog.addInfo("BoardTimelinePlayer.tick()");
				m_debugLog.addException(error);
			}
			return true;
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			if (m_templateList!=null)
			{
				for each(var timelineTemplate:TimelineTemplate in m_templateList)
				{
					timelineTemplate.dispose();
				}
				m_templateList = null;
			}
			m_templateMap = null;
			m_boardManager = null;
		}
	}
}
