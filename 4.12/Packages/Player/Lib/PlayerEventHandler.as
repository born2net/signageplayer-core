package  
{
	public class PlayerEventHandler extends EventHandler
	{
		public function PlayerEventHandler(i_playerEventService:IPlayerEventService, i_eventHandleHost:IEventHandleHost)
		{
			super(i_playerEventService, i_eventHandleHost);
		}
		
		public function load(i_xmlEventCommand:XML):void
		{
			m_senderName = i_xmlEventCommand.@from;
			
			  
			//eventCondition = i_xmlEventCommand.@condition;  //??? Not Supported in this version!
			
			m_commandName = i_xmlEventCommand.@command;
			if (XMLList(i_xmlEventCommand.Params).length()>0)
			{
				m_commandParams = i_xmlEventCommand.Params[0].copy();
			}
		}
		
		public function save():XML
		{
			var xmlEventCommand:XML = <EventCommand/>;
			xmlEventCommand.@from = m_senderName
			xmlEventCommand.@condition = (m_eventCondition!=null) ? m_eventCondition : "";
			xmlEventCommand.@command = m_commandName;
			if (m_commandParams!=null)
			{
				xmlEventCommand.appendChild( m_commandParams.copy() );
			}
			return xmlEventCommand;
		}
		
	}
}
