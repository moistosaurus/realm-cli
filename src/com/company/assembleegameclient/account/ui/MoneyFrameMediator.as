package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.lib.tasks.Task;
   import kabam.rotmg.account.core.model.MoneyConfig;
   import kabam.rotmg.account.core.model.OfferModel;
   import kabam.rotmg.account.core.services.GetOffersTask;
   import kabam.rotmg.account.core.signals.PurchaseGoldSignal;
   import kabam.rotmg.account.core.view.MoneyFrame;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   import robotlegs.bender.framework.api.ILogger;
   
   public class MoneyFrameMediator extends Mediator
   {
       
      
      [Inject]
      public var view:MoneyFrame;
      
      [Inject]
      public var model:OfferModel;
      
      [Inject]
      public var config:MoneyConfig;
      
      [Inject]
      public var purchaseGold:PurchaseGoldSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var getOffers:GetOffersTask;
      
      [Inject]
      public var logger:ILogger;
      
      public function MoneyFrameMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.buyNow.add(this.onBuyNow);
         this.view.cancel.add(this.onCancel);
         this.initializeViewWhenOffersAreAvailable();
      }
      
      private function initializeViewWhenOffersAreAvailable() : void
      {
         if(this.model.offers)
         {
            this.view.initialize(this.model.offers,this.config);
         }
         else
         {
            this.requestOffersData();
         }
      }
      
      private function requestOffersData() : void
      {
         this.getOffers.finished.addOnce(this.onOffersReceived);
         this.getOffers.start();
      }
      
      private function onOffersReceived(task:Task, isOK:Boolean, error:String = "") : void
      {
         if(isOK)
         {
            this.view.initialize(this.model.offers,this.config);
         }
         else
         {
            this.openDialog.dispatch(new ErrorDialog("Unable to get gold offer information"));
         }
      }
      
      override public function destroy() : void
      {
         this.view.buyNow.add(this.onBuyNow);
         this.view.cancel.add(this.onCancel);
      }
      
      protected function onBuyNow(offer:Offer, paymentMethod:String) : void
      {
         this.logger.info("offer {0}, paymentMethod {1}",[offer,paymentMethod]);
         this.purchaseGold.dispatch(offer,paymentMethod);
      }
      
      protected function onCancel() : void
      {
         this.closeDialogs.dispatch();
      }
   }
}
