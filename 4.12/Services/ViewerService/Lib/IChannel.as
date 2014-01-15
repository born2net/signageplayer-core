package
{
	public interface IChannel
	{
		function get commonChannel():Boolean;
		function get hChannel():int;
		function assignViewer(i_viewer:IViewer):void;
	}
}