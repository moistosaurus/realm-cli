package kabam.rotmg.account.kongregate.services
{
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.services.PurchaseGoldTask;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   
   public class KongregatePurchaseGoldTask extends BaseTask implements PurchaseGoldTask
   {
       
      
      [Inject]
      public var offer:Offer;
      
      [Inject]
      public var api:KongregateApi;
      
      public function KongregatePurchaseGoldTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var data:Object = {
            "identifier":this.offer.id_,
            "data":this.offer.data_
         };
         this.api.purchaseResponse.addOnce(this.onPurchaseResult);
         this.api.purchaseItems(data);
      }
      
      private function onPurchaseResult(data:Object) : void
      {
         completeTask(true);
      }
   }
}
