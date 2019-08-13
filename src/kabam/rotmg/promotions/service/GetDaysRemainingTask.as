package kabam.rotmg.promotions.service
{
   import com.company.assembleegameclient.util.TimeUtil;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   
   public class GetDaysRemainingTask extends BaseTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:BeginnersPackageModel;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function GetDaysRemainingTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/getBeginnerPackageTimeLeft",this.account.getCredentials());
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         this.onDaysRemainingResponse(data);
      }
      
      private function onDaysRemainingResponse(data:String) : void
      {
         var time:int = TimeUtil.secondsToDays(new XML(data)[0]);
         this.model.setBeginnersOfferSecondsLeft(time);
         completeTask(time > 0);
      }
   }
}
