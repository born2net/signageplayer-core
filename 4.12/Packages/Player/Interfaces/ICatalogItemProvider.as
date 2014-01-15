package
{
	public interface ICatalogItemProvider extends IDataProvider
	{
		function getName():String;
		function getInfo(i_index:int):String;
		function getResourcePath():String;
		function getResourceType():String;
	}
}