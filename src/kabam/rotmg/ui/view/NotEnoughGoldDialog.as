package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class NotEnoughGoldDialog extends Dialog
   {
      
      private static const TEXT:String = "You do not have enough Gold for this item. Would you like to buy Gold?";
      
      private static const TITLE:String = "Not Enough Gold";
      
      private static const CANCEL:String = "Cancel";
      
      private static const BUY_GOLD:String = "Buy Gold";
       
      
      public var cancel:Signal;
      
      public var buyGold:Signal;
      
      public function NotEnoughGoldDialog(message:String = "")
      {
         var text:String = message == ""?TEXT:message;
         super(text,TITLE,CANCEL,BUY_GOLD);
         this.cancel = new NativeMappedSignal(this,BUTTON1_EVENT);
         this.buyGold = new NativeMappedSignal(this,BUTTON2_EVENT);
      }
   }
}
