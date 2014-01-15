package
{
	public interface ICatalogService
	{
		function sync():void;
		function getResourceList(i_hCatalogItem:int):Array;
		function queryItemList(i_categories:Array):Array;
	}
}