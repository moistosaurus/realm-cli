package kabam.rotmg.promotions.view.components
{
   import flash.display.Sprite;
   
   public class TransparentButton extends Sprite
   {
       
      
      public function TransparentButton(x:int, y:int, width:int, height:int)
      {
         super();
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         this.x = x;
         this.y = y;
         buttonMode = true;
      }
   }
}
