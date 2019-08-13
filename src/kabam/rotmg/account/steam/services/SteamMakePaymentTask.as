package kabam.rotmg.account.steam.services
{
   import com.company.assembleegameclient.ui.dialogs.DebugDialog;
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.PaymentData;
   import kabam.rotmg.account.core.services.MakePaymentTask;
   import kabam.rotmg.account.steam.SteamApi;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class SteamMakePaymentTask extends BaseTask implements MakePaymentTask
   {
       
      
      [Inject]
      public var steam:SteamApi;
      
      [Inject]
      public var payment:PaymentData;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var second:AppEngineClient;
      
      private var offer:Offer;
      
      public function SteamMakePaymentTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.debug("start task");
         this.offer = this.payment.offer;
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/steamworks/purchaseOffer",{
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
            this.onPurchaseOfferError(data);
         }
      }
      
      private function onPurchaseOfferComplete() : void
      {
         this.logger.debug("purchaseOffer complete");
         this.steam.paymentAuthorized.addOnce(this.onPaymentAuthorized);
      }
      
      private function onPaymentAuthorized(appID:uint, orderID:String, isAuthorized:Boolean) : void
      {
         this.logger.debug("payment authorized {0},{1},{2}",[appID,orderID,isAuthorized]);
         this.second.setMaxRetries(2);
         this.client.complete.addOnce(this.onAuthorized);
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
            this.onPurchaseFinalizeError(data);
         }
      }
      
      private function onPurchaseFinalizeComplete() : void
      {
         this.logger.debug("purchaseFinalized complete");
         completeTask(true);
      }
      
      private function onPurchaseFinalizeError(error:String) : void
      {
         this.logger.debug("purchaseFinalized error {0}",[error]);
         this.openDialog.dispatch(new DebugDialog("Error: " + error));
         completeTask(false);
      }
      
      private function onPurchaseOfferError(error:String) : void
      {
         this.logger.debug("purchaseOffer request error {0}",[error]);
         trace("[ ERROR ] - Received a failed response from the GAE server indicating the purchaseOffer request did not complete without a problem.");
         this.openDialog.dispatch(new DebugDialog("Error: " + error));
         completeTask(false);
      }
   }
}
