package
{
	public interface IRssStockProvider extends IDataProvider
	{
		function getStockLastTrade(i_symbol:String):String;
		function getStockTradeDate(i_symbol:String):String;
		function getStockTradeTime(i_symbol:String):String;
		function getStockChange(i_symbol:String):String;
		function getStockPercentage(i_symbol:String):String;
		function getStockOpen(i_symbol:String):String;
		function getStockMax(i_symbol:String):String;
		function getStockMin(i_symbol:String):String;
		function getStockVolume(i_symbol:String):String;
		function isStockPositive(i_symbol:String):Boolean;		
	}
}