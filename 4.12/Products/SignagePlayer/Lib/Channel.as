package
{
	import mx.collections.ArrayList;

	public class Channel implements IChannel
	{
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_debugLog:IDebugLog;
		
		
		protected var m_commonChannel:Boolean = false;
		protected var m_hChannel:int;
		protected var m_randomOrder:Boolean = false;
		protected var m_repeatToFit:Boolean = false;
		protected var m_fixedPlayerLength:Boolean = true;
		protected var m_checkForNext:Boolean = true;
		
		private var m_allPlayers:ArrayList = new ArrayList();
		private var m_activePlayers:ArrayList = new ArrayList();
		
		private var m_chanelViewers:Array = new Array();
		private var m_chanelPlayerIndex:int = -2;
		private var m_nextPlayerTime:Number = -1; 
		private var m_time:Number = 0;
		private var m_repeatDuration:Number;
		private var m_repeatStart:Number;
		private var m_repeatEnd:Number;
		private var m_sorted:Boolean = false;
		
		public function Channel(i_framework:IFramework) 
		{
			m_framework = i_framework;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			m_debugLog = m_framework.ServiceBroker.QueryService("DebugLog") as IDebugLog;
		}

		public function get commonChannel():Boolean
		{
			return m_commonChannel;
		}	
			
		public function get hChannel():int
		{
			return m_hChannel;
		}
		
		public function init(i_hChannel:int):void
		{
			m_hChannel = i_hChannel;
		}
		
		public function addPlayer(i_hPlayer:int, i_mouseChildren:Boolean, i_offsetTime:Number, i_playerDuration:Number, i_playerData:String, i_adLocalEnabled:Boolean, i_hAdLocalContent:int):void
		{
			var playerInfo:PlayerInfo = new PlayerInfo(i_hPlayer, i_mouseChildren, i_offsetTime * 1000, i_playerDuration * 1000, i_playerData, i_adLocalEnabled, i_hAdLocalContent);
			m_allPlayers.addItem(playerInfo);
		}
		
		
		
		
		public function sort():void
		{
			if (m_allPlayers.length==0)
				return; 
				
			if (m_randomOrder)
			{
				makeRandomOrder();
			}
			else if (m_sorted==false)
			{
				makeSortOrder();
				m_sorted = true;
			}
		}
		
		private function makeSortOrder():void
		{
			m_activePlayers = new ArrayList();
			var today:Date = new Date();
			var playerInfo:PlayerInfo;
			m_repeatDuration = 0;
			
			for(var i:int=0;i<m_allPlayers.length;i++)
			{
				playerInfo = m_allPlayers.getItemAt(i) as PlayerInfo;
				var add:Boolean = true;
				if (playerInfo.adLocalEnabled)
				{
					var recAdLocalContent:Rec_ad_local_content = m_dataBaseManager.table_ad_local_contents.getRecord(playerInfo.hAdLocalContent);
					if (recAdLocalContent.enabled)
					{
						var recAdLocalPackage:Rec_ad_local_package = m_dataBaseManager.table_ad_local_packages.getRecord(recAdLocalContent.ad_local_package_id);
						if (recAdLocalPackage.use_date_range)
						{
							if (today.time < recAdLocalPackage.start_date.time || today.time>recAdLocalPackage.end_date.time+86400000)
								add = false;
						}
					}
					else
					{
						add = false;
					}
				}
				if (add)
				{
					m_activePlayers.addItem(playerInfo);
				}
			}
				
			if (m_activePlayers.length>0)
			{
				m_activePlayers.source.sortOn("offsetTime", Array.NUMERIC);
				playerInfo = m_activePlayers.getItemAt(m_activePlayers.length-1) as PlayerInfo;
				m_repeatDuration = playerInfo.offsetTime + playerInfo.playerDuration;
			}
		}
		
		private function makeRandomOrder():void
		{
			m_activePlayers = new ArrayList();
			
			var today:Date = new Date();
			for(var i:int=0;i<m_allPlayers.length;i++)
			{
				var playerInfo:PlayerInfo = m_allPlayers.getItemAt(i) as PlayerInfo;
				var add:Boolean = true;
				if (playerInfo.adLocalEnabled)
				{
					var recAdLocalContent:Rec_ad_local_content = m_dataBaseManager.table_ad_local_contents.getRecord(playerInfo.hAdLocalContent);
					if (recAdLocalContent.enabled)
					{
						var recAdLocalPackage:Rec_ad_local_package = m_dataBaseManager.table_ad_local_packages.getRecord(recAdLocalContent.ad_local_package_id);
						if (recAdLocalPackage.use_date_range)
						{
							if (today.time < recAdLocalPackage.start_date.time || today.time>recAdLocalPackage.end_date.time+86400000)
								add = false;
						}
					}
					else
					{
						add = false;
					}
				}
				
				
				if (add)
				{
					
					var rnd:int = Number(Math.random()) * (m_activePlayers.length);
					m_activePlayers.addItemAt(playerInfo, rnd);
				}
			}
			
			m_repeatDuration = 0;
			for each(playerInfo in m_activePlayers.source)
			{
				playerInfo.offsetTime = m_repeatDuration; 
				var duration:Number = playerInfo.playerDuration;
				m_repeatDuration += duration;
			}
		}
		
		/////////////////////////
		
		public function start():void
		{
			sort();
			m_chanelPlayerIndex = -2;
			m_nextPlayerTime = -1; 
			m_repeatStart = 0;
			m_repeatEnd = m_repeatDuration;
		}
		
		public function stop():void
		{
			//m_hPlayer = -1;
		}
		
		
		// case 1: when screen devision changed.
		public function assignViewer(i_viewer:IViewer):void
		{
			m_chanelViewers.push(i_viewer);
			if (m_chanelPlayerIndex==-1)
				return;
				
			var playerInfo:PlayerInfo = m_activePlayers.getItemAt(m_chanelPlayerIndex) as PlayerInfo;
			if (playerInfo==null)
				return;
				
			i_viewer.load(playerInfo.hPlayer, playerInfo.playerData, m_time, (m_repeatStart + playerInfo.offsetTime), playerInfo.adLocalEnabled, playerInfo.hAdLocalContent);
			var kioskMode:Boolean = (m_framework.StateBroker.GetState("kioskMode") == true);
			i_viewer.mouseChildren = true; //M??? (kioskMode && playerInfo.mouseChildren);
		}
		
		public function unassignViewers():void
		{
			while(m_chanelViewers.length>0) //???
			{
				m_chanelViewers.shift();
			}
		}
		
		public function tick(i_time:Number):void
		{
			var tp:int = 0;
			try
			{
				m_time = i_time;
				var viewer:IViewer;
				var playerInfo:PlayerInfo;
				
				var next:Boolean = false;
				if (m_checkForNext)
				{
					tp = 1;
					if (m_time>m_nextPlayerTime)
					{
						tp = 2;
						next = true;
						if (m_fixedPlayerLength==false && m_chanelViewers.length>0) 
						{
							tp = 3;
							viewer = m_chanelViewers[0];
							tp = 4;
							if (viewer.playerLoader!=null && viewer.playerLoader.player.keepPlaying)
							{
								tp = 5;
								viewer.playerLoader.player.addEventListener(PlayerCompleteEvent.PLAYER_COMPLETE, onPlayerReady)
								tp = 6;
								viewer.playerLoader.player.keepPlaying = false;
								tp = 7;
								next = false;
								m_checkForNext = false;
							}
						}
					}
				}
				tp = 8;
				if (next)
				{
					tp = 9;
					playNext();
					tp = 10;
				}
				
				tp = 11;
				for each(viewer in m_chanelViewers)
				{
					viewer.tick(m_time); 
				}
				tp = 12;
			}
			catch(e:Error)
			{
				m_debugLog.addInfo("Channel.onEnterFrame() tp="+tp.toString());
				m_debugLog.addException(e);
			}
		}
		
		private function onPlayerReady(playerEvent:PlayerCompleteEvent):void
		{
			playerEvent.player.removeEventListener(PlayerCompleteEvent.PLAYER_COMPLETE, onPlayerReady)
			m_checkForNext = true;	
			playNext();
		}
		
		private function playNext():void
		{
			var tp:int = 0;
			try
			{
				var viewer:IViewer;
				var playerInfo1:PlayerInfo;
				
	
				m_chanelPlayerIndex++;
				tp=1;
				if (m_chanelPlayerIndex!=-1)
				{
					tp=2;
					if (m_chanelPlayerIndex<m_activePlayers.length)
					{
						playerInfo1 = m_activePlayers.getItemAt(m_chanelPlayerIndex) as PlayerInfo;
					}
					tp=3;
					if (playerInfo1==null) // end of last player
					{
						tp=4;
						if (m_randomOrder)
						{
							tp=5;
							makeRandomOrder();
							tp=6;
						}
						tp=7;
						if (m_fixedPlayerLength)
						{
							tp=8;
							m_repeatStart = m_repeatEnd; 
							m_repeatEnd += m_repeatDuration; 
							tp=9;
						}
						else
						{
							tp=10;
							m_repeatStart = m_time; 
							m_repeatEnd = m_time + m_repeatDuration; 
							tp=11;
						}
						tp=12;
						m_chanelPlayerIndex = 0;
						playerInfo1 = m_activePlayers.getItemAt(m_chanelPlayerIndex) as PlayerInfo;
						tp=13;
					}
					tp=14;
					var offset:Number = m_fixedPlayerLength ? (m_repeatStart+playerInfo1.offsetTime) : m_time; 
					tp=15;
					for each(viewer in m_chanelViewers)
					{
						tp=16;
						// don't reload player if it is the only one on the common channel
						if (viewer.commonChannel && viewer.hPlayer == playerInfo1.hPlayer) 
							continue;
						tp=17;
						// case: when player changed within sceen devision.
						viewer.load(playerInfo1.hPlayer, playerInfo1.playerData, offset, m_time, playerInfo1.adLocalEnabled, playerInfo1.hAdLocalContent);
						tp=18;
						var kioskMode:Boolean = (m_framework.StateBroker.GetState("kioskMode") == true);
						tp=19;
						viewer.mouseChildren = true; //M??? (kioskMode && playerInfo1.mouseChildren);
						tp=20;
					}
				}
				tp=21;
				// next player
				var playerInfo2:PlayerInfo;
				if (m_chanelPlayerIndex+1<m_activePlayers.length)
				{
					playerInfo2 = m_activePlayers.getItemAt(m_chanelPlayerIndex+1) as PlayerInfo;
				}
				tp=22;
				if (playerInfo2==null) // begining of last player
				{
					tp=23;
					m_nextPlayerTime = (m_repeatToFit && playerInfo1!=null) ?
						(m_fixedPlayerLength ? m_repeatEnd : m_nextPlayerTime + playerInfo1.playerDuration) :  
						100000000;  
					tp=24;
				}
				else				
				{
					tp=25;
					m_nextPlayerTime = (playerInfo1==null || m_fixedPlayerLength) ? (m_repeatStart + playerInfo2.offsetTime) : 
						m_nextPlayerTime + playerInfo1.playerDuration;
					tp=26;
				}
				tp=27;
			}
			catch(e:Error)
			{
				m_debugLog.addInfo("Channel.playNext() tp="+tp.toString());
				m_debugLog.addException(e);
			}
		}
		
		public function dispose():void
		{
			m_framework = null;	
			m_dataBaseManager = null;
			if (m_activePlayers!=null)
			{
				for each(var playerInfo:PlayerInfo in m_allPlayers)
				{
					playerInfo.dispose();
				}
				m_activePlayers = null;
			}
		}
	}
}

class PlayerInfo
{
	private var m_hPlayer:int;
	private var m_mouseChildren:Boolean;
	private var m_offsetTime:Number;
	private var m_playerDuration:Number;
	private var m_playerData:XML;
	private var m_adLocalEnabled:Boolean;
	private var m_hAdLocalContent:int;
	
	
	public function PlayerInfo(i_hPlayer:int, i_mouseChildren:Boolean, i_offsetTime:Number, i_playerDuration:Number, i_playerData:String, i_adLocalEnabled:Boolean, i_hAdLocalContent:int)
	{
		m_hPlayer = i_hPlayer;
		m_mouseChildren = i_mouseChildren;
		m_offsetTime = i_offsetTime;
		m_playerDuration = i_playerDuration;
		m_playerData = new XML(i_playerData);
		m_adLocalEnabled = i_adLocalEnabled;
		m_hAdLocalContent = i_hAdLocalContent;
	}
	
	public function get hPlayer():int
	{
		return m_hPlayer;
	}

	public function get mouseChildren():Boolean
	{
		return m_mouseChildren;
	}
	
	public function get offsetTime():Number
	{
		return m_offsetTime;
	}

	public function set offsetTime(i_offsetTime:Number):void
	{
		m_offsetTime = i_offsetTime;
	}
	
	public function get playerDuration():Number
	{
		return m_playerDuration;
	}
	
	public function get playerData():XML
	{
		return m_playerData;
	}
	
	public function get adLocalEnabled():Boolean
	{
		return m_adLocalEnabled;
	}
	
	public function get hAdLocalContent():int
	{
		return m_hAdLocalContent;
	}
	
	public function dispose():void
	{
	}
}
