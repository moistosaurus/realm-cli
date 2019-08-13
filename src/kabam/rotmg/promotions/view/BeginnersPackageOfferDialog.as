package kabam.rotmg.promotions.view
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.promotions.view.components.TransparentButton;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class BeginnersPackageOfferDialog extends Sprite
   {
      
      public static const TIME_REMAINING:String = "${TIME} day${PLURAL} left!";
      
      public static var hifiBeginnerOfferEmbed:Class = BeginnersPackageOfferDialog_hifiBeginnerOfferEmbed;
       
      
      public var close:Signal;
      
      public var buy:Signal;
      
      private var timeText:SimpleText;
      
      public function BeginnersPackageOfferDialog()
      {
         super();
         this.makeBackground();
         this.makeOfferText();
         this.makeCloseButton();
         this.makeBuyButton();
      }
      
      public function setTimeRemaining(timeRemaining:int) : void
      {
         var text:String = TIME_REMAINING.replace("${TIME}",timeRemaining).replace("${PLURAL}",timeRemaining > 1?"s":"");
         this.timeText.text = text;
      }
      
      public function centerOnScreen() : void
      {
         x = (stage.stageWidth - width) * 0.5;
         y = (stage.stageHeight - height) * 0.5;
      }
      
      private function makeBackground() : void
      {
         addChild(new hifiBeginnerOfferEmbed());
      }
      
      private function makeOfferText() : void
      {
         this.timeText = new SimpleText(14,14928128,false,0,0);
         this.timeText.setBold(true);
         this.timeText.x = 307;
         this.timeText.y = 380;
         addChild(this.timeText);
      }
      
      private function makeBuyButton() : void
      {
         var buyBtn:Sprite = this.makeTransparentTargetButton(270,400,150,40);
         this.buy = new NativeMappedSignal(buyBtn,MouseEvent.CLICK);
      }
      
      private function makeCloseButton() : void
      {
         var closeBtn:Sprite = this.makeTransparentTargetButton(550,30,30,30);
         this.close = new NativeMappedSignal(closeBtn,MouseEvent.CLICK);
      }
      
      private function makeTransparentTargetButton(x:int, y:int, width:int, height:int) : Sprite
      {
         var button:TransparentButton = new TransparentButton(x,y,width,height);
         addChild(button);
         return button;
      }
   }
}
