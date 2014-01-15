package
{
	import mx.core.IUIComponent;
	import mx.core.IVisualElementContainer;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	
	import spark.components.BorderContainer;
	
	public class PlayerTransition implements IPlayerTransition
	{
		private var m_framework:IFramework;
		private var m_playerLoader:PlayerLoader;
		private var m_container:IVisualElementContainer;
		private var m_fade:Fade;
		
		public function PlayerTransition(i_framework:IFramework, i_container:IVisualElementContainer)
		{
			m_framework = i_framework;
			m_container = i_container;
		}
		
		public function get playerLoader():IPlayerLoader
		{
			return m_playerLoader;	
		}

		public function load(i_xmlPlayer:XML, i_seek:Number):void
		{
			if (m_playerLoader!=null) 
			{
				cleanTransitionEffect();
				m_fade = new Fade(m_playerLoader);
				m_fade.duration = 1000;
				m_fade.alphaFrom = m_playerLoader.alpha;  //???
				m_fade.alphaTo = 0;
				m_fade.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
				m_fade.play();
			}
			m_playerLoader = new PlayerLoader();
			m_playerLoader.framework = m_framework;
			m_playerLoader.usePlayerLayout = false;
			m_playerLoader.width = IUIComponent(m_container).width;
			m_playerLoader.height = IUIComponent(m_container).height;
			m_container.addElementAt(m_playerLoader, 0);
			m_playerLoader.load(i_xmlPlayer);

			/*2
			if (m_playerLoader.player==null) // in case the scene is deleted and still exist in timeline block.
				return;
*/
			m_playerLoader.seek = i_seek;
			//m_playerLoader.validateNow(); // create All DesignerPlayer childrens, so Start will apply to all children.

				m_playerLoader.width = IUIComponent(m_container).width;
				m_playerLoader.height = IUIComponent(m_container).height;

			m_playerLoader.start();
		}
		
		private function onEffectEnd(event:EffectEvent):void
		{
			var fade:Fade = Fade(event.currentTarget);
			var playerLoader:PlayerLoader = PlayerLoader(fade.target);
			cleanTransitionEffect();
		}
		
		public function tick(i_time:Number):void
		{
			if (m_playerLoader!=null)
				m_playerLoader.onFrame(i_time);
		}
		
		private function cleanTransitionEffect():void
		{
			if (m_fade!=null)
			{
				var playerLoader:PlayerLoader = PlayerLoader(m_fade.target);
				playerLoader.stop();
				m_fade.removeEventListener(EffectEvent.EFFECT_END, onEffectEnd);
				m_container.removeElement(playerLoader);
				m_fade = null;
			}
		}
		
		public function clean():void
		{
			cleanTransitionEffect();
			if (m_playerLoader!=null)
			{
				m_playerLoader.clear();
				m_playerLoader = null;
				m_container.removeAllElements();
			} 
		}
		
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (m_playerLoader!=null)  // Fix Scrolling issue when Screen-Devision changed in the timeline.
			{
				if (IUIComponent(m_playerLoader).width!=unscaledWidth || IUIComponent(m_playerLoader).height!=unscaledHeight)
				{
					m_playerLoader.width = unscaledWidth;
					m_playerLoader.height = unscaledHeight;
					m_playerLoader.invalidateDisplayList();
				}
			}
			if (m_fade!=null)
			{
				var playerLoader:PlayerLoader = m_fade.target as PlayerLoader;
				if (playerLoader!=null)  // Fix Scrolling issue when Screen-Devision changed in the timeline.
				{
					if (playerLoader.width!=unscaledWidth || playerLoader.height!=unscaledHeight)
					{
						playerLoader.width = unscaledWidth;
						playerLoader.height = unscaledHeight;
						m_playerLoader.invalidateDisplayList();
					}
				}
			}
		}
	}
}