package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SchedulePlaylistPlayer extends PlaylistPlayer
	{
		private var m_timer:Timer;
		private var m_buffer:Array = new Array();
		private var m_curentSection:TimelineSection;
		private var m_nextSection:TimelineSection;
		private var m_currentPoint:TimelinePoint;
		private var m_nextPoint:TimelinePoint;
		private var m_timeline:TimelinePlayer = null;
		private var m_startTime:Number;
		private var m_delay:Number = 0;

		public function SchedulePlaylistPlayer(i_framework:IFramework, i_timelineManager:TimelineManager, i_hCampaign:int):void
		{
			super(i_framework, i_timelineManager, i_hCampaign);
		}
		
		public override function start():void
		{
			super.start();
			
			var today:Date = new Date();
			today.hours=0; today.minutes=0; today.seconds=0; today.milliseconds = 0;
			buildBuffer(today);
			
			m_timer = new Timer(1000, 1);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			nextTimeline();
		}

		
		private function buildBuffer(i_date:Date):void
		{
			var buffer:Array = new Array();
			var campaignTimelineSchedulePrimaryKeys:Array = m_dataBaseManager.table_campaign_timeline_schedules.getAllPrimaryKeys();
			for each(var campaignTimelineSchedulePk:int in campaignTimelineSchedulePrimaryKeys)
			{
				var exist:Boolean = false;
				var recCampaignTimelineSchedule:Rec_campaign_timeline_schedule = m_dataBaseManager.table_campaign_timeline_schedules.getRecord(campaignTimelineSchedulePk);

				var recCampaignTimeline:Rec_campaign_timeline = m_dataBaseManager.table_campaign_timelines.getRecord(recCampaignTimelineSchedule.campaign_timeline_id);
				if (recCampaignTimeline==null) //??? 
					continue;
				
				if (recCampaignTimeline.campaign_id!=m_hCampaign)
					continue;
				
					
				if (recCampaignTimelineSchedule.pattern_enabled==false)
					continue;


				switch(recCampaignTimelineSchedule.repeat_type)
				{
					case 0: // once
						if (i_date.time==recCampaignTimelineSchedule.start_date.time)
							exist = true;
						break;
					case 1: // dayle
						if (i_date>=recCampaignTimelineSchedule.start_date &&
							i_date<=recCampaignTimelineSchedule.end_date)
						{
							exist = true;
						}
						break;
					case 2: // weekly
						if (i_date>=recCampaignTimelineSchedule.start_date &&
							i_date<=recCampaignTimelineSchedule.end_date)
						{
							switch(i_date.day)
							{
								case 0:
									exist = (recCampaignTimelineSchedule.week_days & 1)!=0;
									break; 
								case 1:
									exist = (recCampaignTimelineSchedule.week_days & 2)!=0;
									break; 
								case 2:
									exist = (recCampaignTimelineSchedule.week_days & 4)!=0;
									break; 
								case 3:
									exist = (recCampaignTimelineSchedule.week_days & 8)!=0;
									break; 
								case 4:
									exist = (recCampaignTimelineSchedule.week_days & 16)!=0;
									break; 
								case 5:
									exist = (recCampaignTimelineSchedule.week_days & 32)!=0;
									break; 
								case 6:
									exist = (recCampaignTimelineSchedule.week_days & 64)!=0;
									break; 
								
							}
						}
						break;
				}
				if (exist)
				{
					addTimeline(buffer, i_date, recCampaignTimelineSchedule);
				}
			}
			
			buffer = buffer.sortOn("time", Array.NUMERIC);
			
			var priortyMap:Object = new Object();
			var pointList:Array = new Array();
			var curTimeline:int = -1;
			var timelinePoint:PriorityTimelinePoint;
			for each(timelinePoint in buffer)
			{
				pointList = priortyMap[timelinePoint.priority];
				if (pointList==null)
				{
					pointList = priortyMap[timelinePoint.priority] = new Array();
				}
				
				if (timelinePoint.action==1)
				{
					pointList.push(timelinePoint);
				}
				else
				{
					var newList:Array = new Array();
					for(var index:int=0;index<pointList.length;index++)
					{
						if (PriorityTimelinePoint(pointList[index]).hCampaignTimelineSchedule==PriorityTimelinePoint(timelinePoint).hCampaignTimelineSchedule)
						{
							pointList.splice(index, 1);
							break;
						}
					}
					pointList = newList;
				}
				priortyMap[timelinePoint.priority] = pointList;
				
				var tmpPoint:PriorityTimelinePoint = null;
				for(var priorty:int=0; priorty<3; priorty++)
				{
					pointList = priortyMap[priorty];
					if (pointList!=null && pointList.length>0)
					{
						tmpPoint = pointList[pointList.length-1];
						break;
					}
				}
				if (tmpPoint!=null && curTimeline!=tmpPoint.hCampaignTimeline)
				{
					curTimeline = tmpPoint.hCampaignTimeline;
					
					var point:TimelinePoint = new TimelinePoint(curTimeline, timelinePoint.time);
					m_buffer.push(point);
				}
			}
		}

		
		private function addTimeline(i_buffer:Array, i_date:Date, i_recCampaignTimelineSchedule:Rec_campaign_timeline_schedule):void
		{
			var recCampaignTimeline:Rec_campaign_timeline = 
				m_dataBaseManager.table_campaign_timelines.getRecord(i_recCampaignTimelineSchedule.campaign_timeline_id);			
			var startTime:Number = i_date.time + i_recCampaignTimelineSchedule.start_time * 1000; 
			i_buffer.push( new PriorityTimelinePoint(1,
				i_recCampaignTimelineSchedule.priorty,
				i_recCampaignTimelineSchedule.campaign_timeline_schedule_id, 
				i_recCampaignTimelineSchedule.campaign_timeline_id, 
				startTime) );			
			
			var duration:Number = i_recCampaignTimelineSchedule.custom_duration ? i_recCampaignTimelineSchedule.duration : recCampaignTimeline.timeline_duration;
			
			i_buffer.push( new PriorityTimelinePoint(
				0,
				i_recCampaignTimelineSchedule.priorty,
				i_recCampaignTimelineSchedule.campaign_timeline_schedule_id,
				i_recCampaignTimelineSchedule.campaign_timeline_id,
				startTime + duration * 1000 ) );
		}
		
		
		private function nextTimeline():void
		{
			try 
			{
				m_startTime = (new Date()).time;
				if (m_currentPoint!=null)
				{
					var timeline:TimelinePlayer	= m_timelineManager.getTimeline(m_currentPoint.hCampaignTimeline);
					if (timeline!=null)
					{
						timeline.stop();
						trace("stop "+m_currentPoint.hCampaignTimeline+ " "+ m_currentPoint.time);
					}
				}
				
				
				while(true)
				{
					m_currentPoint = m_nextPoint;
					m_nextPoint = m_buffer.shift();
					
					if (m_nextPoint==null)
						break;
					m_delay = m_nextPoint.time - m_startTime;
					trace("SHIFT delay="+m_delay);
					if (m_delay>0)
					{
						m_timer.delay = m_delay;
						m_timer.start();
						break;
					}
				}
				
				if (m_currentPoint!=null)
				{
					m_timeline = m_timelineManager.getTimeline(m_currentPoint.hCampaignTimeline);
					if (m_timeline!=null)
					{
						m_timeline.play();
						trace("play "+m_currentPoint.hCampaignTimeline+ " "+ m_currentPoint.time);
					}
				}
				
				if (m_nextPoint==null)
				{
					var tomorrow:Date = new Date();
					tomorrow.hours=0; tomorrow.minutes=0; tomorrow.seconds=0; tomorrow.milliseconds = 0;
					tomorrow.time += 86400000;
					buildBuffer(tomorrow);
					m_delay = tomorrow.time - m_startTime;
					m_timer.delay = m_delay;
					m_timer.start();
				} 
				
			}
			catch(error:Error)
			{
				m_debugLog.addException(error);
			}
		}
		
		private function onTimer(event:TimerEvent):void
		{
			nextTimeline();
		}		
		
		public override function tick(i_time:Number):void
		{
			if (m_timeline!=null)
			{
				if (m_timeline.tick(i_time)==false)
				{
					var now:Number = (new Date()).time;
					var leftTime:Number = m_startTime+m_delay-now;
					if (leftTime>3000)  // if more 3sec re-play timeline. (custom duration)  
					{
						m_timeline.play();
					}
				}
			}	
		}
		
		
		public override function stop():void
		{
			super.stop();
			if (m_timeline!=null)
			{
				m_timeline.stop();
			}		
			
			if (m_timer!=null)
				m_timer.stop();
		}		
	}
}


class TimelinePoint
{
	private var m_hCampaignTimeline:int;
	private var m_time:Number;
	
	public function TimelinePoint(i_hCampaignTimeline:int, i_time:Number)
	{
		m_hCampaignTimeline = i_hCampaignTimeline;
		m_time = i_time;
	}

	public function get hCampaignTimeline():int
	{
		return m_hCampaignTimeline;
	} 
	
	public function get time():Number
	{
		return m_time;
	} 
}

class PriorityTimelinePoint extends TimelinePoint
{
	private var m_action:int;
	private var m_priority:int;
	private var m_hCampaignTimelineSchedule:int;
	
	public function PriorityTimelinePoint(i_action:int, i_priority:int, i_hCampaignTimelineSchedule:int, i_hCampaignTimeline:int, i_time:Number)
	{
		super(i_hCampaignTimeline, i_time);
		m_hCampaignTimelineSchedule = i_hCampaignTimelineSchedule;
		m_action = i_action;
		m_priority = i_priority;
	}
	
	public function get action():int
	{
		return m_action;
	} 

	public function get priority():int
	{
		return m_priority;
	} 

	public function get hCampaignTimelineSchedule():int
	{
		return m_hCampaignTimelineSchedule;
	} 
}
