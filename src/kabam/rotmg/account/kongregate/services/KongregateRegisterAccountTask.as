package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.RegisterAccountTask;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class KongregateRegisterAccountTask extends BaseTask implements RegisterAccountTask
   {
       
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var api:KongregateApi;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function KongregateRegisterAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/register",this.makeDataPacket());
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         isOK && this.onInternalRegisterDone(data);
         completeTask(isOK,data);
      }
      
      private function makeDataPacket() : Object
      {
         var obj:Object = this.api.getAuthentication();
         obj.newGUID = this.data.username;
         obj.newPassword = this.data.password;
         obj.entrytag = this.account.getEntryTag();
         return obj;
      }
      
      private function onInternalRegisterDone(data:String) : void
      {
         this.updateAccount(data);
      }
      
      private function updateAccount(data:String) : void
      {
         var xml:XML = new XML(data);
         this.account.updateUser(xml.GUID,xml.Secret);
         this.account.setPlatformToken(xml.PlatformToken);
      }
   }
}
