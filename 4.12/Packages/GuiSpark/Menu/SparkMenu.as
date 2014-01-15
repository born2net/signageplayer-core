package Menu
{
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import spark.components.List;
    import spark.events.IndexChangeEvent;
    
    [Event(name="change", type="Menu.SparkMenuEvent")]
    [Event(name="menuRight", type="flash.events.Event")]
    
    public class SparkMenu extends List
    {
        override protected function keyDownHandler(event:KeyboardEvent):void
        {
            // handle navigation here so we don't end up firing change events
            if (event.keyCode == Keyboard.UP)
            {
                if (selectedIndex > 0)
                {
                    do 
                    {
                        selectedIndex--;
                    } while (dataProvider.getItemAt(selectedIndex).@separator.toString() == "true");                    
                }
            }
            else if (event.keyCode == Keyboard.DOWN)
            {
                if (selectedIndex < dataProvider.length - 1)
                {
                    do 
                    {
                        selectedIndex++;
                    } while (dataProvider.getItemAt(selectedIndex).@separator.toString() == "true");                    
                }
            }
            else if (event.keyCode == Keyboard.ENTER || event.charCode == Keyboard.SPACE)
            {
                dispatchEvent(new SparkMenuEvent(IndexChangeEvent.CHANGE, false, false,
                    selectedIndex, selectedIndex, this, selectedItem));
            }
            else
                super.keyDownHandler(event);
        }
        
        override public function dispatchEvent(event:Event):Boolean
        {
            if (event.type == IndexChangeEvent.CHANGE && event is IndexChangeEvent && !(event is SparkMenuEvent))
            {
                // don't dismiss if clicked on separator
                if (selectedItem.@separator.toString() == "true")
                {
                    selectedIndex = -1;
                    return true;
                }
                // don't dismiss if clicked on entry with submenu
                if (selectedItem.children().length() > 0)
                {
                    selectedIndex = -1;
                    return true;
                }
                event = SparkMenuEvent.convert(IndexChangeEvent(event), this, selectedItem);            
            }
			
            return super.dispatchEvent(event);
        }
    }
}
