package
{
	import flash.display.NativeWindow;
	import flash.display.Screen;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.AIREvent;
	
	
	public class ViewerServiceAir extends ViewerService
	{
		private var m_newViewersCount:int = 0;
		
		public function ViewerServiceAir(i_framework:IFramework)
		{
			super(i_framework);
		}

		public override function createViewer(i_chanel:IChannel, i_x:Number, i_y:Number, i_width:Number, i_height:Number, i_order:int):IViewer
		{
			trace("createViewer "+i_x+", "+i_y);
			var viewer:ViewerWindow = ViewerWindow(super.createViewer(i_chanel, i_x, i_y, i_width, i_height, i_order));
			return viewer;
		}
		
		public override function orderViewers():void
		{
			if (m_newViewersCount>0)
				return;
			var array:ArrayCollection = new ArrayCollection();
			var viewer:ViewerWindow;
			for each(viewer in m_viewers)
			{
				array.addItem(viewer);
			}
			var sort:Sort = new Sort();
		    sort.fields = [new SortField("order")];
			array.sort = sort;
	       	array.refresh();
	       	var backWindow:NativeWindow = null;
			for each(viewer in array)
			{
				if (viewer.inUse==false)
					continue;
				
				if (backWindow==null)
				{
					viewer.nativeWindow.orderToFront();
				}
				else
				{
					viewer.nativeWindow.orderInFrontOf(backWindow);	
				}
				
				
				viewer.invalidateDisplayList();
				
				backWindow = viewer.nativeWindow;
			}
		}

		public override function removeAllViewers():void
		{
			var viewer:ViewerWindow
			while(m_viewers.length>0)
			{
				viewer = m_viewers.shift();
				viewer.close();
			}
		}
		
		protected override function newViewer():IViewer
		{
			var viewer:ViewerWindow = new ViewerWindow(m_framework);
			viewer.alwaysInFront = true;
			viewer.addEventListener(AIREvent.WINDOW_COMPLETE, onWindowComplete); 
			viewer.open(false);
			m_newViewersCount++;
			return viewer;
		}

		public function newBlankWindow():BlankWindow
		{
			var blankWindow:BlankWindow = new BlankWindow();
			blankWindow.addEventListener(AIREvent.WINDOW_COMPLETE, onWindowComplete); 
			blankWindow.open(false);
			m_newViewersCount++;
			return blankWindow;
		}
		
		private function onWindowComplete(event:AIREvent):void
		{
			var blankWindow:BlankWindow = BlankWindow(event.target);
			blankWindow.removeEventListener(AIREvent.WINDOW_COMPLETE, onWindowComplete);
			m_newViewersCount--;
			orderViewers();
		}
		
	}
}