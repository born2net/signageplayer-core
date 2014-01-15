package
{
	import flash.utils.Dictionary;
	

	public class DataModuleBase
	{
		internal var m_tables:Dictionary = new Dictionary();
		internal var m_tableList:Array;
		private var m_ready:Boolean = true;
		private var m_lastChangelist:int = -1;
		
		
		public function DataModuleBase()
		{
		}
		
		public function get lastChangelist():int
		{
			return m_lastChangelist;
		}
		
		public function set lastChangelist(i_lastChangelist:int):void
		{
			m_lastChangelist = i_lastChangelist;
		}
	
		public function getTable(i_table:String):Table
		{
			return m_tables[i_table];
		}
		
		public function getPrimaryToTableMap():Object
		{
			var fields:Dictionary = new Dictionary();
			for each(var table:Table in m_tables)
			{
				var field:String = table.Fields[0].field;
				var tableList:Array = fields[field];
				if (tableList==null)
				{
					fields[field] = tableList = new Array();
				}
				tableList.push(table);
			}
			return fields;
		}
		
		public function commitChanges(i_changelistId:int):void
		{
			for each(var table:Table in m_tables)
			{
				table.commitChanges(i_changelistId);
			}
		}


		public function getBrokenTables():Object
		{
			var brokenTables:Object = null;
			for each(var table:Table in m_tables)
			{
				var brokenRecord:Array = table.getBrokenRecords();
				if (brokenRecord.length>0)
				{ 
					if (brokenTables==null)
					{
						brokenTables = new Object();
					} 
					brokenTables[table.Name] = brokenRecord;
				}
			}
			return brokenTables;
		}
		
		public function getConflictTables():Object
		{
			var conflictTables:Object = null;
			for each(var table:Table in m_tables)
			{
				var conflictRecord:Array = table.getConflictPrimaryKeys();
				if (conflictRecord.length>0)
				{ 
					if (conflictTables==null)
					{
						conflictTables = new Object();
					}
					conflictTables[table.Name] = conflictRecord;
				}
			}
			return conflictTables;
		}
		
		public function getChangedRecords():Array
		{
			var changeList:Array = new Array();
			for each(var table:Table in m_tables)
			{
				var keys:Array = table.getChangedPrimaryKeys();
				for each(var handle:int in keys)
				{
					var changeRecord:Object = new Object();	
					changeRecord.tableName = table.Name;
					changeRecord.handle = handle;
					changeList.push(changeRecord);
				}
			}
			return changeList;
		}
		
		
   		public function getChangelist():XML
		{
			var reverseList:Array = new Array();
			for each(var sTable:String in m_tableList)
			{
				reverseList.push(sTable);
			} 
			reverseList.reverse();

			var xmlChangelist:XML = <Changelist/>;
			var table:String;
			for each(table in m_tableList)
			{
				getTable(table).appendModifyAndNewChangelist(xmlChangelist); 
			}
			
			for each(table in m_tableList)
			{
				getTable(table).appendDeletedChangelist(xmlChangelist); 
			}
			
			return xmlChangelist;
		}
		
		
		public function createFieldHandles(i_table:Table, i_field:String):void
		{
			var keys:Array = i_table.getAllPrimaryKeys();
			var record:Record;
			for each(var handle:int in keys)
			{
				record = i_table.getRec(handle);
				try
				{
					var xmlField:XML = new XML(record[i_field]);
					convertToHandels(xmlField);
					record[i_field] = xmlField.toXMLString();
				}
				catch(e:Error)
				{
					// ilegal XML format
				}
			}
		}
		
		private function convertToHandels(i_xmlField:XML):void
		{
			var resourceList:XMLList = i_xmlField..Resource;
			for each(var xmlResource:XML in resourceList)
			{
			    if (XMLList(xmlResource.@resource).length()>0)
			    {
					var resourceId:int = int(xmlResource.@resource);
					if (resourceId!=-1)
					{
						var hResource:int = getTable("resources").getHandle(resourceId);
						xmlResource.@hResource = hResource;
					}
			    }
			}
			
			createPlayHandle(i_xmlField);
			var playerList:XMLList = i_xmlField..Player;
			for each(var xmlPlayer:XML in playerList)
			{
				createPlayHandle(xmlPlayer);
			}
			
			
			var categoryList:XMLList = i_xmlField..Category;
			for each(var xmlCategory:XML in categoryList)
			{
			    if (XMLList(xmlCategory.@id).length()>0)
			    {
					var categoryId:int = int(xmlCategory.@id);
					if (categoryId!=-1)
					{
						var hCategory:int = getTable("category_values").getHandle(categoryId);
						xmlCategory.@handle = hCategory;
					}
			    }
			}
			
			
			
			
			
			
			var adLocalContentList:XMLList = i_xmlField..AdLocalContent;
			for each(var xmlAdLocalContent:XML in adLocalContentList)
			{
				if (XMLList(xmlAdLocalContent.@id).length()>0)
				{
					var adLocalContentId:int = int(xmlAdLocalContent.@id);
					if (adLocalContentId!=-1)
					{
						var hAdLocalContent:int = getTable("ad_local_contents").getHandle(adLocalContentId);
						
						xmlAdLocalContent.@handle = hAdLocalContent;
					}
				}
			}			
		}
		
		
		
		
		private function createPlayHandle(i_xmlPlayer:XML):void
		{
			if (XMLList(i_xmlPlayer.@src).length()>0)
			{
				var dataId:int = int(i_xmlPlayer.@src);
				if (dataId!=-1)
				{
					var dataSrc:int = getTable("player_data").getHandle(dataId);
					i_xmlPlayer.@hDataSrc = dataSrc;
				}
			}
		}
		
		
		public function clearAll():void
		{
			m_lastChangelist = -1;
			for each(var tableName:String in m_tableList)
			{
				var table:Table = getTable(tableName);
				table.clearAll();
			}
			
		}
	}
}

