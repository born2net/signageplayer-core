package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	
	import spark.components.Group;
	
	public class ViewerServiceWeb extends ViewerService
	{
		protected var m_topContainer:IVisualElementContainer;
		protected var m_container:Group;
		protected var m_snapshot:UIComponent;
		protected var m_transitionEnabled:Boolean = true;
		private var m_fadeScreen:Fade;
		
		
		public function ViewerServiceWeb(i_framework:IFramework, i_topContainer:IVisualElementContainer)
		{
			super(i_framework);
			m_topContainer = i_topContainer;
			m_container = new Group();
			m_snapshot = new UIComponent();
			m_topContainer.addElement(m_container);
			m_topContainer.addElement(m_snapshot);
			updateSize();
		}
		
		
		public function set transitionEnabled(i_transitionEnabled:Boolean):void
		{
			m_transitionEnabled = i_transitionEnabled;
			
			if (m_viewers!=null)
			{
				var viewer:ViewerWeb = null;
				for each(viewer in m_viewers)
				{
					viewer.transitionEnabled = i_transitionEnabled;
				}
			}
		}
		
		
		protected override function refreshScale():void
		{
			if (isNaN(m_screenWidth) || isNaN(m_screenHeight))
				return;
			
			var long:Number = Math.max(m_totalRect.width, m_totalRect.height);
			var sort:Number = Math.min(m_totalRect.width, m_totalRect.height);
			if (m_orientationEnabled)
			{
				if (m_landscape)
				{
					m_scaleX = long / m_screenWidth; 
					m_scaleY = sort / m_screenHeight;
					UIComponent(m_topContainer).width = long;
					UIComponent(m_topContainer).height = sort;
				}
				else
				{
					m_scaleX = sort / m_screenWidth; 
					m_scaleY = long / m_screenHeight;
					UIComponent(m_topContainer).width = sort;
					UIComponent(m_topContainer).height = long;
				}
				updateSize();
			}
			else
			{
				m_scaleX = m_totalRect.width / m_screenWidth; 
				m_scaleY = m_totalRect.height / m_screenHeight;
			}
			
			var viewer:ViewerWeb = null;
			for each(viewer in m_viewers)
			{
				viewer.setScale(m_scaleX, m_scaleY);
			}
		}
		
		protected function updateSize():void
		{
			UIComponent(m_container).width = UIComponent(m_topContainer).width;
			UIComponent(m_container).height = UIComponent(m_topContainer).height;
			UIComponent(m_snapshot).width = UIComponent(m_topContainer).width;
			UIComponent(m_snapshot).height = UIComponent(m_topContainer).height;
		}
		
		public override function removeAllViewers():void
		{
			m_container.removeAllElements();
			m_viewers = new Array();
		}
		
		protected override function newViewer():IViewer
		{
			var viewer:ViewerWeb = new ViewerWeb(m_framework);
			viewer.transitionEnabled = m_transitionEnabled;
			return viewer;
		}
		
		public override function orderViewers():void
		{
			var array:ArrayCollection = new ArrayCollection();
			var viewer:UIComponent;
			for each(viewer in m_viewers)
			{
				array.addItem(viewer);
			}
			var sort:Sort = new Sort();
			sort.fields = [new SortField("order")];
			array.sort = sort;
			array.refresh();
			
			var index:int = 0;
			for (var i:int = 0; i<m_container.numElements; i++)
			{
				if (m_container.getElementAt(i) is IViewer)
					break;
				index++;
			}
			
			for each(viewer in array)
			{
				if (UIComponent(m_container).contains(viewer)==false || index!=m_container.getElementIndex(viewer))
				{
					//  use addChild to rawChildren to prevent: 
					// bug: 483 - Video stops playing on transition from one screen division to another. 
					// bug  487 - Video does not auto-repeat if its the only resource in a screen division.
					m_container.addElementAt(viewer, index);
					viewer.invalidateProperties();
					viewer.invalidateDisplayList();
				}
				
				
				if (IViewer(viewer).inUse==false)
				{
					if (viewer.visible==true)
					{
						viewer.visible = false;
						if (IViewer(viewer).playerLoader!=null)
						{
							IViewer(viewer).playerLoader.stop();
						}
					}
				}
				else
				{
					if (viewer.visible==false)
					{
						viewer.visible = true;
						if (IViewer(viewer).playerLoader!=null)
						{
							IViewer(viewer).playerLoader.start();
						}
					}
				}
				
				
				index++;
			}
		}
		
		
		public function beginScreenTransition():void
		{
			if (m_transitionEnabled==false)
				return;
			
			if (m_fadeScreen!=null)
				return;
			
			var topWindow:UIComponent = m_framework.StateBroker.GetState("topWindow") as UIComponent;
			var bd : BitmapData = new BitmapData( topWindow.width, topWindow.height );
			bd.draw( topWindow );
			var bmp:Bitmap = new Bitmap( bd );
			m_snapshot.addChild(bmp);
			
			
			m_fadeScreen = new Fade(bmp);
			m_fadeScreen.duration = 1000;
			m_fadeScreen.alphaFrom = 1;
			m_fadeScreen.alphaTo = 0;
			m_fadeScreen.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
			m_fadeScreen.play();
			
		}
		
		
		private function onEffectEnd(event:EffectEvent):void
		{
			endScreenTransition();
		}
		
		protected function endScreenTransition():void
		{
			if (m_fadeScreen!=null)
			{
				var bmp:Bitmap = Bitmap(m_fadeScreen.target);
				m_fadeScreen.removeEventListener(EffectEvent.EFFECT_END, onEffectEnd);
				m_snapshot.removeChild(bmp);
				m_fadeScreen = null;
			}
		}
		
	}
}
