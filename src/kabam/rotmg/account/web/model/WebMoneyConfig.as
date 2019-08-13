package kabam.rotmg.account.web.model
{
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.rotmg.account.core.model.MoneyConfig;
   
   public class WebMoneyConfig implements MoneyConfig
   {
       
      
      public function WebMoneyConfig()
      {
         super();
      }
      
      public function showPaymentMethods() : Boolean
      {
         return true;
      }
      
      public function showBonuses() : Boolean
      {
         return true;
      }
      
      public function parseOfferPrice(offer:Offer) : String
      {
         return "$" + offer.price_;
      }
      
      public function jsInitializeFunction() : String
      {
         return "rotmg.KabamPayment.setupRotmgAccount";
      }
   }
}
