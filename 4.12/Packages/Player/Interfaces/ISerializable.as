package
{
	public interface ISerializable
	{
		function load(i_data:XML):void;
		function save():XML;
	}
}