package kabam.rotmg.promotions.model
{
   import com.company.assembleegameclient.util.TimeUtil;
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.model.OfferModel;
   import org.osflash.signals.Signal;
   
   public class BeginnersPackageModel
   {
      
      private static const REALM_GOLD_FOR_BEGINNERS_PKG:int = 2600;
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:OfferModel;
      
      public var markedAsPurchased:Signal;
      
      private var beginnersOfferTimeLeft:Number;
      
      public function BeginnersPackageModel()
      {
         this.markedAsPurchased = new Signal();
         super();
      }
      
      public function isBeginnerAvailable() : Boolean
      {
         return this.beginnersOfferTimeLeft > 0;
      }
      
      public function setBeginnersOfferSecondsLeft(value:Number) : void
      {
         this.beginnersOfferTimeLeft = value;
      }
      
      public function getBeginnersOfferTimeLeft() : Number
      {
         return this.beginnersOfferTimeLeft;
      }
      
      public function getDaysRemaining() : Number
      {
         return Math.ceil(TimeUtil.secondsToDays(this.getBeginnersOfferTimeLeft()));
      }
      
      public function getOffer() : Offer
      {
         var offer:Offer = null;
         if(!this.model.offers)
         {
            return null;
         }
         for each(offer in this.model.offers.offerList)
         {
            if(offer.realmGold_ == REALM_GOLD_FOR_BEGINNERS_PKG)
            {
               return offer;
            }
         }
         return null;
      }
      
      public function markAsPurchased() : void
      {
         this.setBeginnersOfferSecondsLeft(-1);
         this.markedAsPurchased.dispatch();
      }
   }
}
