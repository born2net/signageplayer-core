package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	

	//import flash.net.SharedObject;
	
	public class Persistent implements IPersistent
	{
		private var m_path:String;
		private var m_bankMap:Object = new Object();
		
		public function Persistent()
		{
		}
		
		public function setPath(i_path:String):void
		{
			m_path =  i_path;
		}
		
		public function setValue(i_bankName:String, i_key:String, i_value:Object):void
		{
			var bank:Object = m_bankMap[i_bankName];
			if (m_bankMap[i_bankName]==null)
			{
				m_bankMap[i_bankName] = bank = new Object();
			}
			bank[i_key] = i_value;
		}
		
		public function getValue(i_bankName:String, i_key:String):Object
		{
			var bank:Object = m_bankMap[i_bankName];
			if (bank==null)
				return null;
			return bank[i_key];
		}

		public function getValueAsXML(i_bankName:String, i_key:String):XML
		{
			var value:Object = getValue(i_bankName, i_key);
			if (value==null)
				return null;
			return XML(value);
		}
		 
		public function load(i_bankName:String):void
		{
			var file:File = new File(m_path);
			file = file.resolvePath(i_bankName);
			file = file.resolvePath("persistent.xml");
			
			if (file.exists==false)
				return;
			try
			{
				var stream:FileStream = new FileStream(); 
				stream.open( file, FileMode.READ );
				var strData:String = ""; 
				while(stream.bytesAvailable>0)
				{
					var length:int = Math.min(10000, stream.bytesAvailable);
					strData += stream.readUTFBytes(length);
				} 
				stream.close();
				var xmlData:XML = new XML(strData);
				for each(var xmlItem:XML in xmlData.*)
				{
					var key:String = xmlItem.@key;
					var value:Object;
					switch(String(xmlItem.@type))
					{
						case "bool":
							value = Boolean(xmlItem.toString());
							break;
						case "int":
							value = int(xmlItem.toString());
							break;
						case "str":
							value = xmlItem.toString();
							break;
						case "xml":
							value = new XML(xmlItem).children()[0];
							break;
					}
					setValue(i_bankName, key, value);
				}
			}
			catch(error:Error)
			{
				trace(error.message);
			}
		}
		
		public function save(i_bankName:String):void
		{
			var bank:Object = m_bankMap[i_bankName];
			if (bank==null)
				return;			
			
			var xmlData:XML = <Data/>;
			for(var key:String in bank)
			{
				var value:Object = getValue(i_bankName, key);
				var xmlItem:XML = <Item>{value}</Item>;
				xmlItem.@key = key;
				
				if (value is Boolean)
				{
					xmlItem.@type="bool";
				}
				else if (value is int)
				{
					xmlItem.@type="int";
				}
				else if (value is String)
				{
					xmlItem.@type="str";
				}
				else if (value is XML)
				{
					xmlItem.@type="xml";
				}
				xmlData.appendChild(xmlItem);
			}
			try
			{
				var file:File = new File(m_path);
				file = file.resolvePath(i_bankName);
				
				file.createDirectory();
				
				file = file.resolvePath("persistent.xml");
								
				var stream:FileStream = new FileStream(); 
				stream.open( file, FileMode.WRITE ); 
				stream.writeUTFBytes(xmlData.toXMLString());
				
				stream.close();
			}
			catch(error:Error)
			{
				trace(error.message);
			}
			file = null;
			stream = null;						
		}
	}
}