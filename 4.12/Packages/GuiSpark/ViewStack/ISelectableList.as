package ViewStack
{
	import mx.collections.IList;

	public interface ISelectableList extends IList
	{
		function set selectedIndex(value:int):void;
		function get selectedIndex():int;
	}
}