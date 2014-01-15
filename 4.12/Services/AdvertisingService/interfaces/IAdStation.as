package
{
	public interface IAdStation
	{
		function get packageStationId():int;
		function get toStationId():int;
		function get adPackage():IAdPackage;
		function get daysMask():int;
		function get hourStart():int;
		function get hourEnd():int;
	}
}