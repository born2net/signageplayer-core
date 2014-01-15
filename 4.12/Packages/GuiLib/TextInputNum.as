package
{
	import spark.components.TextInput;

	public class TextInputNum extends TextInput
	{
		public function TextInputNum()
		{
			super();
			restrict="0-9.";
		}
	}
}