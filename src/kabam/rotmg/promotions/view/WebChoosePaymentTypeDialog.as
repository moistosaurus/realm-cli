package kabam.rotmg.promotions.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.lib.ui.GroupMappedSignal;
   import kabam.rotmg.promotions.view.components.TransparentButton;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebChoosePaymentTypeDialog extends Sprite
   {
      
      public static var hifiBeginnerOfferMoneyFrameEmbed:Class = WebChoosePaymentTypeDialog_hifiBeginnerOfferMoneyFrameEmbed;
       
      
      public var close:Signal;
      
      public var select:GroupMappedSignal;
      
      public function WebChoosePaymentTypeDialog()
      {
         super();
         this.close = new Signal();
         this.select = new GroupMappedSignal(MouseEvent.CLICK,String);
         this.makeBackground();
         this.makeCloseButton();
         this.makePaymentSelection();
      }
      
      public function centerOnScreen() : void
      {
         x = (stage.stageWidth - width) * 0.5;
         y = (stage.stageHeight - height) * 0.5 - 5;
      }
      
      private function makeBackground() : void
      {
         addChild(new hifiBeginnerOfferMoneyFrameEmbed());
      }
      
      private function makeCloseButton() : void
      {
         var closeBtn:Sprite = this.makeTransparentButton(550,30,30,30);
         this.close = new NativeMappedSignal(closeBtn,MouseEvent.CLICK);
      }
      
      private function makePaymentSelection() : void
      {
         var paypal:Sprite = this.makeTransparentButton(220,180,180,35);
         var creditCard:Sprite = this.makeTransparentButton(220,224,180,35);
         var google:Sprite = this.makeTransparentButton(220,268,180,35);
         this.select.map(paypal,"PayPal");
         this.select.map(creditCard,"Credit Cards, etc.");
         this.select.map(google,"Google Checkout");
      }
      
      private function makeTransparentButton(x:int, y:int, width:int, height:int) : Sprite
      {
         var button:TransparentButton = new TransparentButton(x,y,width,height);
         addChild(button);
         return button;
      }
   }
}
