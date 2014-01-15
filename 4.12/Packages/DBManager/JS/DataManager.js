function DataManager()
{
    this.m_businessData = {};
    this.m_selectedDataBase = -1;
}



DataManager.prototype.createDataModule = function(i_businessDomain, i_businessId)
{
    var domainBusinessKey = i_businessDomain + "." + i_businessId;
    var dataBase = new DataModuleBase();
    this.m_businessData[domainBusinessKey] = dataBase;
    return dataBase;
}


DataManager.prototype.selectDomainBusiness = function(i_businessDomain, i_businessId)
{
    var domainBusinessKey = i_businessDomain + "." + i_businessId;
    this.m_selectedDataBase = this.m_businessData[domainBusinessKey];
}

DataManager.prototype.getPrimaryToTableMap = function()
{
    return this.m_selectedDataBase.getPrimaryToTableMap();
}

DataManager.prototype.loadTables = function (i_xmlTables)
{
    var self = this;
    try
    {
    for (var iTable in i_xmlTables.documentElement.childNodes)
    {
        if (iTable=="item" || iTable=="iterator" || iTable=="length")
            continue;

        var xmlTable = i_xmlTables.documentElement.childNodes[iTable]
        console.log(xmlTable.nodeName);
        var tableName = xmlTable.attributes["name"].value;

        var table = this.getTable(tableName);

        table.addData(xmlTable);

    }





    // a2



    self.createHandles();  // ppp2
    }
    catch(error)
    {
        alert(error)
    }
}


DataManager.prototype.getTable = function(i_table)
{
    return this.m_selectedDataBase.getTable(i_table);
}

DataManager.prototype.getChangelist = function()
{
    return this.m_selectedDataBase.getChangelist();
}


DataManager.prototype.commitChanges = function(i_changelistId)
{
    this.m_selectedDataBase.commitChanges(i_changelistId);
}



DataManager.prototype.createHandles = function()
{

}



DataManager.prototype.createFieldHandles = function(i_table, i_field)
{
    this.m_selectedDataBase.createFieldHandles(i_table, i_field);
}
