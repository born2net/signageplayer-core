package
{
	import flash.filters.BlurFilter;
	
	import mx.effects.Blur;
	
	public class PlayerBlur extends PlayerEffect
	{
		private var m_blurFilter:BlurFilter;
		
		public function PlayerBlur(i_playerLoader:PlayerLoader)
		{
			super(i_playerLoader);
			m_blurFilter = new BlurFilter();
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
			return data;
		}
		
		protected override function buildXML(i_prop:Object):XML
		{
			var xmlBlur:XML = <Blur/>
			xmlBlur.@blurX = i_prop.blurX;
			xmlBlur.@blurY = i_prop.blurY;
			return xmlBlur;
		}
		
		protected override function applyData(i_properties:Object):void
		{
			m_blurFilter.blurX = i_properties.blurX;
			m_blurFilter.blurY = i_properties.blurY;
			m_playerLoader.addFilter(m_blurFilter);
		}

		protected override function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
			i_prop.blurX = m_playerAcction.getNumber(i_k, i_prop1.blurX, i_prop2.blurX);
			i_prop.blurY = m_playerAcction.getNumber(i_k, i_prop1.blurY, i_prop2.blurY);
		}
	}
}