package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.SendConfirmEmailAddressTask;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class WebSendVerificationEmailTask extends BaseTask implements SendConfirmEmailAddressTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebSendVerificationEmailTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/sendVerifyEmail",this.account.getCredentials());
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onSent();
         }
         else
         {
            this.onError(data);
         }
      }
      
      private function onSent() : void
      {
         completeTask(true);
      }
      
      private function onError(error:String) : void
      {
         this.account.clear();
         completeTask(false);
      }
   }
}
