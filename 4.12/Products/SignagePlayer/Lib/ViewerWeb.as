package
{
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public class ViewerWeb extends Group implements IViewer
	{
		private var m_framework:IFramework
		private var m_transitionManager:TransitionManager;
		private var m_advertisingService:IAdvertisingService;
		
		private var m_x:Number;
		private var m_y:Number;
		private var m_width:Number;
		private var m_height:Number;
		private var m_scaleX:Number = 1;
		private var m_scaleY:Number = 1;
		
		private var m_commonChannel:Boolean = false;
		private var m_hChanel:int = -1;
		private var m_hPlayer:int = -1;
		private var m_inUse:Boolean = false;
		
		private var m_order:int = 0;
		private var m_playerOffset:Number;
		private var m_time:Number = 0;
		
		
		private var m_adLocalStat:IAdLocalStat;
		

		public function ViewerWeb(i_framework:IFramework)
		{
			super();
			m_framework = i_framework;
			m_transitionManager = new TransitionManager(m_framework, this);
			m_advertisingService = m_framework.ServiceBroker.QueryService("AdvertisingService") as IAdvertisingService;
		}
		
		
		public function set transitionEnabled(i_transitionEnabled:Boolean):void
		{
			m_transitionManager.transitionEnabled = i_transitionEnabled;
		}
		

		public function setRect(i_x:Number, i_y:Number, i_width:Number, i_height:Number):void
		{
			m_x = i_x;
			m_y = i_y;
			m_width = i_width;
			m_height = i_height;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function setScale(i_scaleX:Number, i_scaleY:Number):void
		{
			m_scaleX = i_scaleX;
			m_scaleY = i_scaleY;
			invalidateProperties();
			invalidateDisplayList();
		}
			 
		public function load(i_hPlayer:int, i_xmlPlayer:XML, i_playerOffset:Number, i_time:Number, i_adLocalEnabled:Boolean, i_hAdLocalContent:int):void
		{
			m_time = i_time;
			
			addPrevStat();

			if (i_adLocalEnabled && i_hAdLocalContent!=-1)
			{
				m_adLocalStat = m_advertisingService.getLocalStat(i_hAdLocalContent);
				if (m_adLocalStat!=null)
				{
					m_adLocalStat.beginPlay(width, height);
				}
			}

			m_hPlayer = i_hPlayer;
			var seek:Number = Math.max(0, (i_playerOffset-i_time)/1000);
			m_transitionManager.load(i_xmlPlayer, seek);
			m_playerOffset =  i_playerOffset;
			invalidateDisplayList();
			
			
		}
		
		
		private function addPrevStat():void
		{
			if (m_adLocalStat!=null)
			{
				m_adLocalStat.finishPlay();
				m_adLocalStat = null;
			}
		}
		
		public function clean():void
		{
			addPrevStat();
			
			m_transitionManager.clean();
			visible = false;				
			m_hChanel = -1;
			m_hPlayer = -1;
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
			m_time = i_time;
			var playingTime:Number = i_time - m_playerOffset;
			m_transitionManager.tick(playingTime);
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
		
		protected override function createChildren():void
		{
			super.createChildren();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			x = m_x * m_scaleX;
			y = m_y * m_scaleY;
			width = m_width * m_scaleX;
			height = m_height * m_scaleY;
			
			//AlertEx.showOk(UIComponent(m_framework.StateBroker.GetState("topWindow")), width.toString(), "ViewerWeb");
		}

		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			m_transitionManager.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (m_adLocalStat!=null)
			{
				m_adLocalStat.updatePlay(width, height);
			}
		}
	
	}
}