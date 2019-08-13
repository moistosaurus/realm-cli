package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.LinkAccountsTask;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class KongregateLinkAccountsTask extends BaseTask implements LinkAccountsTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var api:KongregateApi;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function KongregateLinkAccountsTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/link",this.makeDataPacket());
      }
      
      private function makeDataPacket() : Object
      {
         var obj:Object = this.api.getAuthentication();
         obj.guid = this.data.username;
         obj.password = this.data.password;
         return obj;
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         isOK && this.onLinkDone(data);
         completeTask(isOK,data);
      }
      
      private function onLinkDone(data:String) : void
      {
         var xml:XML = new XML(data);
         this.account.updateUser(xml.GUID,xml.Secret);
         this.account.setPlatformToken(xml.PlatformToken);
      }
   }
}
