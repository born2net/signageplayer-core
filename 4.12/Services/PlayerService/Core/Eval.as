package
{
	public class Eval
	{
		protected var globals:Object;
		
		private var out:Boolean = false;
	
		public function th(value:Number, min:Number, max:Number, p:Boolean):Boolean
		{
			if (value>max) 
			{
				out=p;
			} 
			else if (value<min) 
			{ 
				out=!p; 
			} 
			return out;
		}
		
		
	}
		
}