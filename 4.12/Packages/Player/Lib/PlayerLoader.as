package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	
	public class PlayerLoader extends ComponentLoader implements IPlayerLoader, IEventHandleHost
	{
		protected var m_debugLog:IDebugLog;
		private var m_stateManager:IStateManager;
		protected var m_dataBaseManager:DataBaseManager; 
		protected var m_propertyService:IPropertyService;
		protected var m_resourceService:IResourceService;
		protected var m_playerLoaderService:IPlayerLoaderService;
		protected var m_playerEventService:IPlayerEventService;
  
  		private var m_container:IVisualElementContainer;
		private var m_playerEffectMap:Dictionary = new Dictionary(); 
		private var m_playerPosAndSize:PlayerPosAndSize;
		private var m_playerAppearance:PlayerAppearance;
		private var m_playerBorder:PlayerBorder;
		private var m_playerBackground:PlayerBackground;
		private var m_playerGlow:PlayerGlow;
		private var m_playerBlur:PlayerBlur;
		private var m_playerShadow:PlayerShadow;

		
		
		private var m_filters:Array;  
		private var m_time:Number = 0;
  
		private var m_modified:Boolean = false;
		private var m_playerId:int = -1;
		private var m_hResource:int = -1; // in case of Component
		
		private var m_xmlPlayer:XML;
		private var m_xmlData:XML;
		private var m_dataProvider:IDataProvider;
		private var m_providerItem:String;
		
		
		private var m_hPlayerData:int = -1;
		private var m_editModule:Boolean = false;
		private var m_usePlayerLayout:Boolean = true;
		
		protected var m_autoDispose:Boolean = true;
		protected var m_disposed:Boolean = false;
		
		private var m_eventName:String;
		private var m_interactive:Boolean = false;
		private var m_mimeType:String;
		private var m_label:String;
		private var m_locked:Boolean;
		
		private var m_parentPlayerLoader:IPlayerLoader;
		
		
		private var m_eventHandlers:ArrayCollection;
		
		
		private static var m_recursiveLoadMap:Object = new Object();
		
		private var m_requestStart:Boolean = false;
		private var m_requestSeek:Number = NaN;
		
		
		public function PlayerLoader()
		{
			super();
			m_container = this; // container is the playerLoader by default and could be override.
			setStyle("backgroundAlpha", 0); 
			setStyle("borderVisible", false);
		}
		
		public override function set framework(i_framework:IFramework):void
		{
			super.framework = i_framework;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
			m_stateManager = m_framework.ServiceBroker.QueryService("StateManager") as IStateManager;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_propertyService = m_framework.ServiceBroker.QueryService("PropertyService") as IPropertyService;
			m_resourceService = m_framework.ServiceBroker.QueryService("ResourceService") as IResourceService;
			m_playerLoaderService = m_framework.ServiceBroker.QueryService("PlayerLoaderService") as IPlayerLoaderService;
			m_playerEventService = m_framework.ServiceBroker.QueryService("PlayerEventService") as IPlayerEventService;
		}
		
		protected override function get useClip():Boolean
		{
			return false;
		}		
		
		
		public function get playerName():String   // shoube be call eventName
		{
			return m_eventName;
		}
		
		public function set playerName(i_playerName:String):void   // shoube be call eventName
		{
			m_eventName = i_playerName;
			modified = true;
		}
		
		
		public function get interactive():Boolean
		{
			return m_interactive;
		}
		
		public function set interactive(i_interactive:Boolean):void
		{
			m_interactive = i_interactive;
			if (m_interactive)
			{
				addEventListener(MouseEvent.CLICK, onClick);
			}
			else
			{
				removeEventListener(MouseEvent.CLICK, onClick);
			}
			modified = true;
		}		

		public function get mimeType():String
		{
			return m_mimeType;
		}
		
		public function set mimeType(i_mimeType:String):void
		{
			m_mimeType = i_mimeType;
			modified = true;
		}

		
		public function get locked():Boolean
		{
			return m_locked;
		}
		
		public function set locked(i_locked:Boolean):void
		{
			m_locked = i_locked;
			modified = true;
		}

		
		public function get label():String
		{
			return m_label;
		}
		
		public function set label(i_label:String):void
		{
			if (m_label != i_label)
			{
				m_label = i_label;
				modified = true;
				
				m_framework.StateBroker.dispatchEvent( new Event("event_playerloader_label_changed") );
				m_stateManager.updateRecord(this);
			}
		}

		
		public function get embedded():Boolean
		{
			return (XMLList(m_xmlPlayer.@hDataSrc).length()==0);
		}
		
		
		public function createEventHandler(i_senderName:String, i_eventCondition:String, i_commandName:String, i_commandParams:XML):IEventHandler
		{
			if (m_eventHandlers==null)
			{
				m_eventHandlers = new ArrayCollection();
				m_eventHandlers.addEventListener(CollectionEvent.COLLECTION_CHANGE, onEventCommandsChange);
			}

			var eventHandler:PlayerEventHandler = new PlayerEventHandler(m_playerEventService, this);
			eventHandler.senderName = i_senderName;
			// eventHandler.eventCondition = i_eventCondition;  //??? Not Supported in this version!
			eventHandler.commandName = i_commandName;
			eventHandler.commandParams = i_commandParams;
			
			
			if (m_playerEventService!=null)
			{
				m_playerEventService.registerEventHandler(eventHandler);
			}
			return eventHandler;
		}
		
		public function get eventHandlers():ArrayCollection
		{
			return m_eventHandlers;
		}
		
		public function sendEvent(i_senderName:String, i_eventName:String, i_eventParam:Object):void
		{
			m_playerEventService.sendEvent(i_senderName, i_eventName, i_eventParam);
		}
		
		
		public function onCommand(i_eventHandler:IEventHandler, i_eventParam:Object):void
		{
			if (player==null)
				return;
			IEventHandleHost(player).onCommand(i_eventHandler, i_eventParam);
		}
		
		private function onEventCommandsChange(event:CollectionEvent):void
		{
			modified = true;
		}
		
		private function onClick(event:MouseEvent):void
		{
			if (m_eventName==null || m_eventName=="")
				return;
			sendEvent(m_eventName, "click", null);
		}
		

		public function get usePlayerLayout():Boolean
		{
			return m_usePlayerLayout;
		}		
		
		public function set usePlayerLayout(i_usePlayerLayout:Boolean):void
		{
			m_usePlayerLayout = i_usePlayerLayout;
		}		
		
		public function get editModule():Boolean
		{
			return m_editModule;
		}

		public function set editModule(i_editModule:Boolean):void
		{
			m_editModule = i_editModule;
		}
		
		public function showProperties():void
		{
			if (XMLList(m_xmlPlayer.@hDataSrc).length()>0)
			{
				//m_propertyService.registerPage(DataPage, this);	
			}
			else
			{
				m_propertyService.registerPage(PlayerDefinitionPage, this);
				m_propertyService.registerPage(PlayerCommonPage, this);	
				
				if (player!=null)
				{
					for each(var classPage:Class in player.propertyPages)
					{
						m_propertyService.registerPage(classPage, this);
					}
				}
			}
		}
		
		public function get container():IVisualElementContainer
		{
			return m_container;
		}
		
		public function set container(i_container:IVisualElementContainer):void
		{
			m_container = i_container;
		}

		public function get component():UIComponent
		{
			return m_container as UIComponent;
		}
		
		public function addFilter(i_filter:BitmapFilter):void
		{
			m_filters.push(i_filter);
		}
		
		public override function clear():void
		{
			if (player!=null)
			{
				if (m_interactive)
				{
					removeEventListener(MouseEvent.CLICK, onClick);
				}	
				
				if (m_eventHandlers!=null)
				{
					/// m_playerEventService.unregisterPlayerEvent(???, this);
					m_eventHandlers = null;
				}
				
				player.clear();
				clearEffects();
			}
			
			if (m_hResource!=-1)
			{
				m_moduleService.dettachChildFromResource(this, m_hResource);
				m_hResource = -1;
				removeProgress();
				if (child!=null)
				{
					removeElement(child);
					child = null;
				}				
			}
			
			super.clear();
		}
		
		public function unloadPlayer():void
		{ 
			m_xmlPlayer = null;
			m_playerId = -1;
			moduleId = -1;
		}
		
		private function createPlayer(i_playerId:int):void
		{
			clear();
			m_playerId = i_playerId;	
			if (i_playerId!=-1)
			{
				moduleId = (m_editModule) ? i_playerId + 1 : i_playerId;
				if (player!=null)
				{
					player.playerLoader = this;
				}
			}
			else
			{
				trace("createPlayer(-1) FAIL");
			}
		}
		
		private function createPlayerFromResource(i_hResource:int):void
		{
			clear();
			m_hResource = i_hResource;
			if (i_hResource!=-1)
			{
				var url:String = m_resourceService.getUrlFromHandle(i_hResource);
				if (url==null)
					return;
				var i:int = url.indexOf("Resources");
				var relativePath:String = url.substring(i+10);
				m_moduleService.attachChildToResource(this, i_hResource, relativePath, "???");
			}
			else
			{
				removeProgress();
				if (child!=null)
				{
					removeElement(child);
					child = null;
				}
			}
			
			
			if (player!=null)
			{
				player.playerLoader = this;
			}
			else
			{
				trace("createPlayerFromResource(-1) FAIL");
			}
		}		

		public function get player():IPlayer
		{
			return child as IPlayer;
		}
		
		public function get playerId():int
		{
			return m_playerId;
		} 
		
		
		public function load(i_xmlPlayer:XML):void
		{
			if (m_debugLog!=null && i_xmlPlayer!=null)
			{
				m_debugLog.addInfo(i_xmlPlayer.toString());
			}
			
			m_xmlPlayer = i_xmlPlayer;
			m_eventName = i_xmlPlayer.@name;
			m_interactive = (i_xmlPlayer.@interactive=="1");
			m_mimeType = i_xmlPlayer.@mimeType;
			m_label = i_xmlPlayer.@label;
			m_locked = (i_xmlPlayer.@locked=="1");
			
			if (m_interactive)
			{
				if (m_eventName!="")
				{
					addEventListener(MouseEvent.CLICK, onClick);
					useHandCursor = true;
					buttonMode = true;
				}
			}
			
			var xmlData:XML;
			var playerId:int;
			if (XMLList(m_xmlPlayer.@hDataSrc).length()>0) // check if it's scene
			{
				var hDataSrc:int = m_xmlPlayer.@hDataSrc;
				if (m_recursiveLoadMap[hDataSrc]==true)
				{
					//M??? Alert.show("recursive load !!!");
					return; // recursive load
				}
				m_recursiveLoadMap[hDataSrc] = true;
				
				m_hPlayerData = i_xmlPlayer.@hDataSrc;
				var recPlayerData:Rec_player_data = m_dataBaseManager.table_player_data.getRecord(m_hPlayerData);
				if (recPlayerData!=null && recPlayerData.status!=3) // make sure the scene was not deleted.
				{
					var xmlPlayer:XML = new XML(recPlayerData.player_data_value);
					playerId = xmlPlayer.@player;
				
					m_xmlData = xmlPlayer.Data[0];
					
					if (XMLList(m_xmlPlayer.Data.Layout).length()>0)
					{
						delete m_xmlData.Layout;
						m_xmlData.appendChild(XML(m_xmlPlayer.Data.Layout[0]).copy());
					}
					
					createPlayer(playerId);
				}
				
				m_recursiveLoadMap[hDataSrc] = false;
			}
			else
			{
				if (XMLList(i_xmlPlayer.@player).length()>0)
				{
					playerId = i_xmlPlayer.@player;
					m_xmlData = m_xmlPlayer.Data[0];
					createPlayer(playerId);
			    }
				else
				{
					if (XMLList(i_xmlPlayer.Resource).length()>0)
					{
						m_xmlData = m_xmlPlayer.Data[0];
						createPlayerFromResource(i_xmlPlayer.Resource.@hResource);
					}
					else
					{
						clear();
					}
				}
			}
		}
		
		public function setDataProvider(i_dataProvider:IDataProvider, i_providerItem:String=null):void
		{
			m_dataProvider = i_dataProvider;
			m_providerItem = i_providerItem;
			if (m_dataProvider!=null && player!=null && player is IProviderItem)
			{
				IProviderItem(player).setDataProvider(m_dataProvider, m_providerItem);
			}			
		}
		
		public override function ready(i_child:UIComponent):void
		{
			super.ready(i_child);
			if (player==null)
				return;
			
			player.playerLoader = this;
			if (m_xmlData!=null)
			{
				loadEffects(m_xmlData);
				player.load(m_xmlData);
				loadEventCommands(m_xmlData);
				m_xmlData = null;
			}
			
			if (m_dataProvider!=null && (player is IProviderItem))
			{
				IProviderItem(player).setDataProvider(m_dataProvider, m_providerItem);
			}
			
			if (m_requestStart)
			{
				m_requestStart = false;
				start();
			}
			if (isNaN(m_requestSeek)==false)
			{
				seek = m_requestSeek;
				m_requestSeek = NaN;
			}
			
			dispatchEvent( new Event("event_player_ready"));
		}
		
		public function save():XML
		{
			var xmlPlayer:XML = <Player/>;
		
			if (m_playerId!=-1)
			{
				xmlPlayer.@player = m_playerId;
				xmlPlayer.@label = m_label;
			}
			else
			{
				var xmlResource:XML = <Resource/>;
				xmlResource.@hResource = m_hResource;
				xmlPlayer.appendChild(xmlResource);
			}
			
			if (m_eventName!=null && m_eventName!="")
			{
				xmlPlayer.@name = m_eventName;
			}
			xmlPlayer.@interactive = m_interactive ? "1" : "0";
						
			if (m_mimeType!=null && m_mimeType!="")
			{
				xmlPlayer.@mimeType = m_mimeType;
			}
			
			if (m_locked)
			{
				xmlPlayer.@locked = "1";
			}
			
			var xmlData:XML = <Data/>;
			var prop:IEffect;
			xmlPlayer.appendChild(xmlData);
			
			var xmlEventCommands:XML = saveEventCommands();
			if (xmlEventCommands!=null)
			{
				xmlData.appendChild(xmlEventCommands);
			}
			
			if (XMLList(m_xmlPlayer.@hDataSrc).length()>0)
			{
				xmlPlayer.@hDataSrc = m_xmlPlayer.@hDataSrc;
				prop = m_playerEffectMap[PlayerPosAndSize];
				if (prop!=null) //M??? why it null?
				{
					xmlData.appendChild(prop.save());
				}
			}
			else
			{
				for each(prop in m_playerEffectMap)
				{
					xmlData.appendChild(prop.save());
				}
				
				if (player!=null)
				{
					xmlData.appendChild(player.save());
				}
			}
			
			
			return xmlPlayer;
		}
		
		public function set parentPlayerLoader(i_parentPlayerLoader:IPlayerLoader):void
		{
			m_parentPlayerLoader = i_parentPlayerLoader;
		}

		public function get parentPlayerLoader():IPlayerLoader
		{
			return m_parentPlayerLoader;
		}
		
		public function set modified(i_modified:Boolean):void
		{
			m_modified = i_modified;
			if (m_parentPlayerLoader!=null && i_modified)
			{
				m_parentPlayerLoader.modified = true;
			}
		}
		
		public function get modified():Boolean
		{
			return m_modified; 
		}
		
		
		public function start():void
		{
			if (player==null)
			{
				m_requestStart = true;
				return;
			}
			player.start();
			for each(var prop:IEffect in m_playerEffectMap)
			{ 
				prop.start();
			}
		}
		
		public function stop():void
		{
			if (player==null)
			{
				m_requestStart = false;
				m_requestSeek = NaN;
				return;
			}
			player.stop();
			for each(var prop:IEffect in m_playerEffectMap)
			{
				prop.stop();
			}
		}

		public function pause():void
		{
			if (player==null)
				return;
			
			player.pause();
			for each(var prop:IEffect in m_playerEffectMap)
			{
				prop.pause();
			}
		}
		
		public function onFrame(i_time:Number):void
		{
			try
			{
				if (player==null)
					return;
				
				m_time = i_time;
				m_filters = [];
				player.onFrame(i_time);
				for each(var prop:IEffect in m_playerEffectMap)
				{
					prop.onFrame(i_time);
				}
				filters = m_filters;
			}
			catch(error:Error)
			{
				m_debugLog.addInfo("PlayerLoader.onFrame()\n   label=" + m_label + "\n  m_hPlayerData=" + m_hPlayerData.toString());
				m_debugLog.addException(error);
			}			
		}
		
		public function refresh():void
		{
			for each(var prop:IEffect in m_playerEffectMap)
			{
				prop.enableEffect();
			}
			onFrame(m_time);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();	
			if (m_autoDispose)
				addEventListener(FlexEvent.REMOVE, onRemove);
		}
		
		

		private function onRemove(event:FlexEvent):void
		{
			if (m_autoDispose)
			{
				removeEventListener(FlexEvent.REMOVE, onRemove);
			}
			
			dispose();
		}

		public function dispose():void
		{
			if (m_disposed==false)
			{
				m_disposed = true;
				onDispose();
			}
		}
		
		protected function onDispose():void
		{
			clear();
		}
		
		
/////////////////////////////
		private function loadEventCommands(i_xmlData:XML):void
		{
			if (XMLList(i_xmlData.EventCommands).length()>0)
			{
				m_eventHandlers = new ArrayCollection();
				for each(var xmlEventCommand:XML in i_xmlData.EventCommands.*)
				{
					var eventHandler:PlayerEventHandler = new PlayerEventHandler(m_playerEventService, this);
					eventHandler.load(xmlEventCommand);
					m_eventHandlers.addItem(eventHandler);
					if (m_playerEventService!=null)
					{
						m_playerEventService.registerEventHandler(eventHandler);
					}
				}
				m_eventHandlers.addEventListener(CollectionEvent.COLLECTION_CHANGE, onEventCommandsChange);
				 
			}
		}
		
		
		private function saveEventCommands():XML
		{
			if (m_eventHandlers==null)
				return null;
			
			var xmlEventCommands:XML = <EventCommands/>;
			for each(var eventHandler:PlayerEventHandler in m_eventHandlers.source)
			{
				var xmlEventCommand:XML = eventHandler.save();
				xmlEventCommands.appendChild(xmlEventCommand);				
			}
			return xmlEventCommands;
		}		
		
		
		
		
		
		
		
		private function loadEffects(i_data:XML):void
		{
			var xmlLayout:XML = XMLList(i_data.Layout)[0];
			m_filters = new Array();
			if (xmlLayout!=null && m_usePlayerLayout)
			{
				m_playerPosAndSize = new PlayerPosAndSize(this);
				m_playerEffectMap[PlayerPosAndSize] = m_playerPosAndSize;
				m_playerPosAndSize.load(xmlLayout);
			}
			
			var xmlAppearance:XML = XMLList(i_data.Appearance)[0];
			if (xmlAppearance!=null)
			{
				m_playerAppearance = new PlayerAppearance(this);
				m_playerEffectMap[PlayerAppearance] = m_playerAppearance;
				m_playerAppearance.load(xmlAppearance);
			}	
			
			var xmlBorder:XML = XMLList(i_data.Border)[0];
			if (xmlBorder!=null)
			{
				m_playerBorder = new PlayerBorder(this);
				m_playerEffectMap[PlayerBorder] = m_playerBorder;
				m_playerBorder.load(xmlBorder);
			}	

			var xmlBackground:XML = XMLList(i_data.Background)[0];
			if (xmlBackground!=null)
			{
				m_playerBackground = new PlayerBackground(this);
				m_playerEffectMap[PlayerBackground] = m_playerBackground;
				m_playerBackground.load(xmlBackground);
			}

			var xmlGlow:XML = XMLList(i_data.Glow)[0];
			if (xmlGlow!=null)
			{
				m_playerGlow = new PlayerGlow(this);
				m_playerEffectMap[PlayerGlow] = m_playerGlow;
				m_playerGlow.load(xmlGlow);
			}
			
			var xmlBlur:XML = XMLList(i_data.Blur)[0];
			if (xmlBlur!=null)
			{
				m_playerBlur = new PlayerBlur(this);
				m_playerEffectMap[PlayerBlur] = m_playerBlur;
				m_playerBlur.load(xmlBlur);
			}
			
			var xmlShadow:XML = XMLList(i_data.Shadow)[0];
			if (xmlShadow!=null)
			{
				m_playerShadow = new PlayerShadow(this);
				m_playerEffectMap[PlayerShadow] = m_playerShadow;
				m_playerShadow.load(xmlShadow);
			}	
			filters = m_filters;
		}
		
		public function clearEffects():void
		{
			for each(var prop:IEffect in m_playerEffectMap)
			{
				prop.clear();
			}
			
			m_playerPosAndSize = null;
			m_playerAppearance = null;
			m_playerBorder = null;
			m_playerBackground = null;
			m_playerGlow = null;
			m_playerBlur = null;
			m_playerShadow = null;
			
			m_playerEffectMap = new Dictionary();
		}
		
		public function get seek():Number
		{
			return 0; //???
		}
		
		public function set seek(i_seek:Number):void
		{
			for each(var prop:IEffect in m_playerEffectMap)
			{
				prop.seek = i_seek;
			}
		}
		
		public function get playerPosAndSize():PlayerPosAndSize
		{
			return m_playerPosAndSize;
		}

		public function createPlayerPosAndSize(i_enabled:Boolean):void
		{ 
			if (i_enabled)
			{
				m_playerPosAndSize = new PlayerPosAndSize(this);
				m_playerEffectMap[PlayerPosAndSize] = m_playerPosAndSize;
			}
			else
			{
				if (m_playerPosAndSize!=null)
				{
					m_playerPosAndSize.clear();
					m_playerPosAndSize = null;
					delete m_playerEffectMap[PlayerPosAndSize];
				}
			}
			modified = true;
		}
		
		public function createPlayerAppearance(i_enabled:Boolean):void
		{ 
			if (i_enabled)
			{
				m_playerAppearance = new PlayerAppearance(this);
				m_playerEffectMap[PlayerAppearance] = m_playerAppearance;
			}
			else
			{
				if (m_playerAppearance!=null)
				{
					m_playerAppearance.clear();
					m_playerAppearance = null;
					delete m_playerEffectMap[PlayerAppearance];
				}
			}
			modified = true;
		}
		
		public function get playerAppearance():PlayerAppearance
		{ 
			return m_playerAppearance;
		}

		public function createPlayerBorder(i_enabled:Boolean):void
		{ 
			if (i_enabled)
			{
				m_playerBorder = new PlayerBorder(this);
				m_playerEffectMap[PlayerBorder] = m_playerBorder;
			}
			else
			{
				if (m_playerBorder!=null)
				{
					m_playerBorder.clear();
					m_playerBorder = null;
					delete m_playerEffectMap[PlayerBorder];
				}
			}
			modified = true;
		}
		
		public function get playerBorder():PlayerBorder
		{ 
			return m_playerBorder;
		}
		
		public function createPlayerBackground(i_enabled:Boolean):void
		{
			if (i_enabled)
			{
				m_playerBackground = new PlayerBackground(this);
				m_playerEffectMap[PlayerBackground] = m_playerBackground;
			}
			else
			{
				if (m_playerBackground!=null)
				{
					m_playerBackground.clear();
					m_playerBackground = null;
					delete m_playerEffectMap[PlayerBackground];
				}
			}
			modified = true;
		}
		
		public function get playerBackground():PlayerBackground
		{ 
			return m_playerBackground;
		}

		public function createPlayerGlow(i_enabled:Boolean):void
		{ 
			if (i_enabled)
			{
				m_playerGlow = new PlayerGlow(this);
				m_playerEffectMap[PlayerGlow] = m_playerGlow;
			}
			else
			{
				if (m_playerGlow!=null)
				{
					m_playerGlow.clear();
					m_playerGlow = null;
					delete m_playerEffectMap[PlayerGlow];
				}
			}
			modified = true;
		}
		
		public function get playerGlow():PlayerGlow
		{ 
			return m_playerGlow;
		}

		public function createPlayerBlur(i_enabled:Boolean):void
		{ 
			if (i_enabled)
			{
				m_playerBlur = new PlayerBlur(this);
				m_playerEffectMap[PlayerBlur] = m_playerBlur;
			}
			else
			{
				if (m_playerBlur!=null)
				{
					m_playerBlur.clear();
					m_playerBlur = null;
					delete m_playerEffectMap[PlayerBlur];
				}
			}
			modified = true;
		}
		
		public function get playerBlur():PlayerBlur
		{ 
			return m_playerBlur;
		}

		public function createPlayerShadow(i_enabled:Boolean):void
		{ 
			if (i_enabled)
			{
				m_playerShadow = new PlayerShadow(this);
				m_playerEffectMap[PlayerShadow] = m_playerShadow;
			}
			else
			{
				if (m_playerShadow!=null)
				{
					m_playerShadow.clear();
					m_playerShadow = null;
					delete m_playerEffectMap[PlayerShadow];
				}
			}
			modified = true;
		}
		
		public function get playerShadow():PlayerShadow
		{ 
			return m_playerShadow;
		}
	}
}
