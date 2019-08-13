package kabam.rotmg.packages.control
{
   import kabam.rotmg.account.core.signals.OpenMoneyWindowSignal;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.packages.model.PackageModel;
   import kabam.rotmg.packages.services.Packages;
   import robotlegs.bender.framework.api.IGuard;
   
   public class IsPackageAffordableGuard implements IGuard
   {
       
      
      [Inject]
      public var player:PlayerModel;
      
      [Inject]
      public var packages:Packages;
      
      [Inject]
      public var openMoneyWindow:OpenMoneyWindowSignal;
      
      [Inject]
      public var packageId:int;
      
      public function IsPackageAffordableGuard()
      {
         super();
      }
      
      public function approve() : Boolean
      {
         var currentPackage:PackageModel = this.packages.getPackageById(this.packageId);
         var isAffordable:Boolean = this.player.getCredits() >= currentPackage.price;
         if(!isAffordable)
         {
            this.openMoneyWindow.dispatch();
         }
         return isAffordable;
      }
   }
}
