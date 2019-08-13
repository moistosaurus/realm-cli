package kabam.rotmg.packages.services
{
   import com.company.assembleegameclient.map.QueueStatusTextSignal;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.packages.control.BuyPackageSuccessfulSignal;
   import kabam.rotmg.packages.model.PackageModel;
   import robotlegs.bender.framework.api.ILogger;
   
   public class BuyPackageTask extends BaseTask
   {
      
      private static const ERROR_MESSAGES_THAT_REFRESH:Array = ["Package is not Available","Package is not Available Right Now","Invalid PackageId"];
       
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var getPackageTask:GetPackagesTask;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var queueStatusText:QueueStatusTextSignal;
      
      [Inject]
      public var packages:Packages;
      
      [Inject]
      public var packageID:int;
      
      [Inject]
      public var buyPackageSuccessful:BuyPackageSuccessfulSignal;
      
      private var currentPackageModel:PackageModel;
      
      public function BuyPackageTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.currentPackageModel = this.packages.getPackageById(this.packageID);
         var params:Object = this.account.getCredentials();
         params.packageId = this.packageID;
         this.playerModel.changeCredits(-this.currentPackageModel.price);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/purchasePackage",params);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         var xml:XML = new XML(data);
         if(isOK)
         {
            this.completePurchase(xml);
         }
         else
         {
            this.abandonPurchase(xml);
         }
         completeTask(true,data);
      }
      
      private function completePurchase(data:XML) : void
      {
         if(this.currentPackageModel.quantity != PackageModel.INFINITE)
         {
            this.currentPackageModel.quantity--;
         }
         this.queueStatusText.dispatch("New Gifts in Vault",11495650);
         this.buyPackageSuccessful.dispatch();
         if(this.currentPackageModel.quantity <= 0)
         {
            this.getPackageTask.start();
         }
      }
      
      private function abandonPurchase(data:XML) : void
      {
         this.playerModel.changeCredits(this.currentPackageModel.price);
         this.reportFailureAndRefreshPackages(data[0]);
      }
      
      private function reportFailureAndRefreshPackages(error:String) : void
      {
         this.queueStatusText.dispatch(error,16744576);
         if(ERROR_MESSAGES_THAT_REFRESH.indexOf(error) != -1)
         {
            this.getPackageTask.start();
         }
      }
   }
}
