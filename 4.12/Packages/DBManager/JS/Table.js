function Table(i_dataBaseManager)
{
    this.m_dataBaseManager = i_dataBaseManager;
    this.m_name
    this.m_fields;
    this.m_fieldDefinitions = [];  // [fieldName] = FeildDefinition
    this.m_primaryField;
    this.m_Id2Handle = {};


    this.m_originalRecords 	= new OrderedMap();
    this.m_modifiedRecords 	= new OrderedMap();
    this.m_deletedRecords 	= new OrderedMap();
    this.m_conflictRecords 	= new OrderedMap();
    this.m_newRecords 		= new OrderedMap();

    this.m_lastHandle = 0;
}




Table.prototype.addData = function(i_xmlTable)
{
    var field;
    var foriegn;
    var value;
    var foriegnTable;
    var handle;
    var pk;
    var newRec;
    var id;




    for (var iRec in i_xmlTable.childNodes)
    {
        if (iRec=="item" || iRec=="iterator" || iRec=="length")
            continue;

        var xmlRec = i_xmlTable.childNodes[iRec]


        pk = true;
        var i = 0;

        for (var iData in xmlRec.childNodes)
        {
            if (iData=="item" || iData=="iterator" || iData=="length")
                continue;

            var data = xmlRec.childNodes[iData];

            // case Dev add new field to DB bug application is old version.
            if (i >= this.m_fields.length)
                break;

            field 		= this.m_fields[i].field;
            foriegn		= this.m_fields[i].foriegn;
            value       = data.textContent;

            if (pk)
            {
                pk=false;
                id = value;

                if (foriegn!=null && foriegn!=this.m_name)
                {
                    foriegnTable = this.m_dataBaseManager.getTable(foriegn);
                    handle = foriegnTable.getHandle(value);
                }
                else

                {
                    handle = this.getHandle(value);
                }
                newRec = this.createRecord();
                newRec[field] = handle
                newRec.native_id = value;
            }
            else
            {
                if (foriegn!=null)
                {
                    foriegnTable = this.m_dataBaseManager.getTable(foriegn);
                    newRec[field] = (value!="") ? foriegnTable.getHandle(value) : -1;
                }
                else
                {    /*
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
                else   */
                    {
                        newRec[field] = value;
                    }
                }
            }
            i++;
        }


        var existRec = this.getRec(handle);
        if (existRec==null)
        {
            if (newRec.change_type!=3)
            {
                this.m_originalRecords.add(handle, newRec);
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
                        this.m_originalRecords.remove(handle);
                        this.m_modifiedRecords.remove(handle);
                        this.m_deletedRecords.remove(handle);
                    }
                    else
                    {
                        existRec.conflict = true;
                        newRec.conflict = true;
                        this.m_conflictRecords.add(handle, newRec);
                    }

                }
                else
                {
                    if (existRec.status==0) // wasn't changed.
                    {
                        this.m_originalRecords.add(handle, newRec);
                    }
                    else
                    {
                        existRec.conflict = true;
                        newRec.conflict = true;
                        this.m_conflictRecords.add(handle, newRec);
                    }
                }
            }
        }

    }
}


Table.prototype.getHandle = function(i_id)
{
    var handle = this.m_Id2Handle[i_id];
    if (handle==null)
    {
        handle = this.m_lastHandle;
        this.m_lastHandle++;
        if (i_id!=-1)
            this.m_Id2Handle[i_id] = handle;
    }
    return handle;
}


Table.prototype.setRecordId = function (i_handle, i_id)
{
    this.m_Id2Handle[i_id] = i_handle;
}


Table.prototype.createRecord = function()
{
    return null;
}


Table.prototype.addRecord = function (i_record, i_handle)
{
    var handle = (i_handle==null) ? this.getHandle(-1) : i_handle;
    this.m_newRecords.add(handle, i_record);
    i_record.status = 2;
    i_record[this.m_fields[0].field] = handle;
}

Table.prototype.getRec = function(i_handle)
{
    if (this.m_deletedRecords.getValue(i_handle)!=null)
        return this.m_deletedRecords.getValue(i_handle);
else if (this.m_newRecords.getValue(i_handle)!=null)
    return this.m_newRecords.getValue(i_handle);
else if (this.m_modifiedRecords.getValue(i_handle)!=null)
    return this.m_modifiedRecords.getValue(i_handle);
else if (this.m_originalRecords.getValue(i_handle)!=null)
    return this.m_originalRecords.getValue(i_handle);
    return null;
}


Table.prototype.getAllPrimaryKeys = function()
{
    var primaryKeys = [];
    this.m_originalRecords.concatinateKeys(primaryKeys);
    this.m_newRecords.concatinateKeys(primaryKeys);
    return primaryKeys;
}


Table.prototype.openForEdit = function(i_handel)
{
    if (this.m_deletedRecords.getValue(i_handel)!=null)
    {
        return false;
    }
    else if (this.m_newRecords.getValue(i_handel)!=null || this.m_modifiedRecords.getValue(i_handel)!=null)
    {
        return true;
    }
    else if (this.m_originalRecords.getValue(i_handel)!=null)
    {
        var modifiedRecord = this.createRecord();
        var record = this.m_originalRecords.getValue(i_handel);
        for(var iField in this.m_fields)
        {
            var field =  this.m_fields[iField];
            modifiedRecord[field.field] = record[field.field]
        }
        modifiedRecord.native_id = record.native_id;
        modifiedRecord.status = 1;
        this.m_modifiedRecords.add(i_handel, modifiedRecord);
    }
    else
    {
        return false;
    }
    return true
}


Table.prototype.openForDelete = function(i_handel)
{
    this.m_newRecords.remove(i_handel);
    this.m_modifiedRecords.remove(i_handel);
    if (this.m_originalRecords.getValue(i_handel)!=null)
    {
        var record = this.getRec(i_handel);
        record.status = 3;
        this.m_deletedRecords.add(i_handel, this.m_originalRecords.getValue(i_handel));
        this.m_originalRecords.remove(i_handel);
    }
    else
    {
        return false;
    }
    return true;
}


Table.prototype.appendModifyAndNewChangelist = function(i_doc)
{
    self = this;
    var xmlTable = i_doc.createElement("Table");
    xmlTable.setAttribute("name", this.m_name);
    var xmlChangelist = i_doc.firstChild;


    var key;
    var record;
    var xmlRec;
    var xmlCol;
    var field;
    var pk;
    var foriegnTable;
    var record2;
    var value;
    var date;
    var modifyKeys = this.getModifyPrimaryKeys();


    if (modifyKeys.length>0)
    {
        var xmlUpdate = i_doc.createElement("Update");
        xmlTable.appendChild(xmlUpdate);
        for(var iKey in modifyKeys)
        {
            key =  modifyKeys[iKey];

            xmlRec = i_doc.createElement("Rec");
            xmlUpdate.appendChild(xmlRec);
            record = this.getRec(key);
            var attName =  this.m_fields[0].field;
            xmlRec.setAttribute(attName, record[this.m_fields[0].field])


            for(var iField in this.m_fields)
            {
                field =  this.m_fields[iField];

                if (field.field==this.m_fields[0].field) // primary key
                {
                    value = record.native_id;
                }
                else if (field.foriegn!=null)
                {
                    xmlRec.setAttribute(field.field, record[field.field])
                    foriegnTable = this.m_dataBaseManager.getTable(field.foriegn);
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
                    if ((this.m_name=="player_data" && field.field=="player_data_value") ||
                        (this.m_name=="campaign_timeline_chanel_players" && field.field=="player_data") ||
                        (this.m_name=="campaign_channel_players" && field.field=="player_data") )
                    {
                        xmlCol = i_doc.createElement("Col");

                        var xml = self.getPlayerDataIds(record[field.field]);
                        xmlCol.appendChild(xml);

                        xmlRec.appendChild(xmlCol);
                        continue;
                    }
                    else
                    {
                        value = record[field.field];
                    }
                }
                xmlCol = i_doc.createElement("Col"); //<Col>{value}</Col>;
                xmlCol.textContent =  (value!=null) ? value : "null";
                xmlRec.appendChild(xmlCol);
            }

        }
    }

    var newKeys = this.getNewPrimaryKeys();
    if (newKeys.length>0)
    {
        var xmlNew = i_doc.createElement("New");
        xmlTable.appendChild(xmlNew);

        for(var iKey in newKeys)
        {
            key = newKeys[iKey];
            xmlRec = i_doc.createElement("Rec");

            xmlNew.appendChild(xmlRec);
            record = this.getRec(key);

            xmlRec.setAttribute(this.m_fields[0].field, record[this.m_fields[0].field]);


            for(var iField in this.m_fields)
            {

                field =   this.m_fields[iField];

                if (field.field==this.m_fields[0].field) // primary key
                {
                    value = record.native_id;
                }

                else if (field.foriegn!=null)
                {
                    xmlRec.setAttribute(field.field, record[field.field])
                    foriegnTable = this.m_dataBaseManager.getTable(field.foriegn);
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
                    if ((this.m_name=="player_data" && field.field=="player_data_value") ||
                        (this.m_name=="campaign_timeline_chanel_players" && field.field=="player_data") ||
                        (this.m_name=="campaign_channel_players" && field.field=="player_data") )
                    {
                        xmlCol = i_doc.createElement("Col");


                        var xml = self.getPlayerDataIds(record[field.field]);
                        xmlCol.appendChild(xml);

                        xmlRec.appendChild(xmlCol);
                        continue;
                    }
                    else
                    {
                        value = record[field.field];
                    }
                }


                xmlCol = i_doc.createElement("Col");
                xmlCol.textContent =  (value!=null) ? value : "null";
                xmlRec.appendChild(xmlCol);
          }

        }

    }


    if (modifyKeys.length>0 || newKeys.length>0)
    {
        var xmlFlields = i_doc.createElement("Fields");
        xmlTable.appendChild(xmlFlields);
        for(var iField in this.m_fields)
        {
            field = this.m_fields[iField];
            var xmlField = i_doc.createElement("Field");
            xmlField.textContent = field.field;
            if (field.pk!=null)
            {
                xmlField.setAttribute("pk", field.pk)
            }
            xmlFlields.appendChild(xmlField);
        }
    }

    if (xmlTable.childNodes.length>0)
    {
        xmlChangelist.appendChild(xmlTable);

    }

}


Table.prototype.appendDeletedChangelist = function(i_doc)
{
    var xmlTable = i_doc.createElement("Table");
    xmlTable.setAttribute("name", this.m_name);
    var xmlChangelist = i_doc.firstChild;

    var key;
    var record;
    var xmlRec;
    var xmlCol;
    var field;
    var pk;
    var foriegnTable;
    var record2;
    var value;
    var date;
    var deletedKeys = this.getDeletedPrimaryKeys();
    if (deletedKeys.length>0)
    {
        var xmlDelete = i_doc.createElement("Delete");
        xmlTable.appendChild(xmlDelete);
        for(var iKey in deletedKeys)
        {
            key = deletedKeys[iKey];
            xmlRec = i_doc.createElement("Rec");
            xmlDelete.appendChild(xmlRec);
            record = this.getRec(key);
            xmlRec.setAttribute("pk", record.native_id);
        }
    }

    if (deletedKeys.length>0)
    {
        var xmlFlields = i_doc.createElement("Fields");
        xmlTable.appendChild(xmlFlields);
        for(var iField in this.m_fields)
        {
            var field =  this.m_fields[iField];
            var xmlField = i_doc.createElement("Field");
            xmlField.textContent = field.field;
            xmlFlields.appendChild(xmlField);
        }
    }

    if (xmlTable.childNodes.length>0)
    {
        xmlChangelist.appendChild(xmlTable);
    }

}



Table.prototype.getPlayerDataIds = function(i_playerData)
{
    var doc = $.parseXML(i_playerData);
    this.convertToIds(doc);
    return doc.documentElement;
}


Table.prototype.convertToIds = function (i_docPlayerData)
{
    var elements = i_docPlayerData.getElementsByTagName("Resource");
    for(var iResource=0; iResource<elements.length; iResource++)
    {
        var xmlResource = elements[iResource];
        var hResource = xmlResource.getAttribute("hResource");
        if (hResource!=null && hResource!="")
        {
            var record2 = this.m_dataBaseManager.table_resources().getRec(hResource);
            if (record2!=null)
            {
                xmlResource.setAttribute("resource", record2.native_id);
            }
        }
    }
     /*
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
    */
}

Table.prototype.createPlayId = function(i_xmlPlayer)
{
    /*
    if (XMLList(i_xmlPlayer.@hDataSrc).length()>0)
    {
        var hDataSrc:int = int(i_xmlPlayer.@hDataSrc);
        var record2:Record = m_dataBaseManager.table_player_data.getRec(hDataSrc);
        i_xmlPlayer.@src = (record2!=null) ? record2.native_id : -1;
    }
    */
}


Table.prototype.getNewPrimaryKeys = function()
{
    var primaryKeys = [];
    this.m_newRecords.concatinateKeys(primaryKeys);
    return primaryKeys;
}

Table.prototype.getModifyPrimaryKeys = function()
{
    var primaryKeys = [];
    this.m_modifiedRecords.concatinateKeys(primaryKeys);
    return primaryKeys;
}

Table.prototype.getDeletedPrimaryKeys = function()
{
    var primaryKeys = [];
    this.m_deletedRecords.concatinateKeys(primaryKeys);
    return primaryKeys;
}

Table.prototype.getConflictPrimaryKeys = function()
{
    var primaryKeys = [];
    this.m_conflictRecords.concatinateKeys(primaryKeys);
    return primaryKeys;
}


Table.prototype.commitChanges = function(i_changelistId)
{
    var iHandle;
    var handle;
    var record;
    var newKeys = this.getNewPrimaryKeys();
    for(iHandle in newKeys)
    {
        handle = newKeys[iHandle];
        record = this.m_newRecords.getValue(handle);
        record.status = 0;
        record.change_type = 2;
        record.changelist_id = i_changelistId;
        this.m_originalRecords.add(handle, record);
        this.m_newRecords.remove(handle);
    }

    var modifyKeys = this.getModifyPrimaryKeys();
    for(iHandle in modifyKeys)
    {
        handle = modifyKeys[iHandle];
        record = this.m_modifiedRecords.getValue(handle);
        record.status = 0;
        record.change_type = 1;
        record.changelist_id = i_changelistId;
        this.m_originalRecords.add(handle, record);
        this.m_modifiedRecords.remove(handle);
    }

    var deletedKeys = this.getDeletedPrimaryKeys();
    for(iHandle in deletedKeys)
    {
        handle = deletedKeys[iHandle];
        record = this.m_deletedRecords.getValue(handle);
        if (record!=null && record.native_id!=-1)
        {
            delete this.m_Id2Handle[record.native_id];
        }
        this.m_deletedRecords.remove(handle);
        this.m_originalRecords.remove(handle); // (??? check if do need for this line)
    }
}



