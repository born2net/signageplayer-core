package
{
	import flash.utils.Dictionary;
	
	public class DataManager
	{
		protected var m_businessData:Object = new Object();
		protected var m_selectedDataBase:DataModuleBase;
		
		public function DataManager()
		{
		}
		
		public function createDataBase(i_businessDomain:String, i_businessId:int):DataModuleBase
		{
			var domainBusinessKey:String = i_businessDomain + "." + i_businessId;
			var dataBase:DataModuleBase = new DataModuleBase();
			m_businessData[domainBusinessKey] = dataBase;
			return dataBase;
		}
		
		public function getDataBase(i_businessDomain:String, i_businessId:int):DataModuleBase
		{
			var domainBusinessKey:String = i_businessDomain + "." + i_businessId;
			return m_businessData[domainBusinessKey]
		}

		public function setDataBase(i_businessDomain:String, i_businessId:int, i_dataModuleBase:DataModuleBase):void
		{
			var domainBusinessKey:String = i_businessDomain + "." + i_businessId;
			m_businessData[domainBusinessKey] = i_dataModuleBase;
		}
		
		public function selectDomainBusiness(i_businessDomain:String, i_businessId:int):void
		{
			var domainBusinessKey:String = i_businessDomain + "." + i_businessId;
			m_selectedDataBase = m_businessData[domainBusinessKey];
		}
		
		public function loadTables(i_xmlTables:XML):void
		{
			for each(var xmlTable:XML in i_xmlTables.*)
			{
				var table:Table = getTable(xmlTable.@name);
				table.addData(xmlTable);
			}
			createHandles();
		}
		
		public function createHandles():void
		{
			
		}
		
		public function get lastChangelist():int
		{
			return m_selectedDataBase.lastChangelist;
		}
		
		public function set lastChangelist(i_lastChangelist:int):void
		{
			m_selectedDataBase.lastChangelist = i_lastChangelist;
		}				
		
		public function getTable(i_table:String):Table
		{
			return m_selectedDataBase.getTable(i_table);
		}
		
		public function getPrimaryToTableMap():Object
		{
			return m_selectedDataBase.getPrimaryToTableMap();
		}
		
		public function commitChanges(i_changelistId:int):void
		{
			m_selectedDataBase.commitChanges(i_changelistId);
		}
		
		public function getBrokenTables():Object
		{
			return m_selectedDataBase.getBrokenTables();
		}

		public function getConflictTables():Object
		{
			return m_selectedDataBase.getConflictTables();
		}
		
		public function getChangedRecords():Array
		{
			return m_selectedDataBase.getChangedRecords();
		}
		
		public function getChangelist():XML
		{
			return m_selectedDataBase.getChangelist();
		} 
		
		protected function createFieldHandles(i_table:Table, i_field:String):void
		{
			m_selectedDataBase.createFieldHandles(i_table, i_field);
		} 
		
		public function clearAll():void
		{
			for each(var dataBase:DataModuleBase in m_businessData)
			{
				dataBase.clearAll();
			}
		}
	}
}