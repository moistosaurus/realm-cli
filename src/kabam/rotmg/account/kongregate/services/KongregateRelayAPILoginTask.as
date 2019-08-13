package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.RelayLoginTask;
   import kabam.rotmg.account.kongregate.signals.KongregateAlreadyRegisteredSignal;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class KongregateRelayAPILoginTask extends BaseTask implements RelayLoginTask
   {
      
      public static const ALREADY_REGISTERED:String = "Kongregate account already registered";
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var api:KongregateApi;
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var alreadyRegistered:KongregateAlreadyRegisteredSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function KongregateRelayAPILoginTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/internalRegister",this.makeDataPacket());
      }
      
      private function makeDataPacket() : Object
      {
         var obj:Object = this.api.getAuthentication();
         obj.guid = this.account.getUserId();
         return obj;
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onInternalRegisterDone(data);
         }
         else if(data == ALREADY_REGISTERED)
         {
            this.alreadyRegistered.dispatch(this.data);
         }
         completeTask(isOK,data);
      }
      
      private function onInternalRegisterDone(data:String) : void
      {
         var xml:XML = new XML(data);
         this.account.updateUser(xml.GUID,xml.Secret);
         this.account.setPlatformToken(xml.PlatformToken);
      }
   }
}
