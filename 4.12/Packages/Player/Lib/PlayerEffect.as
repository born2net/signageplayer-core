package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;


	public class PlayerEffect extends EventDispatcher implements IEffect
	{
		protected var m_playerLoader:PlayerLoader;
		private var m_properties:Array = new Array();
		private var m_actions:Array = new Array();
		
		protected var m_playerAcction:PlayerAction;
		private var m_prop1:Object;
		private var m_prop2:Object;
		private var m_index:int;
		private var m_time1:Number;
		private var m_time2:Number;
		private var m_time3:Number;
		private var m_duration:Number;
		private var m_idle:Boolean;
		private var m_apply:Boolean = true;
		
		public function PlayerEffect(i_playerLoader:PlayerLoader)
		{
			m_playerLoader = i_playerLoader;
		}
		
		public function get index():int
		{
			return m_index;
		}
		
		public function set index(i_index:int):void
		{
			m_index = i_index;
			var playerAction:PlayerAction = m_actions[m_index]; 
			var offsetTime:Number = (playerAction!=null) ? playerAction.delay + playerAction.duration : 0;
			m_playerLoader.dispatchEvent( new OffsetTimeEvent(OffsetTimeEvent.EVENT_OFFSET_TIME, offsetTime) );
		}
		
		public function get count():int
		{
			return m_properties.length;
		}

		public function getProperty(i_key:String):Object
		{
			var prop:Object = m_properties[m_index];
			if (prop==null)
				return null;
			return prop[i_key];
		}

		public function getPropertyAsString(i_key:String):String
		{
			var prop:Object = getProperty(i_key);
			return (prop!=null) ? prop.toString() : "";
		}
		
		public function setProperty(i_key:String, i_value:Object, i_applyData:Boolean = true):void
		{
			var prop:Object = m_properties[m_index];
			prop[i_key] = i_value;
			if (i_applyData)
			{
				m_playerLoader.refresh();
			}
		}

		public function get action():PlayerAction
		{
			return m_actions[m_index];
		}

		public function insert(i_action:PlayerAction, i_data:Object):void
		{
			m_actions.push(i_action);
			m_properties.push(i_data);
		}
		
		public function clear():void
		{
			m_actions = new Array();
			m_properties = new Array();
			m_apply = true;
		}
		
		public function stop():void
		{
			m_idle = false;
			m_index = 0;
			m_time1 = m_time2 = m_time3 = 0;
			m_playerAcction = m_actions[1];
			m_prop1 = m_properties[0];
			m_prop2 = m_properties[1];
			
			applyData(m_prop1);
		}
		
		public function pause():void
		{
			
		}
		
		public function get seek():Number
		{
			return 0; //???
		}
		public function set seek(i_seek:Number):void
		{
		}
		
		public function set modified(i_modified:Boolean):void
		{
			m_playerLoader.modified = i_modified;
		}
		
		public function get modified():Boolean
		{
			return m_playerLoader.modified;
		}
		
		
		public function start():void 
		{
			m_playerAcction = m_actions[1];
			m_idle = false;
			m_index = 0;
			m_time1 = m_time2 = m_time3 = 0;
			m_prop1 = m_properties[0];
			m_prop2 = m_properties[1];
			m_apply = true;
			applyData(m_prop1);
		}
		
		protected function isFilter():Boolean
		{
			return false;
		}
		
		public function enableEffect():void
		{ 
			m_apply = true;
		}		
		
		public function onFrame(i_time:Number):void
		{
			//??? if (m_apply==false)
			//???	return;
				
			if (m_playerAcction==null)
			{
				// static
				if (m_prop1!=null)
				{
					applyData(m_prop1);   //???? should not happend every frame !
					m_apply = isFilter();
				}
				return;
			}
			if (m_playerAcction.isDone(i_time))
			{
				applyData(m_prop2);
				m_apply = isFilter();
			}
			else
			{
				var prop:Object = new Object;
				var k:Number = m_playerAcction.f(i_time);
				onAction(k, m_prop1, m_prop2, prop);
				applyData(prop);
			}
		}
		
		protected function onAction(i_k:Number, i_prop1:Object, i_prop2:Object, i_prop:Object):void
		{
		}
		
		public function load(i_xmlData:XML):void
		{
			var xmlProperties:XML = i_xmlData;
			var prop:Object = parseXML(xmlProperties) 
			insert(null, prop);
			for each(var xmlAction:XML in i_xmlData.Actions.*)
			{
				var playerAction:PlayerAction = new PlayerAction();
				playerAction.load(xmlAction);
				prop = parseXML(xmlAction.children()[0])
				insert(playerAction, prop);
			}
			start(); //???
		}
		
		protected function parseXML(i_xmlProperties:XML):Object
		{
			return null;	
		}
		
		protected function buildXML(i_prop:Object):XML
		{
			return null;
		}

		protected function applyData(i_properties:Object):void
		{
		}
		
		public function save():XML
		{
			var xmlBorder:XML = buildXML(m_properties[0]);
			if (m_actions.length>1)
			{
				var xmlActions:XML = <Actions/>;
				xmlBorder.appendChild(xmlActions);
				for(var i:int=1; i<m_actions.length;i++)
				{
					var playerAction:PlayerAction = m_actions[i];
					var xmlAction:XML = playerAction.save();
					xmlActions.appendChild(xmlAction);
					
					var xmlProp:XML = buildXML(m_properties[i]);
					xmlAction.appendChild(xmlProp);
				}
			}
			return xmlBorder;
		}
		
		public function getStyle(i_styleProp:String):Object
		{
			return m_playerLoader.getStyle(i_styleProp);
		}

		public function setStyle(i_styleProp:String, i_newValue:Object):void
		{
			//UIComponent(m_playerLoader.player).setStyle(i_styleProp, i_newValue);
			m_playerLoader.setStyle(i_styleProp, i_newValue);
		}
	}
}