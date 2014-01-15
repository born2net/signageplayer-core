package
{
	import mx.core.UIComponent;
	
	public interface IViewer
	{
		function setRect(i_x:Number, i_y:Number, i_width:Number, i_height:Number):void;
		function setScale(i_scaleX:Number, i_scaleY:Number):void;
			
		function load(i_hPlayer:int, i_xmlPlayer:XML, i_playerOffset:Number, i_time:Number, i_adLocalEnabled:Boolean, i_hAdLocalContent:int):void;
		function clean():void; 
		
		function get commonChannel():Boolean;
		function set commonChannel(i_commonChannel:Boolean):void;
		
		function get hChanel():int;
		function set hChanel(i_hChanel:int):void;
		function get hPlayer():int;
		function get order():int;
		function set order(i_order:int):void;
		function get mouseChildren():Boolean;
		function set mouseChildren(i_mouseChildren:Boolean):void; 
		function tick(i_time:Number):void;
		
		function get inUse():Boolean;
		function set inUse(i_inUse:Boolean):void;
		
		function get playerLoader():IPlayerLoader;		
	}
}