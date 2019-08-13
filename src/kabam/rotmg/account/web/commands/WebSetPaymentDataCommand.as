package kabam.rotmg.account.web.commands
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.web.WebAccount;
   
   public class WebSetPaymentDataCommand
   {
       
      
      [Inject]
      public var characterListData:XML;
      
      [Inject]
      public var account:Account;
      
      public function WebSetPaymentDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var payInfo:XML = null;
         var webAccount:WebAccount = this.account as WebAccount;
         if(this.characterListData.hasOwnProperty("KabamPaymentInfo"))
         {
            payInfo = XML(this.characterListData.KabamPaymentInfo);
            webAccount.signedRequest = payInfo.signedRequest;
            webAccount.kabamId = payInfo.naid;
         }
      }
   }
}
