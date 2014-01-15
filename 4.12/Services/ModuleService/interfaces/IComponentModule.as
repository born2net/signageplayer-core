package
{
	public interface IComponentModule
	{
		function get framework():IFramework;
		function set framework(i_framework:IFramework):void;
		function set params(i_params:Object):void;
		function get params():Object;	
		function initModule():void;
	}
}