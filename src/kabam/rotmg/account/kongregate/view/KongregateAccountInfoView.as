package kabam.rotmg.account.kongregate.view
{
   import com.company.assembleegameclient.screens.TitleMenuOption;
   import com.company.ui.SimpleText;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.core.view.AccountInfoView;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class KongregateAccountInfoView extends Sprite implements AccountInfoView
   {
      
      private static const REGISTER:String = "register";
      
      private static const FONT_SIZE:int = 18;
      
      private static const LOGGED_IN_TEXT:String = "logged in as ${userName}";
      
      private static const GUEST_ACCOUNT_TEXT:String = "guest account - ";
       
      
      private var _register:NativeMappedSignal;
      
      private var accountText:SimpleText;
      
      private var registerButton:TitleMenuOption;
      
      private var userName:String = "";
      
      private var isRegistered:Boolean;
      
      public function KongregateAccountInfoView()
      {
         super();
         this.makeAccountText();
         this.makeActionButton();
      }
      
      private function makeAccountText() : void
      {
         this.accountText = new SimpleText(FONT_SIZE,11776947,false,0,0);
         this.accountText.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         addChild(this.accountText);
      }
      
      private function makeActionButton() : void
      {
         this.registerButton = new TitleMenuOption(REGISTER,FONT_SIZE,false);
         this._register = new NativeMappedSignal(this.registerButton,MouseEvent.CLICK);
      }
      
      public function setInfo(userName:String, isRegistered:Boolean) : void
      {
         this.userName = userName;
         this.isRegistered = isRegistered;
         this.updateUI();
      }
      
      private function updateUI() : void
      {
         this.removeUIElements();
         if(this.isRegistered)
         {
            this.refreshRegisteredAccount();
         }
         else
         {
            this.refreshUnregisteredAccount();
         }
      }
      
      private function removeUIElements() : void
      {
         while(numChildren)
         {
            removeChildAt(0);
         }
      }
      
      public function get register() : Signal
      {
         return this._register;
      }
      
      private function refreshRegisteredAccount() : void
      {
         this.accountText.text = LOGGED_IN_TEXT.replace("${userName}",this.userName);
         this.accountText.updateMetrics();
         this.addAndAlignHorizontally(this.accountText);
      }
      
      private function refreshUnregisteredAccount() : void
      {
         this.accountText.text = GUEST_ACCOUNT_TEXT;
         this.accountText.updateMetrics();
         this.addAndAlignHorizontally(this.accountText,this.registerButton);
      }
      
      private function addAndAlignHorizontally(... uiElements) : void
      {
         var ui:DisplayObject = null;
         var x:int = 0;
         var i:int = uiElements.length;
         while(i--)
         {
            ui = uiElements[i];
            x = x - ui.width;
            ui.x = x;
            addChild(ui);
         }
      }
   }
}
