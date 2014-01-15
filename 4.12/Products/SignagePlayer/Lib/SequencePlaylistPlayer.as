package
{
	public class SequencePlaylistPlayer extends PlaylistPlayer
	{
		private var m_sequenceList:Array;
		private var m_index:int = 0; 
		private var m_count:int = 0;
		private var m_timeline:TimelinePlayer = null;

		
		public function SequencePlaylistPlayer(i_framework:IFramework, i_timelineManager:TimelineManager, i_hCampaign:int)
		{
			super(i_framework, i_timelineManager, i_hCampaign);
			var campaignTimelineSequenceKeys:Array = m_dataBaseManager.table_campaign_timeline_sequences.getAllPrimaryKeys();
			var sequenceList:Array = new Array();
			for each(var hCampaignTimelineSequence:int in campaignTimelineSequenceKeys)
			{
				var recCampaignTimelineSequence:Rec_campaign_timeline_sequence = m_dataBaseManager.table_campaign_timeline_sequences.getRecord(hCampaignTimelineSequence);
				if (recCampaignTimelineSequence.campaign_id==m_hCampaign)
				{
					sequenceList.push(recCampaignTimelineSequence);
				}
			}
			m_sequenceList = sequenceList.sortOn("sequence_index", Array.NUMERIC);
		}
		
		public override  function start():void
		{
			super.start();
			if (m_sequenceList.length==0)
				return;
			m_count = 0;	
			m_index = -1;
			nextTimeline();
		}
		
		public override function stop():void
		{
			super.stop();
			m_index = 0; 
			m_count = 0;
			if (m_timeline!=null)
			{
				m_timeline.stop();
			}
		}

		private function nextTimeline():void
		{
			var newTimeline:TimelinePlayer = m_timeline;
			m_count--;
			if (m_count<=0)
			{
				m_index++;
				if (m_index>=m_sequenceList.length)
					m_index=0;
				var recCampaignTimelineSequence:Rec_campaign_timeline_sequence = m_sequenceList[m_index];
				newTimeline = m_timelineManager.getTimeline(recCampaignTimelineSequence.campaign_timeline_id);
				m_count = recCampaignTimelineSequence.sequence_count;
			} 


			if (m_timeline!=null && m_timeline!=newTimeline) // do not stop timeline if single timeline in loop or repeate
			{
				m_timeline.stop();
			}
			
			m_timeline = newTimeline;
			
			if (m_timeline!=null)
			{
				m_timeline.play();
			}
			else
			{
				m_debugLog.addWarning("SequencePlaylistPlayer.as at nextTimeline()");
				m_index++;
				if (m_sequenceList.length==m_index)
				{
					m_index=0;
					return;
				}
				nextTimeline();
			}
		}
		
		public override function tick(i_time:Number):void
		{
			if (m_timeline!=null)
			{
				if (m_timeline.tick(i_time)==false)
				{
					nextTimeline();
				}
			}	
		}
		
		public override function dispose():void
		{
			m_timeline = null;
		}
	}
}