package kabam.rotmg.account.steam.model
{
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.rotmg.account.core.model.MoneyConfig;
   
   public class SteamMoneyConfig implements MoneyConfig
   {
       
      
      public function SteamMoneyConfig()
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
         return offer.price_ + offer.currency_;
      }
      
      public function jsInitializeFunction() : String
      {
         throw new Error("No current support for new Kabam offer wall on Steam.");
      }
   }
}
