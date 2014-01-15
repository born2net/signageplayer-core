package
{
	public class TableRequest implements ITableRequest
	{
		private var m_xmlTableRequest:XML;
		
		public function TableRequest()
		{
			m_xmlTableRequest = <TableRequest/>;
		}
		
		public function add(i_table:String, i_where:String, i_orderBy:String=null):void
		{
			var xmlTable:XML = <Table/>;
			xmlTable.@name = i_table;
			xmlTable.@where = i_where;
			if (i_orderBy!=null)
			{
				xmlTable.@orderBy = i_orderBy;
			}  
			m_xmlTableRequest.appendChild(xmlTable);
		}
		
		public function get tableRequest():XML
		{
			return m_xmlTableRequest;
		}
	}
}