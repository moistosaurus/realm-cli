package kabam.rotmg.packages.view
{
   import kabam.rotmg.packages.control.OpenPackageSignal;
   import kabam.rotmg.packages.model.PackageModel;
   import kabam.rotmg.packages.services.GetPackagesTask;
   import kabam.rotmg.packages.services.Packages;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PackageButtonMediator extends Mediator
   {
       
      
      [Inject]
      public var getPackageTask:GetPackagesTask;
      
      [Inject]
      public var view:PackageButton;
      
      [Inject]
      public var packages:Packages;
      
      [Inject]
      public var openPackageSignal:OpenPackageSignal;
      
      private var model:PackageModel;
      
      public function PackageButtonMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.packages.dataChanged.add(this.onDataChanged);
         this.view.clicked.add(this.onClicked);
         this.view.init();
         if(this.packages.getInitialized())
         {
            this.setData();
         }
         else
         {
            this.view.visible = false;
            this.getPackageTask.start();
         }
      }
      
      override public function destroy() : void
      {
         this.view.clicked.remove(this.onClicked);
         this.model.quantityChanged.remove(this.onUpdateQuantity);
         this.model.durationChanged.remove(this.onUpdateDuration);
         this.model.dataChanged.remove(this.onDataChanged);
      }
      
      private function onUpdateDuration(value:int) : void
      {
         this.view.setDuration(value);
      }
      
      private function onUpdateQuantity(value:int) : void
      {
         if(value <= 0)
         {
            this.view.visible = false;
         }
         else
         {
            this.view.setQuantity(value);
         }
      }
      
      private function onDataChanged() : void
      {
         this.view.visible = true;
         this.setData();
      }
      
      private function setData() : void
      {
         this.model = this.packages.getPriorityPackage();
         this.model.quantityChanged.add(this.onUpdateQuantity);
         this.model.durationChanged.add(this.onUpdateDuration);
         this.view.setDuration(this.model.getDuration());
         this.view.setQuantity(this.model.quantity);
      }
      
      private function onClicked() : void
      {
         this.openPackageSignal.dispatch(this.packages.getPriorityPackage().packageID);
      }
   }
}
