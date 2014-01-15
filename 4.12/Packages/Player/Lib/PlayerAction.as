package
{
	import flash.utils.Dictionary;
	
	public class PlayerAction
	{
		private var m_delay:Number;
		private var m_duration:Number;
		private var m_totalTime:Number;
		private var m_easingId:int = 10;
		private var m_k1:Number = 0;
		private var m_k2:Number = 0;
		private var m_k3:Number = 0;
		private var m_k4:Number = 0;
		private var m_k5:Number = 1;
		
		public static const EASING:Object = 
			{
				10:{"id":10, "k1":0, "k2":0, "k3":0, "k4":0, "k5":1},
				20:{"id":20, "k1":0, "k2":0, "k3":-2, "k4":3, "k5":0},
				30:{"id":30, "k1":6, "k2":-15, "k3":10, "k4":0, "k5":0},
				40:{"id":40, "k1":1, "k2":0, "k3":0, "k4":0, "k5":0},
				50:{"id":50, "k1":0, "k2":1, "k3":0, "k4":0, "k5":0},
				60:{"id":60, "k1":0, "k2":0, "k3":1, "k4":0, "k5":0},
				70:{"id":70, "k1":0, "k2":0, "k3":0, "k4":1, "k5":0},
				80:{"id":80, "k1":1, "k2":-5, "k3":10, "k4":-10, "k5":5},
				90:{"id":90, "k1":0, "k2":-1, "k3":4, "k4":-6, "k5":4},
				100:{"id":100, "k1":0, "k2":0, "k3":1, "k4":-3, "k5":3},
				110:{"id":110, "k1":0, "k2":0, "k3":4, "k4":-6, "k5":3},
				120:{"id":120, "k1":0, "k2":0, "k3":6, "k4":-9, "k5":4},
				130:{"id":130, "k1":0, "k2":0, "k3":4, "k4":-3, "k5":0},
				140:{"id":140, "k1":0, "k2":2, "k3":2, "k4":-3, "k5":0},
				150:{"id":150, "k1":0, "k2":0, "k3":4, "k4":-9, "k5":6},
				160:{"id":160, "k1":0, "k2":-2, "k3":10, "k4":-15, "k5":8},
				170:{"id":170, "k1":33, "k2":-106, "k3":126, "k4":-67, "k5":15},
				180:{"id":180, "k1":51.46969696969697, "k2":-156.87878787878788, "k3":172.8181818181818, "k4":-81.87878787878788, "k5":15.469696969696969},
				190:{"id":190, "k1":33, "k2":-59, "k3":32, "k4":-5, "k5":0},
				200:{"id":200, "k1":55.83333333333333, "k2":-104.83333333333331, "k3":60, "k4":-10, "k5":0}
			};
		
		
		
		public function PlayerAction()
		{
		}

		public function get delay():Number
		{
			return m_delay;
		}
		public function set delay(i_delay:Number):void
		{
			m_delay = i_delay;
			m_totalTime = m_delay + m_duration;
		}

		public function get duration():Number
		{
			return m_duration;
		}
		
		public function set duration(i_duration:Number):void
		{
			m_duration = i_duration;
			m_totalTime = m_delay + m_duration;
		}
		
		public function get easingId():int
		{
			return m_easingId;
		}
		
		public function set easingId(i_easingId:int):void
		{
			m_easingId = i_easingId;
			var easing:Object = EASING[i_easingId];
			if (easing!=null)
			{
				m_k1 = easing.k1;
				m_k2 = easing.k2;
				m_k3 = easing.k3;
				m_k4 = easing.k4;
				m_k5 = easing.k5;
			}
		}

		public function load(i_xmlAction:XML):void
		{
			m_delay = i_xmlAction.@delay;
			m_duration = i_xmlAction.@duration;
			m_totalTime = m_delay + m_duration;
			easingId = i_xmlAction.@easingId;
		}

		public function save():XML
		{
			var xmlAction:XML = <Action/>;
			xmlAction.@delay = m_delay;
			xmlAction.@duration = m_duration;
			xmlAction.@easingId = m_easingId;
			return xmlAction;
		}
		
		public function f(i_time:Number):Number
		{
			var y:Number = 0;
			if (i_time>m_delay)
			{
				var t:Number = i_time - m_delay	
				var ts:Number=(t/=m_duration)*t;
				var tc:Number=ts*t;
				y = m_k1*tc*ts + m_k2*ts*ts + m_k3*tc + m_k4*ts + m_k5*t;
			}			
			return y; 	
		}
		
		public function getNumber(i_k:Number, i_number1:Number, i_number2:Number):Number
		{
			return i_number1 + i_k * (i_number2 - i_number1);
		}
		
		public function getColor(i_k:Number, i_color1:Number, i_color2:Number):Number
		{
			var r1:Number = i_color1 & 0x0000ff;
			var g1:Number = (i_color1 & 0x00ff00) >> 8;
			var b1:Number = (i_color1 & 0xff0000) >> 16;

			var r2:Number = i_color2 & 0x0000ff;
			var g2:Number = (i_color2 & 0x00ff00) >> 8;
			var b2:Number = (i_color2 & 0xff0000) >> 16;
			
			var r3:Number = r1 + i_k * (r2 - r1);
			var g3:Number = g1 + i_k * (g2 - g1);
			var b3:Number = b1 + i_k * (b2 - b1);
			
			return r3 + (g3<<8) + (b3<<16);
		}
		
		public function isDone(i_time:Number):Boolean
		{
			return (i_time>m_totalTime);
		}
	}
}