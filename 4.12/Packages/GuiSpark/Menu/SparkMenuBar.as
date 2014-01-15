package Menu
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.core.ClassFactory;
    import mx.core.IVisualElement;
    import mx.core.ScrollPolicy;
    import mx.events.FlexEvent;
    
    import spark.components.IItemRenderer;
    import spark.components.List;
    import spark.events.IndexChangeEvent;
    import spark.layouts.HorizontalLayout;
        
    [Event(name="change", type="Menu.SparkMenuEvent")]
    
    public class SparkMenuBar extends List
    {
		private var m_callbackObj:Object;
		
		public function SparkMenuBar()
		{
			layout = new HorizontalLayout();
			itemRenderer = new ClassFactory( Menu.SparkMenuBarItemRenderer );
			labelField = "@label";
			setStyle("horizontalScrollPolicy", "off"); 
		}
		
		public function set callbackObj(i_callbackObj:Object):void
		{
			m_callbackObj = i_callbackObj;
			addEventListener(IndexChangeEvent.CHANGE, onChange);
		}
		
		public function get callBack():Object
		{
			return m_callbackObj;
		}		
		
		private function onChange(event:Menu.SparkMenuEvent):void
		{
			if (event.item.@type=="check")
			{
				event.item.@toggled = ((event.item.@toggled=="true")==false);
			}
			
			var funcName:String = String(event.item.@click);
			if (funcName=="")
				return;
			var click:Function = m_callbackObj[funcName];
			if (click!=null)
			{
				click();
			}		
			
			
			callLater(onDeselect);
		}
		
		private function onDeselect():void
		{
			selectedItem = null;
		}
		
        override public function dispatchEvent(event:Event):Boolean
        {
            if (event.type == IndexChangeEvent.CHANGE && event is IndexChangeEvent && !(event is SparkMenuEvent))
            {
                var ice:IndexChangeEvent = event as IndexChangeEvent;
                
				if (ice.newIndex==-1)
					return false;
				
                // check for a menubar entry without a menu
                if (dataProvider.getItemAt(ice.newIndex).children().length() == 0)
                {
                    event = SparkMenuEvent.convert(ice, null, dataProvider.getItemAt(ice.newIndex));
                    super.dispatchEvent(event);
                }
                // don't dispatch change events directly from the MenuBar, only forward SparkMenuEvents from the
                // menus.
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));                
                return true;          
            }
            return super.dispatchEvent(event);
        }
        
        override protected function item_mouseDownHandler(event:MouseEvent):void
        {
            // someone else handled it already since this is cancellable thanks to 
            // some extra code in SystemManager that redispatches a cancellable version 
            // of the same event
            if (event.isDefaultPrevented())
                return;
            
            // Handle the fixup of selection
            var newIndex:int
            if (event.currentTarget is IItemRenderer)
                newIndex = IItemRenderer(event.currentTarget).itemIndex;
            else
                newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);

            // if selectedIndex is not newIndex, base class will dispatch an event.
            // if they match, we have to force the dispatch
            if (newIndex == selectedIndex)
            {
                // but only if it is a menubar item without a menu
                if (dataProvider.getItemAt(newIndex).children().length() == 0)
                {
                    var sme:SparkMenuEvent = new SparkMenuEvent(IndexChangeEvent.CHANGE,
                        false, false, newIndex, newIndex, null, dataProvider.getItemAt(newIndex));
                    dispatchEvent(sme);                    
                }
            }
            
            super.item_mouseDownHandler(event);
        }
    }
    
}
