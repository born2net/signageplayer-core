function OrderedMap()
{
    this.m_dictionary = {};
    this.m_keys = [];
}



OrderedMap.prototype.getValue = function(i_key)
{
    return this.m_dictionary[i_key];
}

OrderedMap.prototype.count = function()
{
    return this.m_keys.length;
}

OrderedMap.prototype.getKeyAt = function(i_index)
{
    return this.m_keys[i_index];
}

OrderedMap.prototype.add = function(i_key, i_value)
{
    if (this.m_dictionary[i_key]==null)
    {
        this.m_keys.push(i_key);
    }
    this.m_dictionary[i_key] = i_value;
}

OrderedMap.prototype.remove = function(i_key)
{
    delete this.m_dictionary[i_key];
    for(var i=0; i<this.m_keys.length;i++)
    {
        if (this.m_keys[i]==i_key)
        {
            this.m_keys.splice(i, 1);
            break;
        }
    }
}

OrderedMap.prototype.concatinateKeys = function(i_destKeys)
{
    for(var iKey in this.m_keys)
    {
        var key = this.m_keys[iKey];
        i_destKeys.push(key);
    }
}

OrderedMap.prototype.removeAll = function ()
{
    this.m_dictionary = {};
    this.m_keys = [];
}
