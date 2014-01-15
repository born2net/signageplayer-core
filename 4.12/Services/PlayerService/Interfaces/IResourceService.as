package
{
	import flash.utils.ByteArray;
	
	public interface IResourceService
	{
		function isAir():Boolean;
		
		function selectDomainBusiness(i_businessDomain:String, i_businessId:int):void;
		
		
		function getPathFromHandle(i_hResource:int):String;
		function getUrlFromHandle(i_hResource:int):String;
		
		function getNameFromHandle(i_hResource:int):String;
		function getTypeFromHandle(i_hResource:int):String;
		
		function useHtmlContainer(i_hResource:int):Boolean;
		function isFlexModule(i_hResource:int):Boolean;
		function isTrust(i_hResource:int):Boolean;
		
		
		function addSnapshot(i_table:String, i_group:String, i_handle:int, i_data:ByteArray):void;
		function getSnapshotFromHandle(i_table:String, i_group:String, i_handle:int):Object;
		

		function getTotalTime(i_hResource:int):Number; 
		function setTotalTime(i_hResource:int, i_totalTime:Number):void;
		
		function setSize(i_hResource:int, i_width:int, i_height:int):void;
		function getWidth(i_hResource:int):int; 
		function getHeight(i_hResource:int):int; 
		
		function setBytesTotal(i_hResource:int, i_bytesTotal:Number):void;
		function getBytesTotal(i_hResource:int):Number;
		
		function clearCaching():void;
	}
}