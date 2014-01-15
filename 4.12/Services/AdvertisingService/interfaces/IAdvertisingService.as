package
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayList;
	import mx.collections.XMLListCollection;

	public interface IAdvertisingService extends IEventDispatcher
	{
		function requestBusinessAds(i_businessId:int, i_stationId:int, i_callbackFnc:Function, i_callbackData:Object):void; 
		
		function getBusiness(i_domain:String, i_businessId:int):IAdDomainBusiness;
		function getAdOutPackageStationStatus(i_businessId:int, i_packageId:int, i_packageStationId:int):int;
		
		function get nextExtStat():IAdExtStat;
		
		function flushStats():void;
		
		function get adReport():IAdReport;
		
		
		function getLocalPackages():ArrayList;
		
		
		function getLocalStat(i_hAdLocalContent:int):IAdLocalStat;
	}
}
