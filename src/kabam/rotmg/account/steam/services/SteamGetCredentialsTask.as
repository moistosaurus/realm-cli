package kabam.rotmg.account.steam.services
{
   import com.company.assembleegameclient.ui.dialogs.DebugDialog;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.steam.SteamApi;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class SteamGetCredentialsTask extends BaseTask
   {
      
      private static const ERROR_TEMPLATE:String = "Error: ${error}";
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var steam:SteamApi;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function SteamGetCredentialsTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var token:Object = this.steam.getSessionAuthentication();
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/steamworks/getcredentials",token);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onGetCredentialsDone(data);
         }
         else
         {
            this.onGetCredentialsError(data);
         }
         completeTask(isOK,data);
      }
      
      private function onGetCredentialsDone(data:String) : void
      {
         var xml:XML = new XML(data);
         this.account.updateUser(xml.GUID,xml.Secret);
         this.account.setPlatformToken(xml.PlatformToken);
      }
      
      private function onGetCredentialsError(data:String) : void
      {
         var text:String = ERROR_TEMPLATE.replace("${error}",data);
         var dialog:DebugDialog = new DebugDialog(text);
         this.openDialog.dispatch(dialog);
      }
   }
}
