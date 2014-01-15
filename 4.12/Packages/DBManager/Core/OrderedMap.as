package
{
	public class OrderedMap
	{
		private var m_dictionary:Object = new Object();
		private var m_keys:Array = new Array();
		
		public function OrderedMap()
		{
			 
		}
		
		public function getValue(i_key:int):Object
		{
			return m_dictionary[i_key];
		}
		
		public function get count():int
		{
			return m_keys.length;
		}
		
		public function getKeyAt(i_index:int):Object
		{
			return m_keys[i_index];
		}
		
		public function add(i_key:int, i_value:Object):void
		{
			if (m_dictionary[i_key]==null)
			{
				m_keys.push(i_key);	
			}
			m_dictionary[i_key] = i_value;
		}
		
		public function remove(i_key:int):void
		{
			delete m_dictionary[i_key];
			for(var i:int=0; i<m_keys.length;i++)
			{
				if (m_keys[i]==i_key)
				{
					m_keys.splice(i, 1); 	
					break;
				}
			}
		}

		public function concatinateKeys(i_destKeys:Array):void
		{
			for each(var key:int in m_keys)
			{
				i_destKeys.push(key);
			}
		}
		
		public function removeAll():void
		{
			m_dictionary = new Object();
			m_keys = new Array();
		}
	}
}