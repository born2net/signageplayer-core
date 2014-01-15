package
{
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	import flashx.textLayout.conversion.PlainTextExporter;
	import flashx.textLayout.operations.FlowOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;

	public class TextInputStr extends TextInput
	{
		private var m_showReadOnlyBorder:Boolean = true;
		private var m_regex:RegExp;
		
		public function TextInputStr()
		{
			super();
			m_regex = new RegExp("[A-Za-z0-9 _@.\\-`/:?%=]");
			addEventListener(TextOperationEvent.CHANGING, onChanging)
		}
		
		public function get showReadOnlyBorder():Boolean
		{
			return m_showReadOnlyBorder;
		}
		
		public function set showReadOnlyBorder(i_showReadOnlyBorder:Boolean):void
		{
			m_showReadOnlyBorder = i_showReadOnlyBorder;
			invalidateProperties();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			setStyle("borderStyle", (editable || m_showReadOnlyBorder) ? "solid" : "none");
		}
		
		
		protected function onChanging(event:TextOperationEvent):void
		{
			
			var str:String = null;
			if (event.operation is InsertTextOperation)
			{
				str = InsertTextOperation(event.operation).text;
				if (m_regex.test(str)==false)
				{
					event.preventDefault();
				}
			}
			else if (event.operation is PasteOperation)
			{
				var textExporter:PlainTextExporter = new PlainTextExporter();
				str = textExporter.export(PasteOperation(event.operation).textScrap.textFlow, flashx.textLayout.conversion.ConversionType.STRING_TYPE) as String;
				for(var i:int=0;i<str.length;i++)
				{
					var char:String = str.charAt(i);
					if (m_regex.test(char)==false)
					{
						event.preventDefault();
					}
					
				}
			}
		}

	}
}
