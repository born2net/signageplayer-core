package
{
	public interface IPersistent
	{
		function setPath(i_path:String):void
		function setValue(i_bankName:String, i_key:String, i_value:Object):void;
		function getValue(i_bankName:String, i_key:String):Object;
		function getValueAsXML(i_bankName:String, i_key:String):XML;
		
		function load(i_bankName:String):void;
		function save(i_bankName:String):void;
	}
}