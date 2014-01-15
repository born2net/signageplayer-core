package
{
	public interface IAdExtStat extends IAdStat
	{
		function get adContent():IAdExtContent;
		function playNow(i_time:Number):Boolean;
	}
}