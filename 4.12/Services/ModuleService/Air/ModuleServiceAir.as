package
{
	import flash.system.ApplicationDomain;
	
	public class ModuleServiceAir extends ModuleService
	{
		private var m_mobile:Boolean;
		private var m_downloadMode:String; 
		
		public function ModuleServiceAir(i_framework:IFramework, i_applicationDomain:ApplicationDomain, i_mobile:Boolean, i_debug:Boolean, i_downloadMode:String)
		{
			super(i_framework, i_applicationDomain, i_debug);
			m_mobile = i_mobile;
			m_downloadMode = i_downloadMode;
			
			m_moduleBasePath = MODULE_VER + "/" + (m_mobile ? "mobile" : "desktop");
			if (i_debug)
				m_moduleBasePath += "_d";
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
			
			if (m_mobile)
			{
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
			}
			else
			{
				if (air!="")
				{
					url += air;
				}
				else
				{
					url += web;
				}
			}
			
			return url;
		}
		
		protected override function createLoader(i_moduleId:int):MyLoader
		{
			var loader:MyLoader = m_loaderMap[i_moduleId];
			if (loader==null)
			{
				var url:String = getUrlFromId(i_moduleId);
				if (url==null)
				{
					//m_debugLog.addError("Module "+i_moduleId.toString()+" does not exist");
					//M??? Alert.show("Module "+i_moduleId.toString()+" does not exist");
					return null
				}
				
				var xmlModule:XML = m_modules[i_moduleId];
				
				var ver:String;
				if (xmlModule.@ver=="force")
				{
					ver = "force";
				}
				else
				{
					ver = m_moduleBasePath + "/" + xmlModule.@ver;
				}
				
				
				if (m_downloadMode=="force" || m_downloadMode=="ignore")
				{
					ver = m_downloadMode;
				}
					
				m_loaderMap[i_moduleId] = loader = new MyLoaderAir(m_framework, m_applicationDomain, m_businessDomain, this, url, ver);
				loader.moduleId = i_moduleId;
				m_pandingQueue.push(loader);
			}
			
			return loader; 
		}	
		
		
		protected override function createResourceLoader(i_hResource:int, i_url:String, i_ver:String):MyLoader
		{
			var key:String = "resource"+i_hResource.toString();
			var loader:MyLoader = m_loaderMap[key];
			if (loader==null)
			{
				m_loaderMap[key] = loader = new MyLoaderAir(m_framework, m_applicationDomain, m_businessDomain, this, i_url, i_ver);
				loader.hResource = i_hResource;
			}
			
			
			
			return loader; 
		}		
		
	}
}
