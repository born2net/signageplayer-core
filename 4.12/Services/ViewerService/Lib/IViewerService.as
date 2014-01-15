package
{
	import flash.geom.Rectangle;
	
	public interface IViewerService
	{
		function setTotalRect(i_totalRect:Rectangle):void;
		function updateScale(i_screenWidth:Number, i_screenHeight:Number, i_orientationEnabled:Boolean):void;
		function get landscape():Boolean;
		function set landscape(i_landscape:Boolean):void;
		
		function createViewer(i_chanel:IChannel, i_x:Number, i_y:Number, i_width:Number, i_height:Number, i_order:int):IViewer;
		function hideAllViewers():void;
		function cleanChanels(i_commonChannel:Boolean):void;
		function removeAllViewers():void;
		function orderViewers():void;
	}
}