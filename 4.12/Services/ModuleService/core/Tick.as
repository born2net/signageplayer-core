package
{
 import flash.display.Sprite;
 
 public class Tick extends Sprite {
  public function Tick(fromX:Number, fromY:Number, toX:Number, toY:Number, tickWidth:int, tickColor:uint) {
   this.graphics.lineStyle(tickWidth, tickColor, 1.0, false, "normal", "rounded");
   this.graphics.moveTo(fromX, fromY);
   this.graphics.lineTo(toX, toY);
  }
 }
}
