package
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.events.ResizeEvent;
	
	public class PlayerBackground extends PlayerEffect
	{
		private var m_gradientBackground:Object;
		
		public function PlayerBackground(i_playerLoader:PlayerLoader)
		{
			super(i_playerLoader);
		}
		
		public override function clear():void
		{
			super.clear();
			if (m_playerLoader!=null)
			{
				m_playerLoader.graphics.clear();
				setStyle("backgroundColor", "none");
				m_playerLoader.removeEventListener(ResizeEvent.RESIZE, onResize);
				m_playerLoader = null;
			}
		}
		
		public override function load(i_xmlData:XML):void
		{
			super.load(i_xmlData);
			m_playerLoader.addEventListener(ResizeEvent.RESIZE, onResize);
		}
		
		protected override function parseXML(i_xmlProperties:XML):Object
		{
			var data:Object = new Object();
			if (XMLList(i_xmlProperties.@style).length()>0)
			{
				if (i_xmlProperties.@style==BackgroundStyles.SIMPLE)
				{
					data.simpleBackground = new Object();
					data.simpleBackground.color = Number(i_xmlProperties.@color);
					data.simpleBackground.alpha = Number(i_xmlProperties.@alpha);
				}
				else if (i_xmlProperties.@style==BackgroundStyles.GRADIENT)
				{
					data.gradientBackground = new Object();	
					data.gradientBackground.gradientType = String(i_xmlProperties.@gradientType);
					data.gradientBackground.angle = Number(i_xmlProperties.@angle);
					data.gradientBackground.offsetX = Number(i_xmlProperties.@offsetX);
					data.gradientBackground.offsetY = Number(i_xmlProperties.@offsetY);
					data.gradientBackground.colorArray = new Array();
					data.gradientBackground.opacityArray = new Array();
					data.gradientBackground.midpointArray = new Array();
					for each(var xmlPoint:XML in i_xmlProperties.GradientPoints.*)
					{
						data.gradientBackground.colorArray.push(uint(xmlPoint.@color));
						data.gradientBackground.opacityArray.push(Number(xmlPoint.@opacity));
						data.gradientBackground.midpointArray.push(Number(xmlPoint.@midpoint));
					}
				}
			}

			return data;
		}
		
		protected override function buildXML(i_prop:Object):XML
		{
			var xmlBackground:XML = <Background/>;
			if (i_prop.hasOwnProperty("simpleBackground") && i_prop.simpleBackground!=null)
			{
				xmlBackground.@style = BackgroundStyles.SIMPLE;
				xmlBackground.@color = i_prop.simpleBackground.color;
				xmlBackground.@alpha = i_prop.simpleBackground.alpha;
			}
			else if (i_prop.hasOwnProperty("gradientBackground") && i_prop.gradientBackground!=null)
			{
				xmlBackground.@style = BackgroundStyles.GRADIENT;
				xmlBackground.@gradientType = i_prop.gradientBackground.gradientType;
				xmlBackground.@angle = i_prop.gradientBackground.angle;
				xmlBackground.@offsetX = i_prop.gradientBackground.offsetX;
				xmlBackground.@offsetY = i_prop.gradientBackground.offsetY;
				var xmlGradientPoints:XML = <GradientPoints/>;
				xmlBackground.appendChild(xmlGradientPoints);
				var count:int = i_prop.gradientBackground.colorArray.length;
				for(var i:int = 0; i<count; i++)
				{
					var xmlPoint:XML = <Point/>
					xmlPoint.@color = i_prop.gradientBackground.colorArray[i];
					xmlPoint.@opacity = i_prop.gradientBackground.opacityArray[i];
					xmlPoint.@midpoint = i_prop.gradientBackground.midpointArray[i];
					xmlGradientPoints.appendChild(xmlPoint);
				}
				
			}
			return xmlBackground;
		}
		
		protected override function applyData(i_properties:Object):void
		{
			var simpleBackground:Object = i_properties.simpleBackground;
			var gradientBackground:Object = i_properties.gradientBackground;
			if (simpleBackground!=null)
			{
        		m_playerLoader.graphics.clear();
				setStyle("backgroundColor", uint(i_properties.simpleBackground.color));
				setStyle("backgroundAlpha", i_properties.simpleBackground.alpha);				
			}
			else if (gradientBackground!=null)
			{
				setStyle("backgroundColor", "none");
				m_gradientBackground = i_properties.gradientBackground;
				updateGradient();
			}
		}

		protected override function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
		}
		
		private function onResize(event:ResizeEvent):void
		{
			if (m_gradientBackground==null)
				return;
			updateGradient();
		}		


        private function updateGradient():void 
        { 
            var m:Matrix = new Matrix();
            var angleInRadians:Number = (m_gradientBackground.angle/180) * Math.PI;
            var i:uint = 0;
            var opacArr:Array;
            var mpArr:Array;
            // establish default arrays
            if (!m_gradientBackground.colorArray.length) 
            {
                m_gradientBackground.colorArray = [0xFFFFFF, 0xFFFFFF];
            }
            if (!m_gradientBackground.opacityArray.length || m_gradientBackground.opacityArray.length != m_gradientBackground.colorArray.length) 
            {
                opacArr = new Array(m_gradientBackground.colorArray.length);
                for (i=0; i<m_gradientBackground.colorArray.length; i++) 
                {
                    opacArr[i] = 1;
                }
            } 
            else 
            {
                opacArr = m_gradientBackground.opacityArray;
            }
            if (!m_gradientBackground.midpointArray.length || m_gradientBackground.midpointArray.length != m_gradientBackground.colorArray.length) 
            {
                mpArr = new Array(m_gradientBackground.colorArray.length);
                var evenWidth:Number = 255 / (m_gradientBackground.colorArray.length-1);
                mpArr[0] = 0;
                mpArr[m_gradientBackground.colorArray.length-1] = 255;
                // loop from the second element to the second-to-last element to find the tween points
                for (i=1; i<m_gradientBackground.colorArray.length-1; i++) 
                {
                    mpArr[i] = int(i * evenWidth);
                }
            } 
            else 
            {
                mpArr = m_gradientBackground.midpointArray;
            }
            // create the gradient
            m.createGradientBox(m_playerLoader.width, m_playerLoader.height, angleInRadians, m_gradientBackground.offsetX, m_gradientBackground.offsetY);
            m_playerLoader.graphics.clear(); 
			m_gradientBackground.gradientType = m_gradientBackground.gradientType == "NaN" || m_gradientBackground.gradientType == "" ? GradientType.LINEAR : m_gradientBackground.gradientType;
            m_playerLoader.graphics.beginGradientFill(m_gradientBackground.gradientType, m_gradientBackground.colorArray, opacArr ,mpArr, m);
            // this.graphics.drawRect(0,0,this.unscaledWidth,this.unscaledHeight);
            var cornerRadius:Number = m_playerLoader.getStyle("cornerRadius") * 2;
            if ( isNaN(cornerRadius) ) 
            	cornerRadius = 0;
            m_playerLoader.graphics.drawRoundRect(0,0,m_playerLoader.width, m_playerLoader.height,cornerRadius,cornerRadius);            
            m_playerLoader.graphics.endFill();
        }
	}
}