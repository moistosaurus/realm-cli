package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.LoginTask;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class KongregateLoginTask extends BaseTask implements LoginTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var api:KongregateApi;
      
      [Inject]
      public var local:KongregateSharedObject;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function KongregateLoginTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/getcredentials",this.api.getAuthentication());
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         isOK && this.onGetCredentialsDone(data);
         completeTask(isOK,data);
      }
      
      private function onGetCredentialsDone(data:String) : void
      {
         var xml:XML = new XML(data);
         this.account.updateUser(xml.GUID,xml.Secret);
         this.account.setPlatformToken(xml.PlatformToken);
         completeTask(true);
      }
   }
}
