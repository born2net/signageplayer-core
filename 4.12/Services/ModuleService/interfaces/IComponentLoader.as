package
{
	import mx.core.UIComponent;
	
	public interface IComponentLoader
	{
		function get framework():IFramework;
		
		function get enableProgress():Boolean;
		function set enableProgress(i_enableSpinner:Boolean):void;	
		function get componentProgress():IComponentProgress;
		function set componentProgress(i_componentProgress:IComponentProgress):void;	
		function error(i_message:String):void;
		function ready(i_child:UIComponent):void;
	}
}