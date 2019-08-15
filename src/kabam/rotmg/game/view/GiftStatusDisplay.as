package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.ui.UIUtils;
   
   public class GiftStatusDisplay extends Sprite
   {
      
      public static const NOTIFICATION_BACKGROUND_WIDTH:Number = 110;
      
      public static const NOTIFICATION_BACKGROUND_HEIGHT:Number = 25;
      
      public static const NOTIFICATION_BACKGROUND_ALPHA:Number = 0.4;
      
      public static const NOTIFICATION_BACKGROUND_COLOR:Number = 0;
       
      
      private var bitmap:Bitmap;
      
      private var background:Sprite;
      
      private var giftOpenProcessedTexture:BitmapData;
      
      private var text:SimpleText;
      
      private var tooltip:TextToolTip;
      
      public function GiftStatusDisplay()
      {
         super();
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onHover);
         addEventListener(MouseEvent.MOUSE_OUT,this.onHoverOut);
         this.giftOpenProcessedTexture = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiObj2",127),40,true,0);
         this.background = UIUtils.returnHudNotificationBackground();
         this.text = new SimpleText(16,16777215,false,0,0);
         this.text.text = "New Gift";
         this.text.updateMetrics();
         this.text.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.text.x = 27;
         this.text.y = 1;
         this.bitmap = new Bitmap(this.giftOpenProcessedTexture);
         this.bitmap.x = -5;
         this.bitmap.y = -8;
         this.drawAsOpen();
      }
      
      public function drawAsOpen() : void
      {
         addChild(this.background);
         addChild(this.text);
         addChild(this.bitmap);
      }
      
      public function drawAsClosed() : void
      {
         if(this.background && this.background.parent == this)
         {
            removeChild(this.background);
         }
         if(this.text && this.text.parent == this)
         {
            removeChild(this.text);
         }
         if(this.bitmap && this.bitmap.parent == this)
         {
            removeChild(this.bitmap);
         }
      }
      
      private function onHover(event:MouseEvent) : void
      {
         this.tooltip = new TextToolTip(3552822,10197915,null,"New Gift in Vault",200);
         this.tooltip.attachToTarget(this);
         stage.addChild(this.tooltip);
      }
      
      public function onHoverOut(event:MouseEvent) : void
      {
         if(this.tooltip)
         {
            this.tooltip.detachFromTarget();
            this.tooltip = null;
         }
      }
   }
}
