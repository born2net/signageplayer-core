package
{
	public interface IAdDomainBusiness
	{
		function get adDomain():IAdDomain;
		function getAdPackage(i_packageId:int):IAdPackage;
		function get businessId():int;
		function get name():String;
		function getStation(i_stationId:int):IAdDomainBusinessStation;
	}
}