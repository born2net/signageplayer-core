package
{
	import spark.components.TextInput;

	public class TextInputInt extends TextInput
	{
		public function TextInputInt()
		{
			super();
			restrict="0-9";
		}
	}
}