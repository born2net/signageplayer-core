package
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import mx.core.ClassFactory;
	import mx.core.UIComponent;

	public class ModuleServiceEmbedded extends ModuleService
	{
		public function ModuleServiceEmbedded(i_framework:IFramework, i_applicationDomain:ApplicationDomain, i_debug:Boolean)
		{
			super(i_framework, i_applicationDomain, i_debug);
		}
		
		
		protected override function getUrlFromId(i_moduleId:int):String
		{ 
			var url:String = null;
			if (m_modules[i_moduleId]==null)
				return null;
			
			url = "Modules/" + m_moduleBasePath + "/";
			
			
			var web:String = String(m_modules[i_moduleId].@moduleWeb);
			var air:String = String(m_modules[i_moduleId].@moduleAir);
			var mobile:String = String(m_modules[i_moduleId].@moduleMobile);
			
			if (mobile!="")
			{
				url += mobile;
			}
			else if (air!="")
			{
				url += air;
			}
			else
			{
				url += web;
			}
			
			return url;
		}

		
		public override function attachChild(i_componentLoader:IComponentLoader, i_moduleId:int):void
		{
			var url:String = getUrlFromId(i_moduleId);
			var i1:int = url.indexOf(".swf");
			var i2:int = url.lastIndexOf("/", i1);
			var moduleClass:String = url.substring(i2+1, i1);
			
			if (moduleClass=="swfPlayer")
			{
				moduleClass = "SwfPlayer"
			}
			
			try
			{
				var definition:Class = getDefinitionByName(moduleClass) as Class;
				var classFactory:ClassFactory = new ClassFactory(definition);
				var uiComponent:UIComponent = classFactory.newInstance();
				
				
				var componentModule:IComponentModule = uiComponent as IComponentModule;
				IComponentModule(uiComponent).framework = i_componentLoader.framework;
				IComponentModule(uiComponent).params = ComponentLoader(i_componentLoader).data;
				
				i_componentLoader.ready(uiComponent);
			}
			catch(e:Error)
			{
				AlertEx.showOk(UIComponent(m_framework.StateBroker.GetState("topWindow")),
					"Error loading " + moduleClass);
			}
		}
		
		public override function dettachChild(i_componentLoader:IComponentLoader, i_moduleId:int):void
		{ 
		}
	}
}