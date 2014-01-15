function DataModuleBase()
{
    this.m_tables = {};
}

DataModuleBase.prototype.getTable = function getTable(i_table)
{
    return this.m_tables[i_table];
}


DataModuleBase.prototype.getChangelist = function()
{
    var reverseList = [];

    for(var iTable in this.m_tableList)
    {
        var  sTable =   this.m_tableList[iTable];
        reverseList.push(sTable);
    }
    reverseList.reverse();

    var doc =  $.parseXML("<Changelist/>");
   // var xmlChangelist =  $.parseXML("<Changelist/>").firstChild;

    var table;
    for(var iTable in this.m_tableList)
    {
        var tableName =  this.m_tableList[iTable];
        this.getTable(tableName).appendModifyAndNewChangelist(doc);
    }

    for(var iTable in this.m_tableList)
    {
        var tableName =  this.m_tableList[iTable];
        this.getTable(tableName).appendDeletedChangelist(doc);
    }


    return (new XMLSerializer()).serializeToString(doc);
}


DataModuleBase.prototype.commitChanges = function(i_changelistId)
{
    for(var iTable in this.m_tables)
    {
        var table =  this.m_tables[iTable];
        table.commitChanges(i_changelistId);
    }
}



DataModuleBase.prototype.getPrimaryToTableMap = function()
{
    var fields = {};
    for(var iTable in this.m_tables)
    {
        var table =  this.m_tables[iTable];
        var field = table.m_fields[0].field;
        var tableList = fields[field];
        if (tableList==null)
        {
            fields[field] = tableList = [];
        }
        tableList.push(table);
    }
    return fields;
}


DataModuleBase.prototype.createFieldHandles = function(i_table, i_field)
{
    var self3 = this;
    var keys = i_table.getAllPrimaryKeys();

    for(var iKey in keys)
    {
        var handle = keys[iKey];
        record = i_table.getRec(handle);
        try
        {
            var data = record[i_field];
            if (data!=null && data!="")
            {
                var doc =  $.parseXML(data);
                var xmlField = doc.documentElement;
                self3.convertToHandels(xmlField);
                record[i_field] = new XMLSerializer().serializeToString(xmlField);
            }
        }
        catch(error)
        {
            alert("error");
        }
    }
}


DataModuleBase.prototype.convertToHandels = function(i_xmlField)
{
    var self4 = this;
    var resources = i_xmlField.getElementsByTagName('Resource');
    for (var i = 0; i < resources.length; i++)
    {
        var xmlResource = resources[i];
        var resourceId = xmlResource.getAttribute('resource');
        if (resourceId!=-1)
        {
            var hResource = self4.getTable("resources").getHandle(resourceId);
            xmlResource.setAttribute("hResource", hResource);
        }
    }



    /*

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
    */
}
