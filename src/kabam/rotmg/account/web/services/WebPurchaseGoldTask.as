package kabam.rotmg.account.web.services
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.PaymentMethod;
   import com.company.assembleegameclient.util.offer.Offer;
   import com.company.assembleegameclient.util.offer.Offers;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.model.OfferModel;
   import kabam.rotmg.account.core.services.PurchaseGoldTask;
   
   public class WebPurchaseGoldTask extends BaseTask implements PurchaseGoldTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var offer:Offer;
      
      [Inject]
      public var offersModel:OfferModel;
      
      [Inject]
      public var paymentMethod:String;
      
      public function WebPurchaseGoldTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var paymentMethod:PaymentMethod = null;
         Parameters.data_.paymentMethod = paymentMethod;
         Parameters.save();
         var offers:Offers = this.offersModel.offers;
         paymentMethod = PaymentMethod.getPaymentMethod(this.paymentMethod);
         var url:String = paymentMethod.getURL(offers.tok,offers.exp,this.offer);
         navigateToURL(new URLRequest(url),"_blank");
         completeTask(true);
      }
   }
}
