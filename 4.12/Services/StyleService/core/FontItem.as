package
{
	import mx.core.UIComponent;
	
	public class FontItem implements IFontItem
	{
		private var m_styleService:IStyleService;
		
		private var m_fontSize:Number		= 16;			
		private var m_fontColor:uint		= 0x00ff00;			
		private var m_fontFamily:String 	= "Arial";
		private var m_fontWeight:String 	= "normal";			
		private var m_fontStyle:String 		= "normal";
		private var m_textDecoration:String = "none";
		private var m_textAlign:String 		= "left";
		
		public function FontItem(i_styleService:IStyleService)
		{
			m_styleService = i_styleService;
		}
		
		public function get fontFamilyList():Array
		{
			if (m_styleService==null)
				return null
			return m_styleService.fontFamilyList;
		}
		
		public function set fontSize(i_fontSize:Number):void
		{
			m_fontSize = i_fontSize;
		}

		public function get fontSize():Number
		{		
			return m_fontSize;
		}

		public function set fontColor(i_fontColor:uint):void
		{
			m_fontColor = i_fontColor;
		}

		public function get fontColor():uint
		{		
			return m_fontColor;
		}

		public function get fontFamily():String
		{
			return m_fontFamily;
		}	
		
		public function set fontFamily(i_fontFamily:String):void
		{
			m_fontFamily = i_fontFamily;
			m_styleService.loadFont(m_fontFamily);
		}	

		public function set fontWeight(i_fontWeight:String):void
		{
			m_fontWeight = i_fontWeight;
		}

		public function get fontWeight():String
		{		
			return m_fontWeight;
		}

		public function set fontStyle(i_fontStyle:String):void
		{
			m_fontStyle = i_fontStyle;
		}

		public function get fontStyle():String
		{		
			return m_fontStyle;
		}

		public function set textDecoration(i_textDecoration:String):void
		{
			m_textDecoration = i_textDecoration;
		}

		public function get textDecoration():String
		{		
			return m_textDecoration;
		}

		public function set textAlign(i_textAlign:String):void
		{
			m_textAlign = i_textAlign;
		}
		
		public function get textAlign():String
		{		
			return m_textAlign;
		}
		
		
		public function load(i_xmlFont:XML):void
		{
			m_fontSize = i_xmlFont.@fontSize;
			m_fontColor = i_xmlFont.@fontColor;
			m_fontFamily = i_xmlFont.@fontFamily;
			m_fontWeight = i_xmlFont.@fontWeight;
			m_fontStyle = i_xmlFont.@fontStyle;
			m_textDecoration = i_xmlFont.@textDecoration;
			m_textAlign = i_xmlFont.@textAlign;
			
			m_styleService.loadFont(m_fontFamily);
		}
		
		public function save():XML
		{
			var xmlFont:XML = <Font/>;
			xmlFont.@fontSize = m_fontSize;
			xmlFont.@fontColor = m_fontColor;
			xmlFont.@fontFamily = m_fontFamily;
			xmlFont.@fontWeight = m_fontWeight;
			xmlFont.@fontStyle = m_fontStyle;
			xmlFont.@textDecoration = m_textDecoration;
			if (m_textAlign!=null && m_textAlign!="")
			{
				xmlFont.@textAlign = m_textAlign;
			}
			
			return xmlFont;
		}
		/*
		public function getTextField(i_text:String):String
		{				
			var xmlFont:XML = <FONT FACE={m_fontFamily} SIZE={m_fontSize} COLOR={m_fontColor} />;
			var xmlP:XML = <P>i_text</P>;
			xmlFont.appendChild(xmlP);
			return xmlFont.toString();
		}
		*/
		
		public function applyStyles(i_component:UIComponent):void
		{
			i_component.setStyle("color", m_fontColor);
			i_component.setStyle("fontFamily", m_fontFamily);
			i_component.setStyle("fontSize", m_fontSize);
			i_component.setStyle("fontWeight", m_fontWeight);
			i_component.setStyle("fontStyle", m_fontStyle);
			i_component.setStyle("textDecoration", m_textDecoration);
			if (m_textAlign!=null && m_textAlign!="")
			{
				i_component.setStyle("textAlign", m_textAlign);
			}
		}
	}
}