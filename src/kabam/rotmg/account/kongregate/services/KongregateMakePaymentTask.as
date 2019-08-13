package kabam.rotmg.account.kongregate.services
{
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.PaymentData;
   import kabam.rotmg.account.core.services.MakePaymentTask;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   
   public class KongregateMakePaymentTask extends BaseTask implements MakePaymentTask
   {
       
      
      [Inject]
      public var payment:PaymentData;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var api:KongregateApi;
      
      public function KongregateMakePaymentTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var offer:Offer = this.payment.offer;
         var data:Object = {
            "identifier":offer.id_,
            "data":offer.data_
         };
         this.api.purchaseResponse.addOnce(this.onPurchaseResult);
         this.api.purchaseItems(data);
      }
      
      private function onPurchaseResult(object:Object) : void
      {
         completeTask(true);
      }
   }
}
