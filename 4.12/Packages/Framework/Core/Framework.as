package
{
	import mx.events.FlexEvent;
	import mx.states.AddChild;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.soap.mxml.WebService;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import mx.modules.ModuleManager;
	import mx.modules.IModuleInfo; 
	import mx.events.ModuleEvent;
	import flash.system.ApplicationDomain;
	import mx.events.ResizeEvent;
	import flash.utils.Dictionary;
	
	public class Framework extends EventDispatcher implements IFramework
	{  
		private var m_layoutXml:XML;
		
		private var m_eventDispatcher:EventDispatcher 	= new EventDispatcher();
		private var m_servicesBroker:ServicesBroker 	= new ServicesBroker();
		private var m_stateBroker:CStateBroker			= new CStateBroker();
		
 
 		public function Framework()
		{ 
		}
	 
		public function get EventBroker():IEventDispatcher
		{
			return m_eventDispatcher;
		}

		public function get ServiceBroker():IServicesBroker
		{
			return m_servicesBroker;
		}
		
		public function get StateBroker():IStateBroker
		{
			return m_stateBroker;
		} 
		
		/*??? DO NOT DELETE!
		public function SaveLayout(i_layoutContainer:ComponentContainer):XML
		{
			var xmlWebApplication:XML = <WebApplication/>
			
			var xmlBackgroundLoading:XML = <BackgroundLoading/>;
			xmlWebApplication.appendChild(xmlBackgroundLoading);
			var xmlContainerList:XML = <ContainerList/>;
			xmlWebApplication.appendChild(xmlContainerList);
			
			for each(var info:ComponentContainerInfo in m_componentContainerMap)
			{
				var xmlComponentContainer:XML = <ComponentContainer/>;
				xmlContainerList.appendChild(xmlComponentContainer);
				xmlComponentContainer.@ref = info.ContainerId;
				xmlComponentContainer.@swfId = info.ComponenetId;
				var xmlParams:XML = <Params/>;
				xmlComponentContainer.appendChild(xmlParams);
				for(var key:String in info.Params)
				{
					var xmlParam:XML = <Param/>;
					xmlParams.appendChild(xmlParam);
					xmlParam.@key = key;
					xmlParam.@value = info.Params[key];
				}
			} 
			
			
			Alert.show (xmlWebApplication.toXMLString());
			
			return xmlWebApplication;
		}
		*/

		
		
		/* NOT SUPPORTED ANYMORE !!! ???
		// this function get called by the Component Container when it get loaded 
		private function onComponentContainerGuiLoaded(event:ComponentContainerEvent):void
		{
			if (event!=null && event.ComponentContainer!=null && event.ComponentContainer.name!=null)
			{
				var layout:ILayout = (event.ComponentContainer as IComponentContainer).Layout;
				var info:IComponentContainerInfo = layout.GetContainersInfo(int(event.ComponentContainer.name));
				if (info==null) 
				{
					Alert.show ("Error: Can not found "+event.ComponentContainer.name);
					return;		
				}
				var oleDisplay:IComponentContainer = event.ComponentContainer as IComponentContainer;

				var componentManager:IComponentManager = m_swfFactory.CreateComponentManager();
				componentManager.addEventListener(ComponentEvent.READY, oleDisplay.onCreateComponent);
				componentManager.addEventListener(ComponentEvent.READY, onCreateComponent); //???
				componentManager.CreateComponent(info.Swf, info.Params, (event.ComponentContainer as IComponentContainer).Layout, int(event.ComponentContainer.name), 1);
			}
		}
		*/
		
		/* NOT SUPPORTED ANYMORE !!! ???
		private function onCreateComponent(event:ComponentEvent):void
		{
			var layout:ILayout = (event.m_component as IComponentModule).Layout;
			layout.GetTheme().Apply(event.m_component);
			
			//(event.m_component as ComponentModule).m_layoutId = 
			dispatchEvent(new ComponentEvent(ComponentEvent.READY, event.m_framework, event.m_component, event.m_componentId, event.m_params));	//???
		}
		*/
	}
}

