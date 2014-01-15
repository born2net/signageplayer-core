package
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayList;
	
	public interface IModuleService extends IEventDispatcher
	{
		//function get isReady():Boolean;
		//function getUrlFromId(i_moduleId:int):String;
		
		function setModules(i_applicationId:int, i_loadModules:Boolean):void;
		function attachChild(i_componentLoader:IComponentLoader, i_moduleId:int):void;
		function dettachChild(i_componentLoader:IComponentLoader, i_moduleId:int):void;
		
		function attachChildToResource(i_componentLoader:IComponentLoader, i_hResource:int, i_url:String, i_ver:String):void;
		function dettachChildFromResource(i_componentLoader:IComponentLoader, i_hResource:int):void;
		
		function getApps():XMLList
		function getTimelineComponents():XML;
		function getSceneComponents():XML;
		function get mimeTypeNames():Array;
		function getMimeType(i_mimeTypeName:String):XML
		function installApp(i_appId:int):void;
		function get installedApps():XML;
	}
}