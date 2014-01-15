package
{
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	
	public class PlayerShadow extends PlayerEffect
	{
		private var m_shadowFilter:DropShadowFilter;
		
		public function PlayerShadow(i_playerLoader:PlayerLoader)
		{
			super(i_playerLoader);
			m_shadowFilter = new DropShadowFilter();
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
			data.angle = Number(i_xmlProperties.@angle);
			data.distance = Number(i_xmlProperties.@distance);
			data.alpha = Number(i_xmlProperties.@alpha);
			data.color = Number(i_xmlProperties.@color);
			return data;
		}
		
		protected override function buildXML(i_prop:Object):XML
		{
			var xmlShadow:XML = <Shadow/>
			xmlShadow.@blurX = i_prop.blurX;
			xmlShadow.@blurY = i_prop.blurY;
			xmlShadow.@strength = i_prop.strength;
			xmlShadow.@angle = i_prop.angle;
			xmlShadow.@distance = i_prop.distance;
			xmlShadow.@alpha = i_prop.alpha;
			xmlShadow.@color = i_prop.color;
			return xmlShadow;
		}
		
		protected override function applyData(i_properties:Object):void
		{
			m_shadowFilter.blurX = i_properties.blurX;
			m_shadowFilter.blurY = i_properties.blurY;
			m_shadowFilter.strength = i_properties.strength;
			m_shadowFilter.angle = i_properties.angle;
			m_shadowFilter.distance = i_properties.distance;
			m_shadowFilter.alpha = i_properties.alpha;
			m_shadowFilter.color = i_properties.color;
			//var child:DisplayObject = m_playerModule.getChildAt(0);
			//child.filters = [m_shadowFilter];
			m_playerLoader.addFilter(m_shadowFilter);
		}

		protected override function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
			i_prop.blurX = m_playerAcction.getNumber(i_k, i_prop1.blurX, i_prop2.blurX);
			i_prop.blurY = m_playerAcction.getNumber(i_k, i_prop1.blurY, i_prop2.blurY);
			i_prop.strength = m_playerAcction.getNumber(i_k, i_prop1.strength, i_prop2.strength);
			i_prop.angle = m_playerAcction.getNumber(i_k, i_prop1.angle, i_prop2.angle);
			i_prop.distance = m_playerAcction.getNumber(i_k, i_prop1.distance, i_prop2.distance);
			i_prop.alpha = m_playerAcction.getNumber(i_k, i_prop1.alpha, i_prop2.alpha);
			i_prop.color = m_playerAcction.getColor(i_k, i_prop1.color, i_prop2.color);
		}
	}
}