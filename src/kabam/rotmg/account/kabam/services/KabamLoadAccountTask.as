package kabam.rotmg.account.kabam.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.LoadAccountTask;
   import kabam.rotmg.account.kabam.KabamAccount;
   import kabam.rotmg.account.kabam.model.KabamParameters;
   import kabam.rotmg.account.kabam.view.AccountLoadErrorDialog;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class KabamLoadAccountTask extends BaseTask implements LoadAccountTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var parameters:KabamParameters;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      private var kabam:KabamAccount;
      
      public function KabamLoadAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.kabam = this.account as KabamAccount;
         this.kabam.signedRequest = this.parameters.getSignedRequest();
         this.kabam.userSession = this.parameters.getUserSession();
         if(this.kabam.userSession == null)
         {
            this.openDialog.dispatch(new AccountLoadErrorDialog());
            completeTask(false);
         }
         else
         {
            this.sendRequest();
         }
      }
      
      private function sendRequest() : void
      {
         var packet:Object = {
            "signedRequest":this.kabam.signedRequest,
            "entrytag":this.account.getEntryTag()
         };
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kabam/getcredentials",packet);
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
      }
   }
}
