package kabam.rotmg.packages.view
{
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.packages.control.BuyPackageSignal;
   import kabam.rotmg.packages.services.GetPackagesTask;
   import org.osflash.signals.Signal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PackageOfferDialogMediator extends Mediator
   {
       
      
      [Inject]
      public var getPackageTask:GetPackagesTask;
      
      [Inject]
      public var view:PackageOfferDialog;
      
      [Inject]
      public var closeDialogsSignal:CloseDialogsSignal;
      
      [Inject]
      public var buyPackageSignal:BuyPackageSignal;
      
      public var viewReady:Signal;
      
      public function PackageOfferDialogMediator()
      {
         this.viewReady = new Signal();
         super();
      }
      
      override public function initialize() : void
      {
         this.view.buy.add(this.onBuy);
         this.view.close.add(this.onClose);
      }
      
      override public function destroy() : void
      {
         this.view.close.remove(this.onClose);
         this.view.close.remove(this.onBuy);
         this.view.destroy();
      }
      
      private function onBuy() : void
      {
         var packageId:int = this.view.getModel().packageID;
         this.buyPackageSignal.dispatch(packageId);
         this.closeDialogsSignal.dispatch();
      }
      
      private function onClose() : void
      {
         this.closeDialogsSignal.dispatch();
      }
   }
}
