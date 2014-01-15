package
{
	import flash.events.IEventDispatcher;
	
	public interface ILocalizationService extends IEventDispatcher
	{
		function get local():String;
		function set local(i_local:String):void;
		function getResourceBundles(i_bundleList:String):void; 
		function localizeXml(i_bundleName:String, i_xml:XML, i_keyPrefix:String, i_keyField:String, i_labelField:String):void;
	}
}