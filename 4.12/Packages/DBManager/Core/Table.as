package
{
	import flash.utils.Dictionary;
	
	public class Table
	{
		protected var m_dataBaseManager:DataBaseManager;
		protected var m_name:String
		protected var m_fields:Array;
		
		private var m_fieldDefinitions:Array = new Array();  // [fieldName] = FeildDefinition
		private var m_primaryField:String  
		
		//private var m_Id2Record:Dictionary 			= new Dictionary();
		private var m_Id2Handle:Dictionary 			= new Dictionary();
		
		private var m_originalRecords:OrderedMap 	= new OrderedMap();
		private var m_modifiedRecords:OrderedMap 	= new OrderedMap();
		private var m_deletedRecords:OrderedMap 	= new OrderedMap();
		private var m_conflictRecords:OrderedMap 	= new OrderedMap();
		private var m_newRecords:OrderedMap 		= new OrderedMap();
		
		private var m_lastHandle:int = 0;
		
		public function Table(i_dataBaseManager:DataBaseManager)
		{
			m_dataBaseManager = i_dataBaseManager;
		}
		
		public function get Name():String { return m_name; }
		
		public function get Fields():Array { return m_fields; }
		
/*		
		public function requestData():void
		{
			m_dataBaseManager.RequestData(m_name, "");
		}
*/
		public function createRecord():Record
		{
			return null;
		}


		public function cloneRecord(i_hSrcHanlde:int):Record
		{
			var srcRecord:Record = getRec(i_hSrcHanlde);
			var newRecord:Record = createRecord();
			for each(var field:Object in m_fields)
			{
				newRecord[field.field] = srcRecord[field.field]
			}
			return newRecord;
		}
		
		public function duplicateRecord(i_hSrcHanlde:int):Record
		{
			var newRecord:Record = cloneRecord(i_hSrcHanlde);
			addRecord(newRecord);
			return newRecord;
		}
		
		public function addRecord(i_record:Record, i_handle:int = -1):void
		{
			var handle:int = (i_handle==-1) ? getHandle(-1) : i_handle;
			m_newRecords.add(handle, i_record);
			i_record.status = 2;
			i_record[m_fields[0].field] = handle;
		}

		public function addData(i_xmlData:XML):void
		{
			var field:String;
			var foriegn:String;
			var value:Object;
			var foriegnTable:Table;
			var handle:int;
			var pk:Boolean;
			var newRec:Record;
			var id:int;
			
			for each(var xmlRec:XML in i_xmlData.*)
			{
				pk = true;
				var i:int = 0;
				for each(var data:XML in xmlRec.*)
				{
					// case Dev add new field to DB bug application is old version.
					if (i >= m_fields.length)  
						break;
						
					field 		= m_fields[i].field;
					foriegn		= m_fields[i].foriegn;
					value = data.toString();
					
					if (pk)
					{
						pk=false;
						id = int(value);
						 
						if (foriegn!=null && foriegn!=m_name)
						{
							foriegnTable = m_dataBaseManager.getTable(foriegn);
							handle = foriegnTable.getHandle(int(value));
						}
						else
						{
							handle = getHandle(int(value));
						}
						newRec = createRecord();
						newRec[field] = handle
						newRec.native_id = int(value);
					}
					else
					{
						if (foriegn!=null)
						{
							foriegnTable = m_dataBaseManager.getTable(foriegn);
							newRec[field] = (value!="") ? foriegnTable.getHandle(int(value)) : -1;
						}
						else
						{
							if (newRec[field] is Date)
							{
								var date:Date = new Date();
								newRec[field] = date;
								date.setTime( Date.parse(value) );
							}
							else if (newRec[field] is Boolean)
							{
								newRec[field] = (value=="True");
							}
							else
							{
								newRec[field] = value;
							}		
						}
					}
					i++;
				}
				
				
				
				var existRec:Record = getRec(handle);
				if (existRec==null)
				{
					if (newRec.change_type!=3)
					{
						m_originalRecords.add(handle, newRec);
					}
					else
					{
						//trace("recored deleted");
					}
				}
				else
				{
					if (newRec.changelist_id>existRec.changelist_id)
					{
						if (newRec.change_type==3) // new recode was deleted.
						{
							if (existRec.status==0) // wasn't changed.
							{
								m_originalRecords.remove(handle);
								m_modifiedRecords.remove(handle);
								m_deletedRecords.remove(handle);
							}
							else
							{
								existRec.conflict = true;
								newRec.conflict = true;
								m_conflictRecords.add(handle, newRec);
							}
							
						}
						else
						{
							if (existRec.status==0) // wasn't changed.
							{
								m_originalRecords.add(handle, newRec);
							}
							else
							{
								existRec.conflict = true;
								newRec.conflict = true;
								m_conflictRecords.add(handle, newRec);
							}
						}
					}
				}
			}
		}



		public function existId(i_id:int):Boolean
		{
			return m_Id2Handle[i_id]!=null;
		}

		public function getHandle(i_id:int):int
		{
			var handle:Object = m_Id2Handle[i_id];
			if (handle==null)
			{
				handle = m_lastHandle;
				m_lastHandle++;
				if (i_id!=-1)
					m_Id2Handle[i_id] = handle;
			}
			return int(handle);
		}	
		
		public function setRecordId(i_handle:int, i_id:int):void
		{
			m_Id2Handle[i_id] = i_handle;
		} 
		
		public function getRec(i_handle:int):Record
		{
			if (m_deletedRecords.getValue(i_handle)!=null)
				return m_deletedRecords.getValue(i_handle) as Record;
			else if (m_newRecords.getValue(i_handle)!=null)
				return m_newRecords.getValue(i_handle) as Record;
			else if (m_modifiedRecords.getValue(i_handle)!=null)
				return m_modifiedRecords.getValue(i_handle) as Record;
			else if (m_originalRecords.getValue(i_handle)!=null)
				return m_originalRecords.getValue(i_handle) as Record;
			return null;
		}

		public function getOriginalRec(i_handle:int):Record
		{
			return m_originalRecords.getValue(i_handle) as Record;
		}

		public function getModifiedRec(i_handle:int):Record
		{
			return m_modifiedRecords.getValue(i_handle) as Record;
		}

		public function getConflictRec(i_handle:int):Record
		{
			return m_conflictRecords.getValue(i_handle) as Record;
		}
		
		public function getKeysByFK(i_keyName:String, i_includeDeleted:Boolean=false):Dictionary
		{
			var fkMap:Dictionary = new Dictionary();
			var handle:int;
			var rec:Record;
			var fk:int;
			var list:Array;
			var index:int;
			var count:int;
			count = m_originalRecords.count;
			for(index=0; index<count; index++)
			{
				handle = int(m_originalRecords.getKeyAt(index));
				rec = getRec(handle);
				fk = rec[i_keyName];
				list = fkMap[fk];
				if (list==null)
				{
					list = fkMap[fk] = new Array();
				}
				list.push(handle);
			}
			
			
			count = m_newRecords.count;
			for(index=0; index<count; index++)
			{
				handle = int(m_newRecords.getKeyAt(index));
				rec = getRec(handle);
				fk = rec[i_keyName];
				list = fkMap[fk];
				if (list==null)
				{
					list = fkMap[fk] = new Array();
				}
				list.push(handle);
			}
			if (i_includeDeleted)
			{
				count = m_deletedRecords.count;
				for(index=0; index<count; index++)
				{
					handle = int(m_deletedRecords.getKeyAt(index));
					rec = getRec(handle);
					fk = rec[i_keyName];
					list = fkMap[fk];
					if (list==null)
					{
						list = fkMap[fk] = new Array();
					}
					list.push(handle);
				}
			}
			return fkMap;
		}
		
		public function getAllPrimaryKeys():Array
		{
			var primaryKeys:Array = new Array();
			m_originalRecords.concatinateKeys(primaryKeys);
			m_newRecords.concatinateKeys(primaryKeys);
			return primaryKeys;
		}
		
		public function getNewPrimaryKeys():Array
		{
			var primaryKeys:Array = new Array();
			m_newRecords.concatinateKeys(primaryKeys);
			return primaryKeys;
		}
		
		public function getModifyPrimaryKeys():Array
		{
			var primaryKeys:Array = new Array();
			m_modifiedRecords.concatinateKeys(primaryKeys);
			return primaryKeys;
		}

		public function getDeletedPrimaryKeys():Array
		{
			var primaryKeys:Array = new Array();
			m_deletedRecords.concatinateKeys(primaryKeys);
			return primaryKeys;
		}

		public function getConflictPrimaryKeys():Array
		{
			var primaryKeys:Array = new Array();
			m_conflictRecords.concatinateKeys(primaryKeys);
			return primaryKeys;
		}

		public function getChangedPrimaryKeys():Array
		{
			var primaryKeys:Array = new Array();
			m_newRecords.concatinateKeys(primaryKeys);
			m_modifiedRecords.concatinateKeys(primaryKeys);
			m_deletedRecords.concatinateKeys(primaryKeys);
			return primaryKeys;
		}
		
		public function openForEdit(i_handel:int):Boolean
		{
			if (m_deletedRecords.getValue(i_handel)!=null)
			{
				return false;
			}
			else if (m_newRecords.getValue(i_handel)!=null || m_modifiedRecords.getValue(i_handel)!=null)
			{
				return true;
			}
			else if (m_originalRecords.getValue(i_handel)!=null)
			{
				var modifiedRecord:Record = createRecord();
				var record:Record = m_originalRecords.getValue(i_handel) as Record;
				for each(var field:Object in m_fields)
				{
					modifiedRecord[field.field] = record[field.field]
				}
				modifiedRecord.native_id = record.native_id;
				modifiedRecord.status = 1;
				m_modifiedRecords.add(i_handel, modifiedRecord);
			}
			else
			{
				return false;
			}
			return true
		}
		
		public function openForDelete(i_handel:int):Boolean
		{
			m_newRecords.remove(i_handel);
			m_modifiedRecords.remove(i_handel);
			if (m_originalRecords.getValue(i_handel)!=null)
			{
				var record:Record = getRec(i_handel);
				record.status = 3;
				m_deletedRecords.add(i_handel, m_originalRecords.getValue(i_handel));
				m_originalRecords.remove(i_handel);
			}
			else
			{
				return false;
			}
			return true;
		}
		
		
		private function getPlayerDataIds(i_playerData:String):String
		{
			var xmlPlayerData:XML = new XML(i_playerData);
			
			convertToIds(xmlPlayerData);
			
			return xmlPlayerData.toXMLString();
		}
		
		private function convertToIds(i_xmlField:XML):void
		{
			var resourceList:XMLList = i_xmlField..Resource;
			for each(var xmlResource:XML in resourceList)
			{
			    if (XMLList(xmlResource.@hResource).length()>0)
			    {
					var hResource:int = int(xmlResource.@hResource);
					var record2:Record = m_dataBaseManager.table_resources.getRec(hResource);
					if (record2!=null)
					{
						xmlResource.@resource = record2.native_id;
					}
					else
					{
						trace("resource does not exist anymore");
					}
			    }
			}
			
			createPlayId(i_xmlField);
			var playerList:XMLList = i_xmlField..Player;
			for each(var xmlPlayer:XML in playerList)
			{
				createPlayId(xmlPlayer);
			}


			var categoryList:XMLList = i_xmlField..Category;
			for each(var xmlCategory:XML in categoryList)
			{
			    if (XMLList(xmlCategory.@handle).length()>0)
			    {
					var hCategory:int = int(xmlCategory.@handle);
					var recCategoryValue:Record = m_dataBaseManager.table_category_values.getRec(hCategory);
					xmlCategory.@id = recCategoryValue.native_id;
			    }
			}
		}

		private function createPlayId(i_xmlPlayer:XML):void
		{
			if (XMLList(i_xmlPlayer.@hDataSrc).length()>0)
			{
				var hDataSrc:int = int(i_xmlPlayer.@hDataSrc);
				var record2:Record = m_dataBaseManager.table_player_data.getRec(hDataSrc);
				i_xmlPlayer.@src = (record2!=null) ? record2.native_id : -1;
			}
		}

		public function appendModifyAndNewChangelist(i_xmlChangelist:XML):void
		{
			var xmlTable:XML = <Table/>;
			xmlTable.@name = m_name;

			var key:int;
			var record:Record;
			var xmlRec:XML;
			var xmlCol:XML;
			var field:Object;
			var pk:int;
			var foriegnTable:Table;
			var record2:Record;
			var value:Object;
			var date:Date;
			var modifyKeys:Array = getModifyPrimaryKeys();
			if (modifyKeys.length>0)
			{
				var xmlUpdate:XML = <Update/>;
				xmlTable.appendChild(xmlUpdate);
				for each(key in modifyKeys)
				{
					xmlRec = <Rec/>;
					xmlUpdate.appendChild(xmlRec);
					record = getRec(key);
					xmlRec.@[m_fields[0].field] = record[m_fields[0].field];
					for each(field in m_fields)
					{
						if (field.field==m_fields[0].field) // primary key
						{
							value = record.native_id;
						}
						else if (field.foriegn!=null)
						{
							xmlRec.@[field.field] = record[field.field];
							foriegnTable = m_dataBaseManager.getTable(field.foriegn);
							if (record[field.field]!=-1)
							{
								record2 = foriegnTable.getRec( record[field.field] );
								if (record2!=null)
								{
									value = record2.native_id;
								}
								else
								{
									value = null;  // fix 0000537: Renaming campaign casues an exception  (forien key 'kiosk_timeline_id' not exist anymore)
								}
							}
							else
							{
								value = null;
							}
						}
						else
						{
							if (record[field.field] is Date)
							{
								date = record[field.field] as Date;
								value = date.fullYear+"-"+(date.month+1)+"-"+date.date.toString();
							}
							else if ((m_name=="player_data" && field.field=="player_data_value") ||
									(m_name=="campaign_timeline_chanel_players" && field.field=="player_data") ||
									(m_name=="campaign_channel_players" && field.field=="player_data") )
							{
								value = getPlayerDataIds(record[field.field]);
								record[field.field] = value;
							}
							else
							{
								value = record[field.field];
							}
						}
						xmlCol = <Col>{value}</Col>;
						
						xmlRec.appendChild(xmlCol);
					} 
				}
			} 
			var newKeys:Array = getNewPrimaryKeys();
			if (newKeys.length>0)
			{
				var xmlNew:XML = <New/>;
				xmlTable.appendChild(xmlNew);
				for each(key in newKeys)
				{
					xmlRec = <Rec/>;
					xmlNew.appendChild(xmlRec);
					record = getRec(key);
					xmlRec.@[m_fields[0].field] = record[m_fields[0].field];
					for each(field in m_fields)
					{
						if (field.field==m_fields[0].field) // primary key
						{
							value = record.native_id;
						}
						else if (field.foriegn!=null)
						{
							xmlRec.@[field.field] = record[field.field];
							foriegnTable = m_dataBaseManager.getTable(field.foriegn);
							if (record[field.field]!=-1)
							{
								record2 = foriegnTable.getRec( record[field.field] );
								value = (record2!=null) ? record2.native_id : -1;
							}
							else
							{
								value = null;
							}
						}
						else
						{
							if (record[field.field] is Date)
							{
								date = record[field.field] as Date;
								value = date.fullYear+"-"+(date.month+1)+"-"+date.date.toString(); 
							}
							else if ((m_name=="player_data" && field.field=="player_data_value") ||
									(m_name=="campaign_timeline_chanel_players" && field.field=="player_data") ||
									(m_name=="campaign_channel_players" && field.field=="player_data") )
							{
								value = getPlayerDataIds(record[field.field]);
							}
							else
							{
								value = record[field.field];
							}
						}
						xmlCol = <Col>{value}</Col>;
						xmlRec.appendChild(xmlCol);
					} 					
				}
			}
			if (modifyKeys.length>0 || newKeys.length>0)
			{
				var xmlFlields:XML = <Fields/>;
				xmlTable.appendChild(xmlFlields);
				for each(field in m_fields)
				{
					var xmlField:XML = <Field>{field.field}</Field>;
					if (field.pk!=null)
					{
						xmlField.@pk = field.pk;
					}
					xmlFlields.appendChild(xmlField);
				}
			}
			
			if (xmlTable.children().length()>0)
			{
				i_xmlChangelist.appendChild(xmlTable);
				
			}
		}
		
		
		public function appendDeletedChangelist(i_xmlChangelist:XML):void
		{
			var xmlTable:XML = <Table/>;
			xmlTable.@name = m_name;

			var key:int;
			var record:Record;
			var xmlRec:XML;
			var xmlCol:XML;
			var field:Object;
			var pk:int;
			var foriegnTable:Table;
			var record2:Record;
			var value:Object;
			var date:Date;
			var deletedKeys:Array = getDeletedPrimaryKeys();
			if (deletedKeys.length>0)
			{
				var xmlDelete:XML = <Delete/>;
				xmlTable.appendChild(xmlDelete);
				for each(key in deletedKeys)
				{
					xmlRec = <Rec/>;
					xmlDelete.appendChild(xmlRec);
					record = getRec(key);
					xmlRec.@pk = record.native_id;
				}
			}
			
			if (deletedKeys.length>0)
			{
				var xmlFlields:XML = <Fields/>;
				xmlTable.appendChild(xmlFlields);
				for each(field in m_fields)
				{
					var xmlField:XML = <Field>{field.field}</Field>;
					xmlFlields.appendChild(xmlField);
				}
			}
			
			if (xmlTable.children().length()>0)
			{
				i_xmlChangelist.appendChild(xmlTable);
				
			}
		}
		


		public function revert(i_handel:int):Boolean
		{
			if (m_deletedRecords.getValue(i_handel)!=null)
			{
				var record:Record = m_deletedRecords.getValue(i_handel) as Record;
				if (record.native_id!=-1)
					m_originalRecords.add(i_handel, m_deletedRecords.getValue(i_handel)); 
				m_deletedRecords.remove(i_handel);
			}
			else if (m_newRecords.getValue(i_handel)!=null)
			{
				m_newRecords.remove(i_handel);
			}
			else if (m_modifiedRecords.getValue(i_handel)!=null)
			{
				m_modifiedRecords.remove(i_handel);
			}
			else
			{		
				return false;
			}
			return true;
		}

		public function commitChanges(i_changelistId:int):void
		{
			var handle:int;
			var record:Record;
			var newKeys:Array = getNewPrimaryKeys();
			for each(handle in newKeys)
			{
				record = m_newRecords.getValue(handle) as Record;
				record.status = 0;
				record.change_type = 2;
				record.changelist_id = i_changelistId; 
				m_originalRecords.add(handle, record);  
				m_newRecords.remove(handle);
			}

			var modifyKeys:Array = getModifyPrimaryKeys();
			for each(handle in modifyKeys)
			{
				record = m_modifiedRecords.getValue(handle) as Record;
				record.status = 0;
				record.change_type = 1;
				record.changelist_id = i_changelistId; 
				m_originalRecords.add(handle, record);  
				m_modifiedRecords.remove(handle);
			}

			var deletedKeys:Array = getDeletedPrimaryKeys();
			for each(handle in deletedKeys)
			{
				record = m_deletedRecords.getValue(handle) as Record;
				if (record!=null && record.native_id!=-1)
				{
					delete m_Id2Handle[record.native_id];
				}
				m_deletedRecords.remove(handle);
				m_originalRecords.remove(handle); // (??? check if do need for this line)
			}
		}
		
		public function getBrokenRecords():Array
		{
			var brokenRecords:Array = new Array();
			/*
			var keys:Array = getAllPrimaryKeys();
			var handle:int;
			var record:Record;
			for each(handle in m_Id2Handle)
			{
				record = getRec(handle);
				if (record==null)
				{
					brokenRecord.push(handle);
				}
			}
			*/
			
			
			var keys:Array = getAllPrimaryKeys();
			for each(var handle:int in keys)
			{
				var record:Record = getRec(handle);
				for each(var field:Object in m_fields)
				{
					if (field.foriegn!=null)
					{
						var frHandle:int = record[field.field];
						if (frHandle!=-1)
						{
							var frTable:Table = m_dataBaseManager.getTable(field.foriegn);
							if (field.isNullAble==false)
							{
								var frRec:Record = frTable.getRec(frHandle);
								if (frRec==null)
								{
									var brokenRecord:Object = new Object();
									brokenRecord.handle = handle;
									brokenRecord.brokenField = field.field;
									brokenRecords.push(brokenRecord);
								}
							}
						}
					}
				}
			}
			
			return brokenRecords;
		}
		
		
		public function getYours(i_handel:int):void
		{
			var existRec:Record = getRec(i_handel);
			if (existRec!=null)
			{
				existRec.conflict = false;
			}			
			m_conflictRecords.remove(i_handel);
		}

		public function getTheirs(i_handel:int):void
		{
			var theirs:Record = m_conflictRecords.getValue(i_handel) as Record;
			if (theirs!=null)
			{
				if (theirs.change_type==3)
				{
					m_originalRecords.remove(i_handel);
					m_modifiedRecords.remove(i_handel);
					m_deletedRecords.remove(i_handel);
				}
				else
				{
					m_modifiedRecords.add(i_handel, theirs);
				}
				m_conflictRecords.remove(i_handel);
			}
		}

/*
		protected function add(i_Record:IRecord):int
		{
			var primaryKey:int = -1;
			if (i_Record.Id!=-1) // Record Exist in DB
			{
				if (m_Id2Record[i_Record.Id]==null) // First time sync
				{
					primaryKey = m_lastprimaryKey;
					m_Id2primaryKey[i_Record.Id] = primaryKey;
					m_Id2Record[i_Record.Id] = i_Record;
					m_originalRecords.add(primaryKey, i_Record);
					m_lastprimaryKey++;
				}
				else // Second Time sync
				{
					primaryKey = m_Id2primaryKey[i_Record.Id];
					var record:IRecord = m_originalRecords.getValue(primaryKey);
					if (!record.IsEqual(i_Record))
					{
						m_conflictRecords.add(primaryKey, i_Record);
					}
				}
			}
			else // New Record (not in DB)
			{
				primaryKey = m_lastprimaryKey;
				m_newRecords.add(primaryKey, i_Record);
				m_lastprimaryKey++;
				return primaryKey;
			}
			return primaryKey;
		}
		
		
		public function IsConflict(i_handel:int):Boolean
		{
			return m_conflictRecords.getValue(i_handel)!=null;
		}

		public function HasConflicts():Boolean
		{
			return false; //???
		}
		
		public function ResolveConflict(i_handel:int):Boolean
		{
			if (m_conflictRecords.getValue(i_handel)!=null)
			{
				var record1:IRecord = m_originalRecords.getValue(i_handel);
				var record2:IRecord = m_conflictRecords.getValue(i_handel);
				var resolved:Boolean = record1.Merge(record2);
				if (resolved)
					m_conflictRecords.remove(i_handel);
				return resolved;
			}
			return false;
		}
*/		
		
		public function clearAll():void
		{
			m_Id2Handle	= new Dictionary();
			
			m_originalRecords = new OrderedMap();
			m_modifiedRecords = new OrderedMap();
			m_deletedRecords = new OrderedMap();
			m_conflictRecords = new OrderedMap();
			m_newRecords = new OrderedMap();
			m_lastHandle = 0;
		}
	}
}

