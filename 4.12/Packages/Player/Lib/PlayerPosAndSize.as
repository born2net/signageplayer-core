package
{
	import flash.geom.Point;
	
	import mx.core.IVisualElementContainer;
	
	import spark.components.SkinnableContainer;
	import spark.layouts.BasicLayout;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.TileLayout;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;

	public class PlayerPosAndSize extends PlayerEffect
	{
		public function PlayerPosAndSize(i_playerLoader:PlayerLoader)
		{
			super(i_playerLoader);
		}
		
		public override function clear():void
		{
			super.clear();
			m_playerLoader.component.rotation = 0;	
			m_playerLoader.component.width = NaN;
			m_playerLoader.component.height =  NaN;
			m_playerLoader.component.percentHeight =  100;
			m_playerLoader.component.percentWidth = 100;
		}
		
		protected override function parseXML(i_xmlProperties:XML):Object
		{
			var data:Object = new Object();
			
			if (XMLList(i_xmlProperties.@rotation).length()>0)
				data.rotation = Number(i_xmlProperties.@rotation);
			else
				data.rotation = 0;
			if (XMLList(i_xmlProperties.@x).length()>0)
				data.x = Number(i_xmlProperties.@x);
			if (XMLList(i_xmlProperties.@y).length()>0) 	
				data.y = Number(i_xmlProperties.@y);
			if (XMLList(i_xmlProperties.@width).length()>0)
				data.width = Number(i_xmlProperties.@width);
			if (XMLList(i_xmlProperties.@height).length()>0)	
				data.height = Number(i_xmlProperties.@height);

			if (XMLList(i_xmlProperties.@top).length()>0)
				data.top = Number(i_xmlProperties.@top);
			if (XMLList(i_xmlProperties.@bottom).length()>0)
				data.bottom = Number(i_xmlProperties.@bottom);
			if (XMLList(i_xmlProperties.@right).length()>0)
				data.right = Number(i_xmlProperties.@right);
			if (XMLList(i_xmlProperties.@left).length()>0)
				data.left = Number(i_xmlProperties.@left);				

 
			if (XMLList(i_xmlProperties.@horizontalCenter).length()>0)
				data.horizontalCenter = Number(i_xmlProperties.@horizontalCenter);				
			if (XMLList(i_xmlProperties.@verticalCenter).length()>0)
				data.verticalCenter = Number(i_xmlProperties.@verticalCenter);				
			return data;
		}
		
		protected override function buildXML(i_prop:Object):XML
		{
			var xmlLayout:XML = <Layout/>;
			
			
			xmlLayout.@rotation = i_prop.rotation;
			
			var x1:Object = i_prop.left;
			var x2:Object = i_prop.horizontalCenter;
			var x3:Object = i_prop.right;
			var y1:Object = i_prop.top;
			var y2:Object = i_prop.verticalCenter;
			var y3:Object = i_prop.bottom;
			if (x1!=null)
				xmlLayout.@left = x1;
			if (x2!=null)
				xmlLayout.@horizontalCenter = x2;
			if (x3!=null)
				xmlLayout.@right = x3;
			if (y1!=null)
				xmlLayout.@top = y1;
			if (y2!=null)
				xmlLayout.@verticalCenter = y2;
			if (y3!=null)
				xmlLayout.@bottom = y3;
				
			if (x1==null && x2==null && x3==null)
				 xmlLayout.@x = i_prop.x;
			if (y1==null && y2==null && y3==null)
				 xmlLayout.@y = i_prop.y;

			if (x1==null || x3==null)
				 xmlLayout.@width = i_prop.width;
			if (y1==null || y3==null)
				 xmlLayout.@height = i_prop.height;

						
			return xmlLayout;
			
		}
		
		protected override function applyData(i_properties:Object):void
		{
			m_playerLoader.component.rotation = i_properties.rotation;
			if (i_properties.hasOwnProperty("width"))
			{
				m_playerLoader.component.width = i_properties.width;
			}
			if (i_properties.hasOwnProperty("height"))
			{
				m_playerLoader.component.height = i_properties.height;
			}
			if (i_properties.hasOwnProperty("x") && i_properties.hasOwnProperty("y"))
			{
				var point:Point = getLocation(i_properties.x, i_properties.y, i_properties.width, i_properties.height, i_properties.rotation);
				m_playerLoader.component.x = point.x;
				m_playerLoader.component.y = point.y;
			}
			else
			{
				if (i_properties.hasOwnProperty("x"))
				{
					m_playerLoader.component.x = i_properties.x;
				}
				if (i_properties.hasOwnProperty("y"))
				{
					m_playerLoader.component.y = i_properties.y;
				}
			}
			
			if (i_properties.hasOwnProperty("left"))
				m_playerLoader.component.setStyle("left", i_properties.left);
			if (i_properties.hasOwnProperty("horizontalCenter"))
				m_playerLoader.component.setStyle("horizontalCenter", i_properties.horizontalCenter);
			if (i_properties.hasOwnProperty("right"))	
				m_playerLoader.component.setStyle("right", i_properties.right);
			if (i_properties.hasOwnProperty("top"))
				m_playerLoader.component.setStyle("top", i_properties.top);
			if (i_properties.hasOwnProperty("verticalCenter"))	
				m_playerLoader.component.setStyle("verticalCenter", i_properties.verticalCenter);
			if (i_properties.hasOwnProperty("bottom"))
				m_playerLoader.component.setStyle("bottom", i_properties.bottom);
		}

		protected override function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
			i_prop.rotation = m_playerAcction.getNumber(i_k, i_prop1.rotation, i_prop2.rotation);
			i_prop.x = m_playerAcction.getNumber(i_k, i_prop1.x, i_prop2.x);
			i_prop.y = m_playerAcction.getNumber(i_k, i_prop1.y, i_prop2.y); 
			i_prop.width = m_playerAcction.getNumber(i_k, i_prop1.width, i_prop2.width);
			i_prop.height = m_playerAcction.getNumber(i_k, i_prop1.height, i_prop2.height);
		}
		
		private function getLocation(i_x:Number, i_y:Number, i_width:Number, i_height:Number, i_rotation:Number):Point
		{
			if (i_rotation!=0)
			{
				var rx:Number = i_width/2;
				var ry:Number = i_height/2;
				var r:Number = Math.sqrt(rx*rx+ry*ry);
				var b:Number = Math.asin(rx/r);
				var a:Number = ((i_rotation-90)/180) * Math.PI - b;
				var cx:Number = i_x + rx;
				var cy:Number = i_y + ry;
				return new Point(cx + Math.cos(a) * r, cy + Math.sin(a) * r);
			}
			else
			{
				return new Point(i_x, i_y);
			}
		}
	}
}