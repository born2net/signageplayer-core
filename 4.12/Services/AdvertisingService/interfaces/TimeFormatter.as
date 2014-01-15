package
{
	import mx.formatters.Formatter;
	
	public class TimeFormatter extends Formatter
	{
		public function TimeFormatter()
		{
			super();
		}
		
		public override function format(value:Object):String
		{
			var result:String = "";
			var t:int = int(value);
			var sec:int = t % 60;
			result = sec + result;  
			if (sec<10)
				result = "0" + result;
			
			t /= 60;
			var min:int = t % 60;
			result = min + ":" + result;  
			if (min<10)
				result = "0" + result;
			
			
			t /= 60;
			var hours:int = t % 24;
			result = hours + ":" + result;  
			
			t /=24;
			var days:int = t;
			
			if (days>0)
				result = days + "days " + result;

			return result;
		}
	}
}
