package kabam.rotmg.promotions.view
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.ui.UIUtils;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class BeginnersPackageButton extends Sprite
   {
      
      private static const FONT_SIZE:int = 16;
       
      
      public var click:Signal;
      
      private var timeLeftText:SimpleText;
      
      private var lootIcon:Bitmap;
      
      private var daysRemaining:int = -1;
      
      private var clickArea:Sprite;
      
      public function BeginnersPackageButton()
      {
         super();
         this.clickArea = UIUtils.returnHudNotificationBackground();
         this.click = new NativeMappedSignal(this.clickArea,MouseEvent.CLICK);
         tabChildren = false;
         tabEnabled = false;
         this.makeUI();
      }
      
      public function setDaysRemaining(days:int) : void
      {
         if(this.daysRemaining != days)
         {
            this.daysRemaining = days;
            this.updateTimeLeftPosition();
         }
      }
      
      public function destroy() : void
      {
         parent.removeChild(this);
      }
      
      private function makeUI() : void
      {
         addChild(this.clickArea);
         this.makeLootIcon();
         this.makeTimeLeftText();
         this.setDaysRemaining(0);
      }
      
      private function makeLootIcon() : void
      {
         var lootBD:BitmapData = AssetLibrary.getImageFromSet("redLootBag",0);
         lootBD = TextureRedrawer.redraw(lootBD,40,true,0,0);
         this.lootIcon = new Bitmap(lootBD);
         this.lootIcon.x = -5;
         this.lootIcon.y = -8;
         addChild(this.lootIcon);
      }
      
      private function makeTimeLeftText() : void
      {
         this.timeLeftText = new SimpleText(FONT_SIZE,16777215,false,0,0);
         this.timeLeftText.filters = [new DropShadowFilter(0,0,0)];
         this.updateTimeLeftPosition();
         addChild(this.timeLeftText);
      }
      
      private function updateTimeLeftPosition() : void
      {
         this.timeLeftText.text = this.daysRemaining.toString() + " day" + (this.daysRemaining > 1?"s":"");
         this.timeLeftText.x = 27;
         this.timeLeftText.y = 0;
      }
   }
}
