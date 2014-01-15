package
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.ModuleEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Label;
 
	public class ComponentLoader extends BorderContainer implements IComponentLoader
	{
		protected var m_framework:IFramework;
		protected var m_moduleService:IModuleService;
		protected var m_moduleId:int = -1;
		protected var m_moduleClass:String = null;
		protected var m_moduleClassAir:String = null;
		
		 
		protected var m_enableProgress:Boolean = true;
		
		private var m_componentProgress:IComponentProgress;
		public var child:UIComponent;
		public var data:Object; 
		
		
		public function ComponentLoader()
		{
			moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
			super();
			
			setStyle("borderVisible", false);
			
			percentWidth = 100;
			percentHeight = 100;
			
			minHeight=0;
			minWidth=0;
			
			//clipAndEnableScrolling = useClip;
			data = new Object();
		}
		
		public function set framework(i_framework:IFramework):void
		{
			m_framework = i_framework;
			m_moduleService = m_framework.ServiceBroker.QueryService("ModuleService") as IModuleService;
		}
		
		public function get framework():IFramework
		{
			return m_framework;
		}		

		protected function get useClip():Boolean
		{
			return true;
		}
		
		[Inspectable(enumeration="false,true")]
		public function get enableProgress():Boolean
		{
			return m_enableProgress;
		}
		
		public function set enableProgress(i_enableProgress:Boolean):void
		{
			m_enableProgress = i_enableProgress;
		}

		
		public function get componentProgress():IComponentProgress
		{
			return m_componentProgress;
		}
		
		public function set componentProgress(i_componentProgress:IComponentProgress):void
		{
			m_componentProgress = i_componentProgress;
		}
		
		public function clear():void
		{
			if (m_moduleId!=-1)
			{
				m_moduleService.dettachChild(this, m_moduleId);
				m_moduleId = -1;
				removeProgress();
				if (child!=null)
				{
					removeElement(child);
					child = null;
				}
			}
		}

		public function get moduleId():int
		{
			return m_moduleId;
		}

		public function set moduleId(i_moduleId:int):void
		{
			if (m_moduleId!=-1)
			{
				m_moduleService.dettachChild(this, m_moduleId);
				m_moduleId = -1;
			}
			m_moduleId = i_moduleId;
			if (i_moduleId!=-1)
			{
				m_moduleService.attachChild(this, i_moduleId);
			}
			else
			{
				removeProgress();
				if (child!=null)
				{
					removeElement(child);
					child = null;
				}
			}
		}
		
		public function get moduleClass():String
		{
			return m_moduleClass;
		}

		public function set moduleClass(i_moduleClass:String):void
		{
			m_moduleClass = i_moduleClass;
		}

		
		public function get moduleClassAir():String
		{
			return m_moduleClassAir;
		}
		
		public function set moduleClassAir(i_moduleClassAir:String):void
		{
			m_moduleClassAir = i_moduleClassAir;
		}
		
		public function error(i_message:String):void
		{
			removeProgress(); 
		}

		public function ready(i_child:UIComponent):void
		{
			i_child.percentHeight = 100;
			i_child.percentWidth = 100;
			addElement(i_child);
			child = i_child;
			dispatchEvent(new ModuleEvent(ModuleEvent.READY));
			
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		} 
		
		

		protected function removeProgress():void
		{
			if (m_componentProgress!=null)
			{
				removeElement(IVisualElement(m_componentProgress));
				m_componentProgress = null;
			}
		}
		
		// Prevent scrolling by the keyboad.
	    override protected function keyDownHandler(event:KeyboardEvent):void
	    {
	    }
	    
	    public function get params():Object { return data;    }
	}
}