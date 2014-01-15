package
{
	import flash.display.Stage;
	import flash.display.StageAspectRatio;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	public class ViewerServiceMobile extends ViewerService
	{
		private var m_stage:Stage;
		
		public function ViewerServiceMobile(i_framework:IFramework, i_container:IVisualElementContainer)
		{
			super(i_framework, i_container);
		}
		
		public function init(i_stage:Stage):void
		{
			if (m_stage==null)
			{
				m_stage = i_stage;
				m_stage.addEventListener(Event.RESIZE, orientationChanged);
			}
		}
		
		public override function updateScale(i_screenWidth:Number, i_screenHeight:Number, i_orientationEnabled:Boolean):void
		{
			m_screenWidth = i_screenWidth;
			m_screenHeight = i_screenHeight;
			
			refreshScale();
		}
		
		
		private function orientationChanged(event:Event):void 
		{
			refreshScale();
		}
		
		protected override function refreshScale():void
		{
			if (m_stage==null)
				return;
			
			if (isNaN(m_screenWidth) || isNaN(m_screenHeight))
				return;
			
			if (m_totalRect==null)
				return;
			
			var templateLong:Number = Math.max(m_screenWidth, m_screenHeight);
			var templateSort:Number = Math.min(m_screenWidth, m_screenHeight);
			
			
			//var screenLong:Number = Math.max(m_stage.fullScreenWidth, m_stage.fullScreenHeight);
			//var screenSort:Number = Math.min(m_stage.fullScreenWidth, m_stage.fullScreenHeight);
			var screenLong:Number = Math.max(m_totalRect.width, m_totalRect.height);
			var screenSort:Number = Math.min(m_totalRect.width, m_totalRect.height);
			
			if (m_stage.fullScreenWidth > m_stage.fullScreenHeight)
			{
				m_scaleX = screenLong / templateLong; 
				m_scaleY = screenSort / templateSort;
			}
			else
			{
				m_scaleX = screenSort / templateLong; 
				m_scaleY = screenLong / templateSort;
			}
			
			
			var viewer:ViewerWeb = null;
			for each(viewer in m_viewers)
			{
				viewer.setScale(m_scaleX, m_scaleY);
			}
		}
		
	}
}
