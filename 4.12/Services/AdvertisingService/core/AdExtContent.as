package
{
	public class AdExtContent implements IAdExtContent
	{
		private var m_adPackage:AdPackage;
		private var m_contentId:int;
		private var m_name:String;
		private var m_duration:Number;
		private var m_reparationsPerHour:int;
		private var m_resourceId:int;
		private var m_playerDataId:int;
		
		private var m_adStatArray:Array = new Array(24);
		
		
		public function AdExtContent(i_adPackage:AdPackage, i_contentId:int, i_xmlContent:XML)
		{
			m_adPackage = i_adPackage;
			m_contentId = i_contentId;
			m_name = i_xmlContent.@name;
		}
		
		public function get contentId():int
		{
			return m_contentId;
		}

		public function get adPackage():IAdPackage
		{
			return m_adPackage;
		}
		
		public function update(i_content:XML):void
		{
			m_duration = i_content.@duration;
			m_reparationsPerHour = i_content.@reparationsPerHour;
			m_resourceId = (XMLList(i_content.@resourceId).length()==1) ? i_content.@resourceId : -1;
			m_playerDataId = (XMLList(i_content.@playerDataId).length()==1) ? i_content.@playerDataId : -1;
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function get duration():Number
		{
			return m_duration;
		}

		public function get reparationsPerHour():int
		{
			return m_reparationsPerHour;
		}

		public function get resourceId():int
		{
			return m_resourceId;
		}

		public function get playerDataId():int
		{
			return m_playerDataId;
		}
	}
}
