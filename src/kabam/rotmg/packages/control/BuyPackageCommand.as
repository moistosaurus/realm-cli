package kabam.rotmg.packages.control
{
   import kabam.lib.tasks.TaskMonitor;
   import kabam.rotmg.packages.services.BuyPackageTask;
   
   public class BuyPackageCommand
   {
       
      
      [Inject]
      public var buyPackageTask:BuyPackageTask;
      
      [Inject]
      public var taskMonitor:TaskMonitor;
      
      [Inject]
      public var packageId:int;
      
      public function BuyPackageCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.buyPackage();
      }
      
      private function buyPackage() : void
      {
         this.taskMonitor.add(this.buyPackageTask);
         this.buyPackageTask.start();
      }
   }
}
