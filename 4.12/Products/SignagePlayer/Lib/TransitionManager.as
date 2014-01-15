package
{
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	
	public class TransitionManager
	{
		private var m_framework:IFramework;
		private var m_playerLoader:PlayerLoader;
		private var m_viewer:IVisualElementContainer;
		private var m_fade:Fade;
		private var m_transitionEnabled:Boolean = true;
		
		public function TransitionManager(i_framework:IFramework, i_viewer:IVisualElementContainer)
		{
			m_framework = i_framework;
			m_viewer = i_viewer;
		}
		
		public function set transitionEnabled(i_transitionEnabled:Boolean):void
		{
			m_transitionEnabled = i_transitionEnabled;
		}
		
		
		public function get playerLoader():PlayerLoader
		{
			return m_playerLoader;	
		}

		public function load(i_xmlPlayer:XML, i_seek:Number):void
		{
			if (m_playerLoader!=null) 
			{
				if (m_transitionEnabled)
				{
					cleanTransitionEffect();
					fadeOut();
				}
				else
				{
					m_playerLoader.clear();
					m_playerLoader = null;
					m_viewer.removeAllElements();
				}
			}
			m_playerLoader = new PlayerLoader();
			m_playerLoader.framework = m_framework;
			m_playerLoader.usePlayerLayout = false;
			m_playerLoader.width = UIComponent(m_viewer).width;
			m_playerLoader.height = UIComponent(m_viewer).height;
			m_viewer.addElementAt(m_playerLoader, 0);
			m_playerLoader.load(i_xmlPlayer);
			
			/*
			if (m_playerLoader.player==null) // in case the scene is deleted and still exist in timeline block.
				return;
*/
			
			m_playerLoader.seek = i_seek;
			// m_playerLoader.validateNow(); // create All DesignerPlayer childrens, so Start will apply to all children.

				m_playerLoader.width = UIComponent(m_viewer).width;
				m_playerLoader.height = UIComponent(m_viewer).height;

			m_playerLoader.start(); 
		}
		
		private function fadeOut():void
		{
			if (m_playerLoader!=null)
			{
				m_fade = new Fade(m_playerLoader);
				m_fade.duration = 1000;
				m_fade.alphaFrom = m_playerLoader.alpha;  //???
				m_fade.alphaTo = 0;
				m_fade.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
				m_fade.play();
			}
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
				m_viewer.removeElement(playerLoader);
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
				m_viewer.removeAllElements();
			} 
		}
		
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (m_playerLoader!=null)  // Fix Scrolling issue when Screen-Devision changed in the timeline.
			{
				if (m_playerLoader.width!=unscaledWidth || playerLoader.height!=unscaledHeight)
				{
					m_playerLoader.width = unscaledWidth;
					m_playerLoader.height = unscaledHeight;
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
					}
				}
			}
		}
	}
}