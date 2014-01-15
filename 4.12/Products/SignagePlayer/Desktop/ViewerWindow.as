package
{
	public class ViewerWindow extends BlankWindow implements IViewer
	{
		private var m_framework:IFramework
		private var m_transitionManager:TransitionManager;
		
		private var m_commonChannel:Boolean = false;
		private var m_hChanel:int = -1;
		private var m_hPlayer:int = -1;
		
		private var m_order:int = 0;
		private var m_playerOffset:Number;
		private var m_time:Number;
		private var m_xmlPlayer:XML;
		private var m_invalidateLoad:Boolean = false;
		private var m_inUse:Boolean = false;
		/*
		private var m_invalidatePosition:Boolean = true;
		private var m_playerAction:PlayerAction;
		private var m_oldX:Number = 0;
		private var m_oldY:Number = 0;
		private var m_newX:Number = 0;
		private var m_newY:Number = 0;
		*/
				
		public function ViewerWindow(i_framework:IFramework)
		{
			super();
			m_framework = i_framework;
			m_transitionManager = new TransitionManager(m_framework, this);
			/*
			m_playerAction = new PlayerAction();
			m_playerAction.duration = 2000;
			m_playerAction.delay = 0;
			m_playerAction.easingId = 70;
			m_invalidatePosition = true;
			*/
		}
		
		public function load(i_hPlayer:int, i_xmlPlayer:XML, i_playerOffset:Number, i_time:Number):void
		{
			m_hPlayer = i_hPlayer;
			m_playerOffset =  i_playerOffset;
			m_xmlPlayer = i_xmlPlayer;
			m_time = i_time;
			m_invalidateLoad = true;
			//m_invalidatePosition = true;
			invalidateProperties();
		}
		
		public function clean():void
		{
			m_transitionManager.clean();
			visible = false;				
			m_hChanel = -1;
			m_hPlayer = -1;
			m_xmlPlayer = null;
			/*
			m_oldX = 0;
			m_oldY = 0;
			m_newX = 0;
			m_newY = 0;
			m_invalidatePosition = true;
			*/
		}
		
		public function get commonChannel():Boolean
		{
			return m_commonChannel;
		}
		
		public function set commonChannel(i_commonChannel:Boolean):void
		{
			m_commonChannel = i_commonChannel;
		}
		
		public function get hChanel():int
		{
			return m_hChanel;
		}
		
		public function set hChanel(i_hChanel:int):void
		{
			m_hChanel = i_hChanel;
		}
		
		public function get hPlayer():int
		{
			return m_hPlayer;
		}
		
		public function get order():int
		{
			return m_order;
		}
		
		public function set order(i_order:int):void
		{
			m_order = i_order;
		}
		
		public function tick(i_time:Number):void
		{
			var time:Number = i_time - m_playerOffset;
			m_transitionManager.tick(time);
			
			/*
			var time:Number = i_time-m_playerOffset;
			if (m_invalidatePosition)
			{
				if (time>m_playerAction.duration)
				{
					time = m_playerAction.duration
					m_invalidatePosition = false;
				}
				var k:Number = m_playerAction.f(time);
				nativeWindow.x = m_playerAction.getNumber(k, m_oldX, m_newX);
				nativeWindow.y = m_playerAction.getNumber(k, m_oldY, m_newY);
			} 
			*/
		}
		
		public function get inUse():Boolean
		{
			return m_inUse;
		}
		
		public function set inUse(i_inUse:Boolean):void
		{
			m_inUse = i_inUse;
		}
		
		public function get playerLoader():IPlayerLoader
		{
			return m_transitionManager.playerLoader;
		}
		
		public override function set x(i_x:Number):void
		{
			//m_invalidatePosition = true;
			//m_oldX = m_newX;
			//m_newX = i_x;
			nativeWindow.x = i_x;
		}

		public override function set y(i_y:Number):void
		{
			//m_invalidatePosition = true;
			//m_oldY = m_newY;
			//m_newY = i_y;
			nativeWindow.y = i_y;
		}
		
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			if (m_invalidateLoad)
			{
				m_invalidateLoad = false;
				var seek:Number = (m_time-m_playerOffset)/1000;
				m_transitionManager.load(m_xmlPlayer, seek);
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			m_transitionManager.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}