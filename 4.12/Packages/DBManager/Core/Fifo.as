package
{
	public class Fifo
	{
		private var m_buffer:Array;
		private var m_head:int = 0;
		private var m_tail:int = 0;
		private var m_count:int = 0;
				
		public function Fifo(i_size:int)
		{
			m_buffer = new Array(i_size);
		}
		
		public function AddFirst(i_value:Object):void
		{
			m_count++;
			m_buffer[m_head] = i_value;
			m_head++;
			if (m_head==m_buffer.length)
				m_head=0;
		}

		public function GetLast():Object
		{
			return m_buffer[m_tail];
		}
		
		public function RemoveLast():Object
		{
			m_count--;
			var obj:Object = GetLast();
			m_buffer[m_tail] = null;
			m_tail++;
			if (m_tail==m_buffer.length)
				m_tail=0;
			return obj;	
		}
		
		public function Exist():Boolean
		{
			return m_count>0;
		}
		
		public function get Count():int
		{
			return m_count;
		}
		
		public function Reset():void
		{
			m_tail = m_head = 0;
			m_count = 0;
		}
	}
}