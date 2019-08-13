package kabam.rotmg.account.kongregate.model
{
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.rotmg.account.core.model.MoneyConfig;
   
   public class KongregateMoneyConfig implements MoneyConfig
   {
       
      
      public function KongregateMoneyConfig()
      {
         super();
      }
      
      public function showPaymentMethods() : Boolean
      {
         return false;
      }
      
      public function showBonuses() : Boolean
      {
         return false;
      }
      
      public function parseOfferPrice(offer:Offer) : String
      {
         return offer.price_ + " Kreds";
      }
      
      public function jsInitializeFunction() : String
      {
         throw new Error("No current support for new Kabam offer wall on Kongregate.");
      }
   }
}
