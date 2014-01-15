package
{
	public class PlayerModule extends ComponentModule implements IPlayer, IEventHandleHost
	{
		protected var m_data:XML;
		protected var m_playerLoader:IPlayerLoader;
		protected var m_keepPlaying:Boolean = false;
		private var m_emptyBlock:EmptyBlock;
		
		public function PlayerModule()
		{
			super();
			minWidth=0; 
			minHeight=0; 
			setStyle("backgroundAlpha", 0);
		}
		
		
		public function load(i_data:XML):void
		{ 
			m_data = i_data;	
		}
		
		public function save():XML
		{
			return null;
		}		
		
		public function clear():void
		{
			if (m_emptyBlock!=null)
			{
				removeElement(m_emptyBlock);
				m_emptyBlock = null;
			}
		}

		public function start():void
		{
		}
		
		public function stop():void
		{
		}
		
		public function pause():void
		{
			
		}
		
		public function get seek():Number // ??? not common
		{
			return 0;				
		}
		
		public function set seek(i_seek:Number):void
		{
			
		}
		
		public function enableEffect():void
		{ 

		}		
		

		public function onFrame(i_time:Number):void
		{
			
		}		
		
		public function get playerLoader():IPlayerLoader
		{
			return m_playerLoader;
		}
		
		public function set playerLoader(i_playerLoader:IPlayerLoader):void
		{
			m_playerLoader = i_playerLoader;	
		}
		
		public function get propertyPages():Array
		{
			return [];
		}
		
		public function get keepPlaying():Boolean
		{
			return m_keepPlaying;
		}
		
		public function set keepPlaying(i_keepPlaying:Boolean):void
		{
			m_keepPlaying = i_keepPlaying;
		}
		
		protected function showBlockInfo(i_text:String):void
		{
			if (i_text!=null)
			{
				if (m_emptyBlock==null)
				{
					m_emptyBlock = new EmptyBlock();
					addElementAt(m_emptyBlock, 0);
				}
				m_emptyBlock.text = i_text;
			}
			else
			{
				if (m_emptyBlock!=null)
				{
					removeElement(m_emptyBlock);
					m_emptyBlock = null;
				}
			}
		}
		
		public function get enableChildLayout():Boolean
		{
			return false;
		}
		
		public function onCommand(i_eventHandler:IEventHandler, i_eventParam:Object):void
		{
			
		}
	}
}





import spark.components.Group;
import spark.components.Label;

class EmptyBlock extends Group
{
	private var m_labelEmpty:Label;
	private var m_text:String;
	
	public function EmptyBlock()
	{
		m_labelEmpty = new Label();
		percentHeight = 100;
		percentWidth = 100;
	}

	public function get text():String
	{
		return m_labelEmpty.text;
	}
	
	public function set text(i_text:String):void
	{
		m_labelEmpty.text = i_text;
	}
	
	protected override function createChildren():void
	{
		super.createChildren();
		m_labelEmpty.percentHeight = 100;
		m_labelEmpty.percentWidth = 100;
		m_labelEmpty.text = m_text;
		m_labelEmpty.setStyle("color", 0xa0a0a0);
		m_labelEmpty.setStyle("horizontalCenter", 0);
		m_labelEmpty.setStyle("verticalCenter", 0);
		m_labelEmpty.setStyle("textAlign", "center");
		addElement(m_labelEmpty);
	}
}
