package
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class PasswordValidator extends Validator
	{
		private var m_source2:Object;
		private var m_property2:String;
		
		public function PasswordValidator()
		{
			super();
		}

		public function set source2(i_source2:Object):void
		{
			m_source2 = i_source2;
		}

		public function set property2(i_property2:String):void
		{
			m_property2 = i_property2;
		}
		
		override protected function doValidation(value:Object):Array
	    {
			var results:Array = super.doValidation(value);
			if (source.text!=m_source2[m_property2])
			{
				results.push(new ValidationResult(
								true, "Password Fail", "tooShort",
								"Password Confirmation not match"));				
			}
			if (String(source.text).length<3)
			{
				results.push(new ValidationResult(
								true, "Password Fail", "tooShort",
								"Password should have at least 3 characters"));				
			}
			return results;
	    }
	}
}