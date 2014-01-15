package
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class CStateBroker extends EventDispatcher implements IStateBroker
	{
		private var m_states:Dictionary = new Dictionary();
		
		public function SetState(i_sender:Object, i_name:String, i_value:Object):void
		{
			m_states[i_name] = i_value;
			dispatchEvent( new StateBrokerEvent(i_sender, i_name, StateBrokerEvent.STATE_SET) );
		}
		
		public function RemoveState(i_sender:Object, i_name:String):void
		{
			delete m_states[i_name];
			dispatchEvent( new StateBrokerEvent(i_sender, i_name, StateBrokerEvent.STATE_REMOVED) );
		}
		
		public function GetState(i_name:String):Object
		{
			return m_states[i_name];
		}
	}
}