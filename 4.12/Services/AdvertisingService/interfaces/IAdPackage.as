package
{
	public interface IAdPackage
	{
		function get adDomainBusiness():IAdDomainBusiness;
		function get packageId():int;
		function get name():String;
		function get startDate():Date;
		function get endDate():Date;
		function get contents():Array;
		function getPackageStation(i_adPackageStationId:int):IAdStation;
	}
}