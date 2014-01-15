package
{
	import flash.events.EventDispatcher;
	
	public class RssRequest extends EventDispatcher implements IRssRequest
	{
		private var m_rssMap:Object;
		
		private var m_url:String;
		private var m_minRefreshTime:Number;
		private var m_expiredTime:Number;
		protected var m_result:String;
		
		protected var m_itemList:Array = new Array();
		
		
		public function RssRequest(i_rssMap:Object, i_url:String, i_minRefreshTime:Number, i_expiredTime:Number)
		{
			m_rssMap = i_rssMap;
			m_url = i_url;
			m_minRefreshTime = i_minRefreshTime;
			m_expiredTime = i_expiredTime;
		}
		
		public function request():void
		{
			var rssData:RssData = m_rssMap[m_url];
			if (rssData==null)
			{
				requestRss(m_url);
			}
			else
			{
				if (rssData.liveTime<m_minRefreshTime)
				{
					m_result = rssData.data;
					if (m_itemList.length==0)
					{
						populateItemList();
					}

					dispatchEvent( new RssEvent(RssEvent.RSS_RESULT, this) );
				}
				else
				{
					requestRss(m_url);
				}
			}
		}

		public function get result():String
		{
			return m_result;
		}
		
		
		public function shuffleItems():void
		{
			var randomList:Array = new Array();
			var rssItem:IRssItem;
			while(m_itemList.length>0)
			{
				var index:int = Math.random() * m_itemList.length;
				rssItem = m_itemList[index];
				randomList.push( rssItem );
				m_itemList.splice(index, 1);
			}
			m_itemList = randomList;
		}
		
		public function getItemCount():int
		{
			return m_itemList.length;
		}
		
		public function getItemAt(i_index:int):IRssItem
		{
			return m_itemList[i_index]; 
		}
		
		
		
		protected function requestRss(i_url:String):void
		{
		}
		
		protected function onResult(i_result:String):void
		{
			var rssData:RssData;
			if (i_result!=null)
			{
				m_result = i_result;
				rssData = new RssData(i_result, m_expiredTime, new Date());
				updateRssMap(m_url, rssData);
			}
			else
			{
				rssData = m_rssMap[m_url];
				if (rssData!=null)
				{
					if (rssData.liveTime<m_expiredTime)
					{
						m_result = rssData.data;
					}
					else // expired
					{
						updateRssMap(m_url, null);
						m_result = null;	
					}
				}
				else
				{
					m_result = null;
				}
			}
			
			populateItemList(); 
			
			dispatchEvent( new RssEvent(RssEvent.RSS_RESULT, this) );
		}
		
		protected function updateRssMap(i_key:String, i_rssData:RssData):void
		{
			m_rssMap[i_key] = i_rssData;
		}
		
		protected function populateItemList():void
		{
			m_itemList = new Array();
			if (m_result==null)
				return;
			try
			{
				var xmlRss:XML = new XML(m_result);
				
				var xmlItemList:XMLList = getXmlList(xmlRss, xmlRss, "channel.item");
				for each(var xmlItem:XML in xmlItemList)
				{
					var rssItem:RssItem = createRssItem(xmlItem);
					//??? if (rssItem.getMediaUrl()!=null)
					{
						m_itemList.push(rssItem);
					}
				}
			}
			catch(error:Error)  // in case the m_result is not a XML format 
			{
				
			}
		}
		
		private function getXmlList(i_xmlRoot:XML, i_xml:XML, i_fieldName:String):XMLList
		{
			var xmlList:XMLList; 
			try
			{
				var ns:Namespace;
				var qname:QName
				var fields:Array = i_fieldName.split(".");
				for each(var field:String in fields)
				{
					var element:Array = field.split(":");
					if (element.length==2)
					{
						ns = i_xmlRoot.namespace(element[0]);						
						qname = new QName(ns.uri, element[1]);
						xmlList = (xmlList==null) ? i_xml.descendants(qname) : xmlList.descendants(qname);
					}
					else
					{
						
						ns = i_xmlRoot.namespace("");
						if (ns==null)
						{
							xmlList = (xmlList==null) ? i_xml[field] : xmlList[field];
						}
						else
						{
							qname = new QName(ns.uri, field);
							xmlList = (xmlList==null) ? i_xml.descendants(qname) : xmlList.descendants(qname);
						}
					}
					
				}
			}
			catch(e:Error)
			{
				return null;
			}
			
			return xmlList;
		}

		
		protected function createRssItem(i_xmlItem:XML):RssItem
		{
			return new RssItem(i_xmlItem);
		}
	}
}
