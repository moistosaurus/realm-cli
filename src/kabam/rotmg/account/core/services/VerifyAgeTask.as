package kabam.rotmg.account.core.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class VerifyAgeTask extends BaseTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function VerifyAgeTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         if(this.account.isRegistered())
         {
            this.sendVerifyToServer();
         }
         else
         {
            this.verifyUserAge();
         }
      }
      
      private function sendVerifyToServer() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/verifyage",this.makeDataPacket());
      }
      
      private function makeDataPacket() : Object
      {
         var data:Object = this.account.getCredentials();
         data.isAgeVerified = 1;
         return data;
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         isOK && this.verifyUserAge();
         completeTask(isOK,data);
      }
      
      private function verifyUserAge() : void
      {
         this.playerModel.setIsAgeVerified(true);
         completeTask(true);
      }
   }
}
