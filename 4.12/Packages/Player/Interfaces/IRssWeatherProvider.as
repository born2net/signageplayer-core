package
{
	public interface IRssWeatherProvider extends IDataProvider
	{
		function getCurTemp():String;
		function getCurCondition():String;
		function getCurImage(i_weatherStyleId:int):Class;
		function getDayName(i_offset:int):String;
		function getDayCondition(i_offset:int):String;
		function getDayHigh(i_offset:int):String;
		function getDayLow(i_offset:int):String;
		function getDayImage(i_offset:int, i_weatherStyleId:int):Class;
	}
}