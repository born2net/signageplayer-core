package
{
	import flash.utils.Dictionary;

	public class PlayerDataService implements IPlayerDataService
	{
		private var m_framework:IFramework;
		private var m_dataBaseManager:DataBaseManager; 
		
	
		public function PlayerDataService(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
		}
		
		public function getNameFromHandle(i_hPlayerData:int):String
		{
			var label:String = "";
			var recPlayerData:Rec_player_data = m_dataBaseManager.table_player_data.getRecord(i_hPlayerData);
			if (recPlayerData!=null && recPlayerData.status!=3) // make sure the scene was not deleted.
			{
				var xmlPlayer:XML = new XML(recPlayerData.player_data_value);
				label = xmlPlayer.@label;			
			}
			return label;
		}
		
		
	}
}
