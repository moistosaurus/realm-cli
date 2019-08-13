package kabam.rotmg.account.kabam.model
{
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.rotmg.account.core.model.MoneyConfig;
   
   public class KabamMoneyConfig implements MoneyConfig
   {
       
      
      public function KabamMoneyConfig()
      {
         super();
      }
      
      public function showPaymentMethods() : Boolean
      {
         return true;
      }
      
      public function showBonuses() : Boolean
      {
         return false;
      }
      
      public function parseOfferPrice(offer:Offer) : String
      {
         return "";
      }
      
      public function jsInitializeFunction() : String
      {
         return "rotmg.KabamPayment.setupKabamAccount";
      }
   }
}
