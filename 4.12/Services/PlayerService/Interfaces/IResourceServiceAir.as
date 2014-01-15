package
{
	public interface IResourceServiceAir
	{
		function makeLocalResources():void;
		function dispose():void;
		
		
		function isLocalResource(i_hResource:int):Boolean;
		function getCachingItem(i_hResource:int):ICachingItem;
	}
}