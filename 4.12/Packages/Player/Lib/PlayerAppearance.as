package
{
	import flash.events.EventDispatcher;
	import flash.display.BlendMode;
	
	public class PlayerAppearance extends PlayerEffect
	{
		public function PlayerAppearance(i_playerLoader:PlayerLoader)
		{
			super(i_playerLoader);
		}
		
		public override function clear():void
		{
			super.clear();
			m_playerLoader.alpha = 1;
			m_playerLoader.blendMode = BlendMode.NORMAL;
		}
		
		protected override function parseXML(i_xmlProperties:XML):Object
		{
			var data:Object = new Object();
			if (XMLList(i_xmlProperties.@alpha).length()>0)	
				data.alpha = Number(i_xmlProperties.@alpha);
			
			if (XMLList(i_xmlProperties.@blendMode).length()>0)	
				data.blendMode = String(i_xmlProperties.@blendMode);
			else
				data.blendMode = BlendMode.NORMAL;
			return data;
		}
		
		protected override function buildXML(i_prop:Object):XML
		{
			var xmlAppearance:XML = <Appearance/>
			if (i_prop.hasOwnProperty("alpha"))
				xmlAppearance.@alpha = i_prop.alpha;
			if (i_prop.hasOwnProperty("blendMode"))
				xmlAppearance.@blendMode = i_prop.blendMode;
			return xmlAppearance;
		}
		
		protected override function applyData(i_properties:Object):void
		{
			m_playerLoader.alpha = i_properties.alpha;
			if (i_properties.hasOwnProperty("blendMode"))
			{
				m_playerLoader.blendMode = i_properties.blendMode;
			}
		}

		protected override function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
			if (i_prop1.alpha!=null && i_prop2.alpha!=null)
				i_prop.alpha = m_playerAcction.getNumber(i_k, i_prop1.alpha, i_prop2.alpha);
		}
	}
}