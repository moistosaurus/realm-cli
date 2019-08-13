package kabam.rotmg.account.steam.services
{
   import com.company.assembleegameclient.ui.dialogs.DebugDialog;
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.PurchaseGoldTask;
   import kabam.rotmg.account.steam.SteamApi;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class SteamPurchaseGoldTask extends BaseTask implements PurchaseGoldTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var steam:SteamApi;
      
      [Inject]
      public var offer:Offer;
      
      [Inject]
      public var paymentMethod:String;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var first:AppEngineClient;
      
      [Inject]
      public var second:AppEngineClient;
      
      public function SteamPurchaseGoldTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.debug("SteamPurchaseGoldTask startTask");
         this.steam.paymentAuthorized.addOnce(this.onPaymentAuthorized);
         this.first.setMaxRetries(2);
         this.first.complete.addOnce(this.onComplete);
         this.first.sendRequest("/steamworks/purchaseOffer",{
            "steamid":this.steam.getSteamId(),
            "data":this.offer.data_
         });
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onPurchaseOfferComplete();
         }
         else
         {
            this.reportError(data);
         }
      }
      
      private function onPurchaseOfferComplete() : void
      {
         this.logger.debug("SteamPurchaseGoldTask purchaseOffer confirmed by AppEngine");
      }
      
      private function onPaymentAuthorized(appID:uint, orderID:String, isAuthorized:Boolean) : void
      {
         this.logger.debug("SteamPurchaseGoldTask payment authorized by Steam");
         this.second.setMaxRetries(2);
         this.second.complete.addOnce(this.onAuthorized);
         this.second.sendRequest("/steamworks/finalizePurchase",{
            "appid":appID,
            "orderid":orderID,
            "authorized":(!!isAuthorized?1:0)
         });
      }
      
      private function onAuthorized(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onPurchaseFinalizeComplete();
         }
         else
         {
            this.reportError(data);
         }
      }
      
      private function onPurchaseFinalizeComplete() : void
      {
         this.logger.debug("SteamPurchaseGoldTask purchase finalized");
         completeTask(true);
      }
      
      private function reportError(error:String) : void
      {
         var message:String = "Error: " + error;
         this.logger.debug("finalize error {0}",[message]);
         this.openDialog.dispatch(new DebugDialog(message));
         completeTask(false);
      }
   }
}
