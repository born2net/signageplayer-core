package
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;	
	
	public class ViewerService implements IViewerService
	{
		protected var m_framework:IFramework
		protected var m_viewers:Array = new Array();
		protected var m_totalRect:Rectangle;
		protected var m_scaleX:Number = 1.0;
		protected var m_scaleY:Number = 1.0;
		protected var m_screenWidth:Number;
		protected var m_screenHeight:Number;
		protected var m_landscape:Boolean = true;
		protected var m_orientationEnabled:Boolean = false;
		
		public function ViewerService(i_framework:IFramework)
		{
			m_framework = i_framework;
		}
		
		public function setTotalRect(i_totalRect:Rectangle):void
		{
			m_totalRect = i_totalRect;
			refreshScale();
		}

		public function updateScale(i_screenWidth:Number, i_screenHeight:Number, i_orientationEnabled:Boolean):void
		{
			m_screenWidth = i_screenWidth;
			m_screenHeight = i_screenHeight;
			m_orientationEnabled = i_orientationEnabled;
			refreshScale();
		}		
		
		
		public function get landscape():Boolean
		{
			return m_landscape;
		}

		public function set landscape(i_landscape:Boolean):void
		{
			m_landscape = i_landscape;
			refreshScale();
		}

		protected function refreshScale():void
		{
			if (isNaN(m_screenWidth) || isNaN(m_screenHeight))
				return;
			
			var long:Number;
			var sort:Number;
			if (m_orientationEnabled)
			{
				long = Math.max(m_totalRect.width, m_totalRect.height);
				sort = Math.min(m_totalRect.width, m_totalRect.height);
				if (m_landscape)
				{
					m_scaleX = long / m_screenWidth; 
					m_scaleY = sort / m_screenHeight;
				}
				else
				{
					m_scaleX = sort / m_screenWidth; 
					m_scaleY = long / m_screenHeight;
				}
			}
			else
			{
				m_scaleX = m_totalRect.width / m_screenWidth; 
				m_scaleY = m_totalRect.height / m_screenHeight;
			}
		}
		
		private function foundViewer(i_commonChannel:Boolean, i_hChanel:int):IViewer
		{
			var freeViewer:IViewer = null;
			var viewer:IViewer = null;
			for each(viewer in m_viewers)
			{
				//trace("compare: "+viewer.hChanel+"  "+i_hChanel);
				if (viewer.inUse==false)
				{
					if (viewer.commonChannel==i_commonChannel && viewer.hChanel==i_hChanel)
					{
						//trace("$$$");
						viewer.inUse = true;
						return viewer;
					}
					else if (freeViewer==null && viewer.hChanel==-1)
					{
						freeViewer = viewer;
						//???freeViewer.hChanel = i_hChanel;
					}
				}
			}
			if (freeViewer!=null)
			{
				freeViewer.inUse = true;
			}
			return freeViewer;
		}
		
		
		public function createViewer(i_chanel:IChannel, i_x:Number, i_y:Number, i_width:Number, i_height:Number, i_order:int):IViewer
		{
			var viewer:IViewer = foundViewer(i_chanel.commonChannel, i_chanel.hChannel);
			if (viewer==null)
			{
				viewer = newViewer();
				viewer.inUse = true;
				viewer.commonChannel = i_chanel.commonChannel;
				viewer.hChanel = i_chanel.hChannel;
				//trace("createViewer: hChanel="+viewer.hChanel);
				m_viewers.push(viewer);
				i_chanel.assignViewer(viewer);
			}
			else
			{
				if (viewer.hChanel==-1)
				{
					//trace("### 2");
					viewer.commonChannel = i_chanel.commonChannel;
					viewer.hChanel = i_chanel.hChannel;
					i_chanel.assignViewer(viewer);
				}
				else
				{
					//trace("### 1");
				}
			}
			
			viewer.order = i_order;
			
			
			viewer.setRect(i_x, i_y, i_width, i_height);
			viewer.setScale(m_scaleX, m_scaleY);
			return viewer;
		}
		

		public function hideAllViewers():void
		{
			for each(var viewer:IViewer in m_viewers)
			{
				viewer.inUse = false;	
			} 
		}
		
		public function cleanChanels(i_commonChannel:Boolean):void
		{
			for each(var viewer:IViewer in m_viewers)
			{
				if (i_commonChannel==true && viewer.commonChannel==true ||
					i_commonChannel==false && viewer.commonChannel==false)
				{
					viewer.clean();	
				}
			} 
		}

		public function removeAllViewers():void
		{
		}

		public function orderViewers():void
		{
			
		}
		
		protected function newViewer():IViewer
		{
			return null;
		}
	}
}