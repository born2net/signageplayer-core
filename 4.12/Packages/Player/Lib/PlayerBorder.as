package
{
	import flash.events.EventDispatcher;
	
	public class PlayerBorder extends PlayerEffect
	{
		public function PlayerBorder(i_playerLoader:PlayerLoader)
		{
			super(i_playerLoader);
		}
		
		public override function clear():void
		{
			super.clear();
			setStyle("borderVisible", false);
		}
				
		protected override function parseXML(i_xmlProperties:XML):Object
		{
			var data:Object = new Object();
			if (XMLList(i_xmlProperties.@borderThickness).length()>0)	
				data.borderWeight = Number(i_xmlProperties.@borderThickness);
			if (XMLList(i_xmlProperties.@borderColor).length()>0)	
				data.borderColor = String(i_xmlProperties.@borderColor);
			if (XMLList(i_xmlProperties.@cornerRadius).length()>0)	
				data.cornerRadius = Number(i_xmlProperties.@cornerRadius);
			return data;
		}
		
		protected override function buildXML(i_prop:Object):XML
		{
			var xmlBorder:XML = <Border/>
			if (i_prop.hasOwnProperty("borderWeight"))
				xmlBorder.@borderThickness = i_prop.borderWeight;
			if (i_prop.hasOwnProperty("borderColor"))
				xmlBorder.@borderColor = i_prop.borderColor;
			if (i_prop.hasOwnProperty("cornerRadius"))
				xmlBorder.@cornerRadius = i_prop.cornerRadius;
			return xmlBorder;
		}
		
		protected override function applyData(i_properties:Object):void
		{
			setStyle("borderVisible", true);
			setStyle("borderStyle", "solid");
			setStyle("borderWeight", i_properties.borderWeight);
			setStyle("borderColor", i_properties.borderColor);
			setStyle("cornerRadius", i_properties.cornerRadius);
		}

		protected override function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
			if (i_prop1.borderWeight!=null && i_prop2.borderWeight!=null)
				i_prop.borderWeight = m_playerAcction.getNumber(i_k, i_prop1.borderWeight, i_prop2.borderWeight);
			if (i_prop1.borderColor!=null && i_prop2.borderColor!=null)	
				i_prop.borderColor = m_playerAcction.getColor(i_k, Number(i_prop1.borderColor), Number(i_prop2.borderColor));
			if (i_prop1.cornerRadius!=null && i_prop2.cornerRadius!=null)	
				i_prop.cornerRadius = m_playerAcction.getNumber(i_k, i_prop1.cornerRadius, i_prop2.cornerRadius);
		}
	}
}