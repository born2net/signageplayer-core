package Controls
{

import mx.collections.ArrayList;

/**
 *  Given a month and year, generates 35 items that
 *  correspond to how the month would appear in 
 *  a calendar if index 0 is the first Sunday
 *  in a week view
 */
public class CalendarIList extends ArrayList
{
// a full implementation would disable most of the IList modification
// methods like addItem, removeItem
	
	// number of milliseconds in a day
	public static const dayOfMS:Number = 1000 * 60 * 60 * 24;
	
	/**
	 *  Set the month and year.
	 *  @param month 0-based index of month (0 = January)
	 *  @param year The year to display (2009)
	 */
	public function setMonthAndYear(month:int, year:int):void
	{
		_month = month;
		_year = year;
		
		// choose noon on the first to try to avoid DST issues
		var d:Date = new Date(year, month, 1, 12);
		// get day of week (0 = Sunday)
		var dofw:Number = d.day;
	
		// back up to Sunday
		var value:Number = d.time;
		while (dofw > 0)
		{
			value -= dayOfMS;
			dofw--;
		}
		
		var arr:Array = [];
		
		for (var i:int = 0; i < 42; i++)
		{
			var dt:Date = new Date(value);
			var data:CalendarIListDay = new CalendarIListDay();
			data.date = dt;
			data.currentMonth = dt.month == month;
			arr.push(data);
			value += dayOfMS;
		}
		source = arr;
	}
	
	private var _month:int;
	
	[Bindable("collectionChange")]
	public function get month():int
	{
		return _month;
	}
	
	private var _year:int;
	
	[Bindable("collectionChange")]
	public function get year():int
	{
		return _year;
	}

}

}
