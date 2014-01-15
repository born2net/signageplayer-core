package
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;

	public interface IAdReport extends IEventDispatcher
	{
		function requestReport(i_businessId:int, i_year:int, i_month:int, i_requestReportCallback:Function):void;
		function get reportCollection():XMLListCollection;
		function selectDomainBusiness(i_domain:String, i_businessId:int):void
		function createReportData(i_aggregateHourly:Boolean, i_aggregateDaily:Boolean, i_aggregatePackage:Boolean, i_aggregateContent:Boolean, i_aggregateStation:Boolean):void
		function get reportData():ArrayCollection;
		function exportReport():Boolean;
		function deleteReport(i_deletetReportCallback:Function):void;
		
		function createChartData(i_aggregateHourly:Boolean, i_aggregateDaily:Boolean, i_dsplay:String):void
		function get chartData():ArrayCollection;
		function get serieses():Object;
		
		function get totalCount():int;
		function get totalTime():Number;
		function get totalMPH():Number;
		function get totalPrice():Number;
	}
}
