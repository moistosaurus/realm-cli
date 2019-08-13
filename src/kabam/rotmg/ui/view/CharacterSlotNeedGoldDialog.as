package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.osflash.signals.Signal;
   
   public class CharacterSlotNeedGoldDialog extends Sprite
   {
      
      private static const TEXT:String = "Another character slot costs ${price} Gold.  Would you like to buy Gold?";
      
      private static const TITLE:String = "Not Enough Gold";
      
      private static const CANCEL:String = "Cancel";
      
      private static const BUY_GOLD:String = "Buy Gold";
       
      
      public const buyGold:Signal = new Signal();
      
      public const cancel:Signal = new Signal();
      
      private var dialog:Dialog;
      
      private var price:int;
      
      public function CharacterSlotNeedGoldDialog()
      {
         super();
      }
      
      public function setPrice(price:int) : void
      {
         this.price = price;
         this.dialog && contains(this.dialog) && removeChild(this.dialog);
         this.makeDialog();
         this.dialog.addEventListener(Dialog.BUTTON1_EVENT,this.onCancel);
         this.dialog.addEventListener(Dialog.BUTTON2_EVENT,this.onBuyGold);
      }
      
      private function makeDialog() : void
      {
         var text:String = TEXT.replace("${price}",this.price);
         this.dialog = new Dialog(text,TITLE,CANCEL,BUY_GOLD);
         addChild(this.dialog);
      }
      
      public function onCancel(event:Event) : void
      {
         this.cancel.dispatch();
      }
      
      public function onBuyGold(event:Event) : void
      {
         this.buyGold.dispatch();
      }
   }
}
