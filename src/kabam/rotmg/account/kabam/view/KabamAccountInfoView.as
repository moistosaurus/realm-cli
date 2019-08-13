package kabam.rotmg.account.kabam.view
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.core.view.AccountInfoView;
   
   public class KabamAccountInfoView extends Sprite implements AccountInfoView
   {
      
      private static const ACCOUNT_INFO:String = "logged in as ${userName} on Kabam.com";
      
      private static const FONT_SIZE:int = 18;
       
      
      private var accountText:SimpleText;
      
      private var userName:String = "";
      
      private var isRegistered:Boolean;
      
      public function KabamAccountInfoView()
      {
         super();
         this.makeAccountText();
      }
      
      private function makeAccountText() : void
      {
         this.accountText = new SimpleText(FONT_SIZE,11776947,false,0,0);
         this.accountText.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         addChild(this.accountText);
      }
      
      public function setInfo(userName:String, isRegistered:Boolean) : void
      {
         this.userName = userName;
         this.isRegistered = isRegistered;
         this.accountText.text = ACCOUNT_INFO.replace("${userName}",userName);
         this.accountText.updateMetrics();
         this.accountText.x = -this.accountText.width;
      }
   }
}
