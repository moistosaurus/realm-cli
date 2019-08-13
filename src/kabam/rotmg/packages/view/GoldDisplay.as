package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class GoldDisplay extends Sprite
   {
       
      
      var graphic:DisplayObject;
      
      var text:SimpleText;
      
      public function GoldDisplay()
      {
         this.text = new SimpleText(18,16777215,false,0,0);
         super();
      }
      
      public function init() : void
      {
         var coinBD:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",225);
         coinBD = TextureRedrawer.redraw(coinBD,40,true,0,0);
         this.graphic = new Bitmap(coinBD);
         addChild(this.graphic);
         addChild(this.text);
         this.text.height = this.text.textHeight;
         this.graphic.x = -1 * this.graphic.width;
         this.graphic.y = -1 * this.graphic.height / 2;
      }
      
      public function setGold(value:int) : void
      {
         this.text.text = String(value);
         this.text.updateMetrics();
         this.text.x = this.graphic.x - 1 * this.text.width;
         this.text.y = -1 * this.text.actualHeight_ / 2;
      }
   }
}
