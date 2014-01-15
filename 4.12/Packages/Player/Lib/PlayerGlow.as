package
{
	import flash.filters.GlowFilter;
	
	//M??? import mx.effects.Glow;
	
	public class PlayerGlow extends PlayerEffect
	{
		private var m_glowFilter:GlowFilter;
		
		public function PlayerGlow(i_playerLoader:PlayerLoader)
		{
			super(i_playerLoader);
			m_glowFilter = new GlowFilter();
		}
		
		protected override function isFilter():Boolean
		{
			return true;
		}
		
		protected override function parseXML(i_xmlProperties:XML):Object
		{
			var data:Object = new Object();
			data.blurX = Number(i_xmlProperties.@blurX);
			data.blurY = Number(i_xmlProperties.@blurY);
			data.strength = Number(i_xmlProperties.@strength);
			data.alpha = Number(i_xmlProperties.@alpha);
			data.color = Number(i_xmlProperties.@color);
			return data;
		}
		
		protected override function buildXML(i_prop:Object):XML
		{
			var xmlGlow:XML = <Glow/>
			xmlGlow.@blurX = i_prop.blurX;
			xmlGlow.@blurY = i_prop.blurY;
			xmlGlow.@strength = i_prop.strength;
			xmlGlow.@alpha = i_prop.alpha;
			xmlGlow.@color = i_prop.color;
			return xmlGlow;
		}
		
		protected override function applyData(i_properties:Object):void
		{
			m_glowFilter.blurX = i_properties.blurX;
			m_glowFilter.blurY = i_properties.blurY;
			m_glowFilter.strength = i_properties.strength;
			m_glowFilter.alpha = i_properties.alpha;
			m_glowFilter.color = i_properties.color;
			m_playerLoader.addFilter(m_glowFilter);
		}

		protected override function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
			i_prop.blurX = m_playerAcction.getNumber(i_k, i_prop1.blurX, i_prop2.blurX);
			i_prop.blurY = m_playerAcction.getNumber(i_k, i_prop1.blurY, i_prop2.blurY);
			i_prop.strength = m_playerAcction.getNumber(i_k, i_prop1.strength, i_prop2.strength);
			i_prop.alpha = m_playerAcction.getNumber(i_k, i_prop1.alpha, i_prop2.alpha);
			i_prop.color = m_playerAcction.getColor(i_k, i_prop1.color, i_prop2.color);
		}
	}
}