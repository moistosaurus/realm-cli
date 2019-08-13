package kabam.rotmg.packages.services
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.display.Loader.LoaderProxy;
   import kabam.display.Loader.LoaderProxyConcrete;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.packages.model.PackageModel;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetPackagesTask extends BaseTask
   {
      
      private static const HOUR:int = 1000 * 60 * 60;
       
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var packages:Packages;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logger:ILogger;
      
      var loader:LoaderProxy;
      
      var timer:Timer;
      
      public function GetPackagesTask()
      {
         this.loader = new LoaderProxyConcrete();
         this.timer = new Timer(HOUR);
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.sendRequest("/package/getPackages",this.account.getCredentials());
         this.client.complete.addOnce(this.onComplete);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         var packagesXML:XML = null;
         if(isOK)
         {
            if(String(data) == "<NoPackage/>")
            {
               this.logger.info("GetPackageTask.onComplete: No package available, retrying in 1 hour.");
               completeTask(true);
               this.timer.addEventListener(TimerEvent.TIMER,this.timer_timerHandler);
               this.timer.start();
               return;
            }
            packagesXML = XML(data);
            this.parse(packagesXML);
            completeTask(true);
         }
         else
         {
            this.logger.warn("GetPackageTask.onComplete: Request failed.");
            completeTask(false);
         }
      }
      
      private function parse(packagesXML:XML) : void
      {
         var _package:XML = null;
         var packageID:int = 0;
         var name:String = null;
         var price:int = 0;
         var quantity:int = 0;
         var max:int = 0;
         var priority:int = 0;
         var endDate:Date = null;
         var imageURL:String = null;
         var numPurchased:int = 0;
         var model:PackageModel = null;
         var models:Array = [];
         for each(_package in packagesXML.Packages.Package)
         {
            packageID = int(_package.@id);
            name = String(_package.Name);
            price = int(_package.Price);
            quantity = int(_package.Quantity);
            max = int(_package.MaxPurchase);
            priority = int(_package.Weight);
            endDate = new Date(String(_package.EndDate));
            imageURL = String(_package.BgURL);
            numPurchased = this.getNumPurchased(packagesXML,packageID);
            model = new PackageModel();
            model.setData(packageID,endDate,name,quantity,max,priority,price,imageURL,numPurchased);
            models.push(model);
         }
         this.packages.setModels(models);
      }
      
      private function getNumPurchased(packagesXML:XML, packageID:int) : int
      {
         var packageHistory:XMLList = null;
         var numPurchased:int = 0;
         var history:XMLList = packagesXML.History;
         if(history)
         {
            packageHistory = history.Package.(@id == packageID);
            if(packageHistory)
            {
               numPurchased = int(packageHistory.Count);
            }
         }
         return numPurchased;
      }
      
      private function timer_timerHandler(event:TimerEvent) : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.timer_timerHandler);
         this.timer.stop();
         this.startTask();
      }
   }
}
