package Menu
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import spark.events.IndexChangeEvent;
    
    public class SparkMenuEvent extends IndexChangeEvent
    {
        public function SparkMenuEvent(type:String, 
                                       bubbles:Boolean=false, 
                                       cancelable:Boolean = false, 
                                       oldIndex:Number = -1,
                                       newIndex:Number = -1,
                                       menu:SparkMenu = null, 
                                       item:Object = null)
        {
            super(type, bubbles, cancelable, oldIndex, newIndex);
            this.menu = menu;
            this.item = item;
        }
        
        public var menu:SparkMenu;
        public var item:Object;
        
        override public function clone():Event
        {
            return new SparkMenuEvent(type, bubbles, cancelable, 
                oldIndex, newIndex, menu, item);
        }
        
        public static function convert(event:IndexChangeEvent, menu:SparkMenu, item:Object):Event
        {
            return new SparkMenuEvent(event.type, event.bubbles, event.cancelable, 
                event.oldIndex, event.newIndex, menu, item);
        }
    }
}
