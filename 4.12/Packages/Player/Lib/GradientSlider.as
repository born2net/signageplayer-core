package
{
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class GradientSlider extends GradientCanvas
	{
		private var m_handle:UIComponent;
		private var m_callBack:Object;				
		private var m_offsetX:Number;
		private var m_offsetY:Number;


		private static const PERECENT_FROM_CENTER:int = 15; 
		
		public static const WIDTH:int = 255;		
		public static const WIDTH_MARGIN:int = 5;
		public static const HEIGHT:int = 20;
		public static const GRADIENT_COLOR_CHANGED:String = "gradientColorChanged";
		
		public static const MOVE_LEFT:int 	= 0;
		public static const MOVE_RIGHT:int 	= 1;
		public static const MOVE_TOP:int 	= 2;
		public static const MOVE_BOTTOM:int = 3;		

		
		public static const GRAYSCALE:int 		= -1;
		public static const TRADITIONAL:int 	= -2;
		public static const RAINBOW:int 		= -3;
		public static const FIRE:int	 		= -4;						
		public static const EARTH:int	 		= -5;
		public static const BORDER:int	 		= -6;
		public static const BEE:int	 			= -7;
		public static const USA:int	 			= -8;
		public static const RED:int	 			= -9;
		public static const GREEN:int 			= -10;
		public static const BLUE:int 			= -11;
		public static const YELLOW:int			= -12;
		public static const WHITE:int			= -13;
		public static const BLACK:int			= -14;
		public static const CLEAR_BG:int 		= -15;		
		public static const TOTAL_PRESETS:uint	= CLEAR_BG*(-1);
								
		public function GradientSlider()
		{
			percentWidth = 100;
			percentHeight =  100;						
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,init);
			//M??? this.addEventListener(ColorPickerCustomEvent.EXTENDED_COLOR_APPLY,onSelectColorCompleted);						
		} 


		private function init(event:FlexEvent):void
		{
			if ( stage == null ) 
				return;
			
			setStyle("backgroundColor","none");
			stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);			
		}		
	
		
		private function onMouseDown(event:MouseEvent):void
		{			
			if ( event.target.parent == this)
			{
				var mousePoint:Point 	= globalToLocal( new Point(event.stageX, event.stageY) );
				
				m_handle = createNewHandle(mousePoint.x, mousePoint.y, 0xFFFFFF);
				
				gradientBuilder(true);	
				
				applyShadowOnHandle(m_handle);		
			}
		}
		
		
		private function applyShadowOnHandle(handle:UIComponent):void
		{
			if ( m_handle == null ) return;
			
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = 2;
			shadow.angle = 25;				
			handle.filters = [shadow];	
		}
		
		
		private function gradientBuilder(updateCallBack:Boolean):void
		{			
			var handles:Array = new Array();
				
			var handle:UIComponent;
			var i:int;
			
			var gradientColors:Array = new Array();
			var gradientOpacity:Array = new Array();			
			var gradientMidpoint:Array = new Array();				
			
			for(i=0; i<numElements; i++)
			{
				handle = UIComponent(getElementAt(i));
				handles.push(handle);				
			}
			
			handles.sort(sortOnX);			
			
			
			for (i=0; i < handles.length ; i++ ) 
			{
				handle = handles[i];
				gradientColors.push(handle.getStyle("borderColor"));
				gradientOpacity.push(handle.y/10);			
				gradientMidpoint.push(handle.x);
			}
				
			m_gradientBackground.colorArray = gradientColors;
			m_gradientBackground.opacityArray =  gradientOpacity;			
			m_gradientBackground.midpointArray = gradientMidpoint;			
			applyGradient();	
			
			if (m_callBack != null && updateCallBack == true ) 
				m_callBack();			
		}
		 
		 
		private function sortOnX(a:UIComponent, b:UIComponent):Number 
		{
		    var aPrice:Number = a.x;
		    var bPrice:Number = b.x;
		
		    if(aPrice > bPrice) {
		        return 1;
		    } else if(aPrice < bPrice) {
		        return -1;
		    } else  {
		        return 0; //aPrice == bPrice		        
		    }
		}
		
	 	
	 	private function createNewHandle(onX:int, onY:int, fillColor:uint):UIComponent
		{	
			clearShadows();
					
			var lineColors:uint		=  fillColor == 0x000000 ? 0xFFFFFF : 0x000000;
			
			m_handle = new UIComponent(  );
			m_handle.x = 1;
			m_handle.y = 1;
			m_handle.width = 8;				
			m_handle.height = 7;
			m_handle.graphics.lineStyle(1, lineColors, 1.0);
			m_handle.graphics.beginFill( fillColor );			
			m_handle.graphics.drawRect(0, 0, 8, 7);
			m_handle.graphics.endFill();			
			m_handle.graphics.moveTo(4,0);
			m_handle.graphics.lineTo(4,-40);
			m_handle.graphics.moveTo(4,8);
			m_handle.graphics.lineTo(4,40);
			m_handle.setStyle("borderColor",fillColor);			
			m_handle.doubleClickEnabled = true;
			m_handle.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			m_handle.addEventListener(MouseEvent.MOUSE_UP, drop);
			m_handle.addEventListener(MouseEvent.DOUBLE_CLICK,selectColor);
			m_handle.x = onX;
			m_handle.y = onY;
			
			addElement(m_handle);					  		
	  		
	  		return m_handle;	  			 
	 	} 				
	 	     				
		
		private function onMouseUp(event:MouseEvent):void
		{
			drop(event);			
		}
		
			
		private	function drag(event:MouseEvent):void
		{						
			clearShadows();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			m_handle = event.target as UIComponent;			
			
			applyShadowOnHandle(m_handle);			
			
			makeTopMost(event.target);		
		}
		
		
		private function clearShadows():void
		{
			for(var i:int=0; i<numElements; i++)
			{
				var handle:UIComponent = UIComponent(getElementAt(i));
				handle.filters = null;				
			}	
		}
		 
		 
		private function drop(event:MouseEvent):void
		{
			if ( stage != null ) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
			
			if ( m_handle != null )
			{				
				if ( m_handle.x < 3 ) m_handle.x = 3;
				if ( m_handle.x > WIDTH - 13 ) m_handle.x = WIDTH - 13;
				
				if ( m_handle.y < 0 ) m_handle.y = 0;
				if ( m_handle.y > parent.height - 10 ) m_handle.y = parent.height - 10;
				
				if ( event.target.parent == this ) dispatchEvent(new Event(GradientSlider.GRADIENT_COLOR_CHANGED,false));
				
								
			}
		}
		 
		 
		private function makeTopMost(o:*):void
		{
			var highestDepth:uint = numElements - 1;
			setElementIndex(o, highestDepth);
		 	m_offsetX = o.x - mouseX;
			m_offsetY = o.y - mouseY;
		}
		 
		 
		private function onMove(event:MouseEvent):void
		{			
			var mousePoint:Point = globalToLocal( new Point(event.stageX, event.stageY) );
			
			if ( ! (mousePoint.y <= 3) && ! (mousePoint.y >= parent.height - 5) ) 
			{				
				m_handle.y = mouseY + m_offsetY;				
			}
			
			if ( ! (mousePoint.x <= WIDTH_MARGIN) && ! (mousePoint.x >= WIDTH - WIDTH_MARGIN) ) 
			{				
				m_handle.x = mouseX + m_offsetX;
			}
			
			// trace("Box " + m_handle.x + " " + m_handle.y + " Mouse " + mousePoint);
			
			if ( m_handle.x < 0 ) return;
			
			event.updateAfterEvent();
			
			gradientBuilder(true);
		
			
		}
		
		
		public function selectColor(event:MouseEvent = null):void
		{			
			if ( m_handle == null ) return;
			
			var color:int = m_handle.getStyle("borderColor");
			//M??? ColorPickerWindow.show_window(this, color, true, "BorderColorExtended");								
		}
		
		public function get handleColor():uint	
		{
			if (m_handle==null)
				return 0;
			
			return m_handle.getStyle("borderColor");
		}
		
		public function set handleColor(i_color:uint):void		
		{			
			if ( m_handle == null ) return;
			
			var lineColors:uint	  = i_color == 0x000000 ? 0xFFFFFF : 0x000000;
			
			m_handle.graphics.clear();			
			m_handle.graphics.lineStyle(1, lineColors, 1.0);
			m_handle.graphics.beginFill(i_color);			
			m_handle.graphics.drawRect(0, 0, 8, 7);
			m_handle.graphics.endFill();			
			m_handle.graphics.moveTo(4,0);
			m_handle.graphics.lineTo(4,-40);
			m_handle.graphics.moveTo(4,8);
			m_handle.graphics.lineTo(4,40);	
					
			m_handle.setStyle("borderColor", i_color );
			
			gradientBuilder(true);									
		}		
		
		
		public function loadGradientWithHandles(i_gradientColors:Array, i_gradientMidpoint:Array, i_gradientOpacity:Array, updateCallBack:Boolean = true):void
		{						
			for ( var i:int = 0 ; i < i_gradientColors.length ; i++ )
			{
				m_handle = createNewHandle(i_gradientMidpoint[i], i_gradientOpacity[i]*10, i_gradientColors[i]);				
			}
			
			m_gradientBackground.colorArray 		= i_gradientColors;
			m_gradientBackground.midpointArray	= i_gradientMidpoint;
			m_gradientBackground.opacityArray	= i_gradientOpacity;
			
			gradientBuilder(updateCallBack);	
			
			if ( m_handle != null ) 
				applyShadowOnHandle(m_handle);							
		}
		
		
		public function preloadGradient(value:int):void
		{
			clear();
			
			switch ( value )
			{
				case GRAYSCALE:
				{					
					loadGradientWithHandles(new Array(0xFFFFFF,0x000000),
				                new Array(1,242),
				                new Array(1,1) );
				                
					break;	
				}

				case TRADITIONAL:
				{				
					loadGradientWithHandles(new Array(0xFFFFFF,0x000000,0xFFFFFF),
				                new Array(1,[WIDTH/2],242),
				                new Array(1,1,1) );
				                
					break;	
				}

				case RED:
				{
					loadGradientWithHandles(new Array([0xFF0000]),
				                new Array([WIDTH/2]),
				                new Array([0.9]) );				                	
					break;	
				}

				case GREEN:
				{
					loadGradientWithHandles(new Array([0x00C000]),
				                new Array([WIDTH/2]),
				                new Array([0.9]) );				                
					break;	
				}

				case BLUE:
				{
					loadGradientWithHandles(new Array([0x4040FF]),
				                new Array([WIDTH/2]),
				                new Array([0.9]) );				                
					break;	
				}

				case YELLOW:
				{
					loadGradientWithHandles(new Array([0xFFFF00]),
				                new Array([WIDTH/2]),
				                new Array([0.9]) );				                
					break;	
				}

				case BLACK:
				{
					loadGradientWithHandles(new Array([0x000000]),
				                new Array([WIDTH/2]),
				                new Array([1]) );				            
					break;	
				}

				case WHITE:
				{
					loadGradientWithHandles(new Array([0xFFFFFF]),
				                new Array([WIDTH/2]),
				                new Array([1]) );				                
					break;	
				}

				case RAINBOW:
				{					 
					loadGradientWithHandles(new Array(16733463,16777215,5240588,16777215,11942570),
				                new Array(7,59,117,176,244),
				                new Array(0.9,0.7,0.9,0.3,1) );				                
					break;	
				}

				case FIRE:
				{					
					loadGradientWithHandles(new Array(16769071,16772453,16777215,16515072),
				                new Array(5,46,181,227),
				                new Array(0.6,0.7,0.2,0.8) );
				                
					break;	
				}				

				case EARTH:
				{					 
					loadGradientWithHandles(new Array(5549551,16777215,13739821),
				                new Array(5,162,242),
				                new Array(0.8,0.5,0.9) );				               
					break;	
				}
				
				case BEE:
				{					 
					loadGradientWithHandles(new Array(0,16776960,0),
				                new Array(3,6,242),
				                new Array(0.9,1,1) );				               
					break;	
				}				

				case BORDER:
				{
					loadGradientWithHandles(new Array(5549551,0,16777215,16777215,196608,13739821),
				                new Array(3,14,22,225,234,242),
				                new Array(0.9,0.7,0.4,0.5,0.8,0.9) );
				               
					break;	
				}

				case USA:
				{
					loadGradientWithHandles(new Array(16777215,16711680,255,16777215,16711680,4456703,16777215,16711680,1376511,16777215),
				                new Array(5,28,56,84,112,140,168,196,224,242),
				                new Array(1,1,1,1,1,1,1,1,1,1) );				
					break;	
				}				
				
				case CLEAR_BG:
				{
					loadGradientWithHandles([0xFFFFFF],[(WIDTH-(WIDTH_MARGIN*2))/2],[0]);										
					return;	
				}

				
				default:
				{
					// Single Color
					loadGradientWithHandles([value],[(WIDTH-(WIDTH_MARGIN*2))/2],[1]);					 
					return;
				}				
			}
			
			
		}
		
		
		public function evenSpread():void
		{
			// None
			if ( m_gradientBackground.colorArray == null ) return;
			
			// None
			if ( m_gradientBackground.colorArray.length == 0 ) return;			
		
		
			var spread:int = Math.round( WIDTH / (m_gradientBackground.colorArray.length - 1) );			
			var handle:UIComponent;
			var handles:Array = new Array();
			var i:int;
			
			for(i=0; i<numElements; i++)
			{
				handle = UIComponent(getElementAt(i));
				handles.push(handle);				
			}
				
			// One
			if ( m_gradientBackground.colorArray.length == 1 ) 
			{
				handles[0].x = (WIDTH-(WIDTH_MARGIN*2))/2;
				gradientBuilder(true);
				return;
			}
			
			// Many
			
			handles.sort(sortOnX);
							
			for (i=0; i < handles.length ; i++ )
			{
				handle = handles[i];
				
				// First
				if ( i == 0 )
				{
					handle.x = WIDTH_MARGIN;
					continue;					
				}
				
				// Last
				if ( i == handles.length-1 )
				{
					handle.x = WIDTH - ((WIDTH_MARGIN*2)+3);
					continue;					
				}				
				
				// Middles								
				handle.x = spread * i;			
			}
			
			gradientBuilder(true);
		}
		
		
		public function clear():void
		{			
			if (m_gradientBackground==null)
				return;
			m_gradientBackground.gradientType = GradientType.LINEAR;
			
							
			for(var i:int=0; i<numElements; i++)
			{
				var handle:UIComponent = UIComponent(getElementAt(i));
				handle.removeEventListener(MouseEvent.MOUSE_DOWN, drag);
				handle.removeEventListener(MouseEvent.MOUSE_UP, drop);
				handle.removeEventListener(MouseEvent.DOUBLE_CLICK,selectColor);
				handle.filters = null;				
			}	
			
			this.graphics.clear();
			removeAllElements();
			m_handle = null;						
		}


		public function destroy():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,init);
			//M??? this.removeEventListener(ColorPickerCustomEvent.EXTENDED_COLOR_APPLY,onSelectColorCompleted);
			
			if ( stage != null )
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);			
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
			
			for(var i:int=0; i<numElements; i++)
			{
				var handle:UIComponent = UIComponent(getElementAt(i));
				handle.removeEventListener(MouseEvent.MOUSE_DOWN, drag);
				handle.removeEventListener(MouseEvent.MOUSE_UP, drop);
				handle.removeEventListener(MouseEvent.DOUBLE_CLICK,selectColor);
				handle.filters = null;				
			}	
			
			m_handle = null;			
			// _callBack = null;			
		}
		
		
		public function deleteHandle():void
		{
			if ( m_handle == null ) return;
			
			removeElement(m_handle);
			m_handle.removeEventListener(MouseEvent.MOUSE_DOWN, drag);
			m_handle.removeEventListener(MouseEvent.MOUSE_UP, drop);
			m_handle.removeEventListener(MouseEvent.DOUBLE_CLICK,selectColor);
			
			gradientBuilder(true);
			m_handle = null;		
		}
			
		public function set onColorChanged(i_callBack:Object):void
		{
			m_callBack = i_callBack;
		}
		
		
		public function precisionMoveHandler(direction:int):void
		{
			if ( m_handle == null) return;
			
			switch (direction)
			{
				case MOVE_LEFT:
				{
					if (m_handle.x <= WIDTH_MARGIN-2 ) return;
					m_handle.x -= 1;
					gradientBuilder(true);
					break;
				}
				
				case MOVE_RIGHT:
				{
					if (m_handle.x >= (WIDTH-13) ) return;
					m_handle.x += 1;
					gradientBuilder(true);
					break;
				}		
				
				case MOVE_TOP:
				{
					if (m_handle.y <= 0 ) return;
					m_handle.y -= 1;
					gradientBuilder(true);
					break;
				}										

				case MOVE_BOTTOM:
				{
					if (m_handle.y >= HEIGHT-10 ) return;
					m_handle.y += 1;
					gradientBuilder(true);
					break;
				}				
			}
		}
	}
}