package
{
	public interface IAdStat
	{
		function beginPlay(i_width:Number, i_height:Number):void;
		function updatePlay(i_width:Number, i_height:Number):void;
		function finishPlay():void;
	}
}