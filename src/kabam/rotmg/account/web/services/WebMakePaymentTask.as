package kabam.rotmg.account.web.services
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.PaymentMethod;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.PaymentData;
   import kabam.rotmg.account.core.model.OfferModel;
   import kabam.rotmg.account.core.services.MakePaymentTask;
   
   public class WebMakePaymentTask extends BaseTask implements MakePaymentTask
   {
       
      
      [Inject]
      public var data:PaymentData;
      
      [Inject]
      public var model:OfferModel;
      
      public function WebMakePaymentTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         Parameters.data_.paymentMethod = this.data.paymentMethod;
         Parameters.save();
         var paymentMethod:PaymentMethod = PaymentMethod.getPaymentMethod(this.data.paymentMethod);
         var url:String = paymentMethod.getURL(this.model.offers.tok,this.model.offers.exp,this.data.offer);
         navigateToURL(new URLRequest(url),"_blank");
         completeTask(true);
      }
   }
}
