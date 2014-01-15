package Controls
{
import flash.events.EventDispatcher;
import mx.core.IUID;

/**
 *  Data object used by CalendarIList
 */
public class CalendarIListDay extends EventDispatcher implements IUID
{
	// the date to display
	[Bindable("__NoChangeEvent__")]
	public var date:Date;
	
	private var _currentMonth:Boolean;
	
	[Bindable("__NoChangeEvent__")]
	// whether that date is in the current month;
	public function get currentMonth():Boolean
	{
		return _currentMonth;
	}
	public function set currentMonth(value:Boolean):void
	{
		_currentMonth = value;
	}
	
	public function get uid():String
	{
		return date.fullYear.toString() + date.month.toString() + date.date.toString();
	}
	
	public function set uid(value:String):void
	{
		// do nothing
	}
	
	[Bindable("__NoChangeEvent__")]
	public function get dateLabel():String
	{
		return date.date.toString();
	}
}

}
