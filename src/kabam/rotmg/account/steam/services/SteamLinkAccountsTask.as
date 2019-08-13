package kabam.rotmg.account.steam.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.LinkAccountsTask;
   import kabam.rotmg.account.steam.SteamApi;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class SteamLinkAccountsTask extends BaseTask implements LinkAccountsTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var api:SteamApi;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function SteamLinkAccountsTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/steamworks/link",this.makeDataPacket());
      }
      
      private function makeDataPacket() : Object
      {
         var obj:Object = this.api.getSessionAuthentication();
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
