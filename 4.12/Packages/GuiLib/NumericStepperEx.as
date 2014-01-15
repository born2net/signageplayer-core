package
{
	import spark.components.NumericStepper;
	
	public class NumericStepperEx extends NumericStepper
	{
		public function NumericStepperEx()
		{
			super();
		}
		
		
		protected override function setValue(value:Number):void
		{
			if (isNaN(value))
			{
				var oldValue:Number = super.value;
				super.value = NaN;
				super.value = oldValue;
			}
			else
			{
				super.setValue(value);
			}
		}		
	}
}