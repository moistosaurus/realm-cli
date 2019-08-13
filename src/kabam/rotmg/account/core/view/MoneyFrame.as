package kabam.rotmg.account.core.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.OfferRadioButtons;
   import com.company.assembleegameclient.account.ui.PaymentMethodRadioButtons;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.assembleegameclient.util.PaymentMethod;
   import com.company.assembleegameclient.util.offer.Offer;
   import com.company.assembleegameclient.util.offer.Offers;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.account.core.model.MoneyConfig;
   import org.osflash.signals.Signal;
   
   public class MoneyFrame extends Sprite
   {
      
      private static const TITLE:String = "Support the game and buy Realm Gold";
      
      private static const LEFT_BUTTON:String = "";
      
      private static const RIGHT_BUTTON:String = "Cancel";
      
      private static const PAYMENT_SUBTITLE:String = "Payment Method";
      
      private static const GOLD_SUBTITLE:String = "Gold Amount";
      
      private static const BUY_NOW:String = "Buy Now";
      
      private static const WIDTH:int = 550;
       
      
      public var buyNow:Signal;
      
      public var cancel:Signal;
      
      private var offers:Offers;
      
      private var config:MoneyConfig;
      
      private var frame:Frame;
      
      private var paymentMethodButtons:PaymentMethodRadioButtons;
      
      private var offerButtons:OfferRadioButtons;
      
      private var buyNowButton:TextButton;
      
      public function MoneyFrame()
      {
         super();
         this.buyNow = new Signal(Offer,String);
         this.cancel = new Signal();
      }
      
      public function initialize(offers:Offers, config:MoneyConfig) : void
      {
         this.offers = offers;
         this.config = config;
         this.frame = new Frame(TITLE,LEFT_BUTTON,RIGHT_BUTTON,WIDTH);
         config.showPaymentMethods() && this.addPaymentMethods();
         this.addOffers();
         this.addBuyNowButton();
         this.frame.rightButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         addChild(this.frame);
      }
      
      public function addPaymentMethods() : void
      {
         this.makePaymentMethodRadioButtons();
         this.frame.addTitle(PAYMENT_SUBTITLE);
         this.frame.addRadioBox(this.paymentMethodButtons);
         this.frame.addSpace(14);
         this.addLine(8355711,536,2,10);
         this.frame.addSpace(6);
      }
      
      private function makePaymentMethodRadioButtons() : void
      {
         var labels:Vector.<String> = this.makePaymentMethodLabels();
         this.paymentMethodButtons = new PaymentMethodRadioButtons(labels);
         this.paymentMethodButtons.setSelected(Parameters.data_.paymentMethod);
      }
      
      private function makePaymentMethodLabels() : Vector.<String>
      {
         var paymentMethod:PaymentMethod = null;
         var fields:Vector.<String> = new Vector.<String>();
         for each(paymentMethod in PaymentMethod.PAYMENT_METHODS)
         {
            fields.push(paymentMethod.label_);
         }
         return fields;
      }
      
      private function addLine(color:int, width:int, height:int, paddingX:int) : void
      {
         var shape:Shape = new Shape();
         shape.graphics.beginFill(color);
         shape.graphics.drawRect(paddingX,0,width - paddingX * 2,height);
         shape.graphics.endFill();
         this.frame.addComponent(shape,0);
      }
      
      private function addOffers() : void
      {
         this.offerButtons = new OfferRadioButtons(this.offers,this.config);
         this.offerButtons.showBonuses(this.config.showBonuses());
         this.frame.addTitle(GOLD_SUBTITLE);
         this.frame.addComponent(this.offerButtons);
      }
      
      public function addBuyNowButton() : void
      {
         this.buyNowButton = new TextButton(16,BUY_NOW);
         this.buyNowButton.addEventListener(MouseEvent.CLICK,this.onBuyNowClick);
         this.buyNowButton.x = 8;
         this.buyNowButton.y = this.frame.h_ - 50;
         this.frame.addChild(this.buyNowButton);
      }
      
      protected function onBuyNowClick(event:MouseEvent) : void
      {
         this.frame.disable();
         var offer:Offer = this.offerButtons.getChoice().offer;
         var paymentMethod:String = Boolean(this.paymentMethodButtons)?this.paymentMethodButtons.getSelected():null;
         this.buyNow.dispatch(offer,paymentMethod || "");
      }
      
      protected function onCancel(event:MouseEvent) : void
      {
         stage.focus = stage;
         this.cancel.dispatch();
      }
   }
}
