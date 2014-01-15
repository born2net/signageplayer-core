package
{
	import flash.events.IEventDispatcher;
	
	public interface ITableRequest
	{
		function add(i_table:String, i_where:String, i_orderBy:String=null):void;
	}
}