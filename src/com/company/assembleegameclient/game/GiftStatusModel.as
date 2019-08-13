package com.company.assembleegameclient.game
{
   import kabam.rotmg.game.signals.UpdateGiftStatusDisplaySignal;
   
   public class GiftStatusModel
   {
       
      
      [Inject]
      public var updateGiftStatusDisplay:UpdateGiftStatusDisplaySignal;
      
      public var hasGift:Boolean;
      
      public function GiftStatusModel()
      {
         super();
      }
      
      public function setHasGift(value:Boolean) : void
      {
         this.hasGift = value;
         this.updateGiftStatusDisplay.dispatch();
      }
   }
}
