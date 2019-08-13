package kabam.rotmg.account.steam.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.RegisterAccountTask;
   import kabam.rotmg.account.steam.SteamApi;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import robotlegs.bender.framework.api.ILogger;
   
   public class SteamRegisterAccountTask extends BaseTask implements RegisterAccountTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var api:SteamApi;
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      private var client:AppEngineClient;
      
      public function SteamRegisterAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.debug("startTask");
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/register",this.makeDataPacket());
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onRegisterDone(data);
         }
         else
         {
            this.onRegisterError(data);
         }
      }
      
      private function makeDataPacket() : Object
      {
         var obj:Object = this.api.getSessionAuthentication();
         obj.newGUID = this.data.username;
         obj.newPassword = this.data.password;
         obj.entrytag = this.account.getEntryTag();
         return obj;
      }
      
      private function onRegisterDone(data:String) : void
      {
         var xml:XML = new XML(data);
         this.logger.debug("done - {0}",[xml.GUID]);
         this.account.updateUser(xml.GUID,xml.Secret);
         this.account.setPlatformToken(xml.PlatformToken);
         completeTask(true);
      }
      
      private function onRegisterError(error:String) : void
      {
         this.logger.debug("error - {0}",[error]);
         completeTask(false,error);
      }
   }
}
