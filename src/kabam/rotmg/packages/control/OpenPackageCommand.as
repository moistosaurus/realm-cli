package kabam.rotmg.packages.control
{
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.packages.model.PackageModel;
   import kabam.rotmg.packages.services.Packages;
   import kabam.rotmg.packages.view.PackageOfferDialog;
   import robotlegs.bender.bundles.mvcs.Command;
   
   public class OpenPackageCommand extends Command
   {
       
      
      [Inject]
      public var openDialogSignal:OpenDialogSignal;
      
      [Inject]
      public var packages:Packages;
      
      [Inject]
      public var packageId:int;
      
      [Inject]
      public var alreadyBoughtPackage:AlreadyBoughtPackageSignal;
      
      public function OpenPackageCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var packageModel:PackageModel = this.packages.getPackageById(this.packageId);
         if(!packageModel)
         {
            return;
         }
         if(packageModel.canPurchase())
         {
            this.openDialogSignal.dispatch(new PackageOfferDialog().setModel(packageModel));
         }
         else
         {
            this.alreadyBoughtPackage.dispatch();
         }
      }
   }
}
