package kabam.rotmg.account.core.services
{
   import com.company.assembleegameclient.util.offer.Offers;
   import flash.utils.getTimer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.model.OfferModel;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetOffersTask extends BaseTask
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:OfferModel;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var client:AppEngineClient;
      
      private var target:String;
      
      private var guid:String;
      
      public function GetOffersTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.target = this.account.getRequestPrefix() + "/getoffers";
         this.guid = this.account.getUserId();
         this.updateModelRequestTimeAndGUID();
         this.sendGetOffersRequest();
      }
      
      private function updateModelRequestTimeAndGUID() : void
      {
         var time:int = getTimer();
         if(this.guid != this.model.lastOfferRequestGUID || time - this.model.lastOfferRequestTime > OfferModel.TIME_BETWEEN_REQS)
         {
            this.model.lastOfferRequestGUID = this.guid;
            this.model.lastOfferRequestTime = time;
         }
      }
      
      private function sendGetOffersRequest() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest(this.target,this.makeRequestDataPacket());
      }
      
      private function makeRequestDataPacket() : Object
      {
         var credentials:Object = this.account.getCredentials();
         credentials.time = this.model.lastOfferRequestTime;
         credentials.game_net_user_id = this.account.gameNetworkUserId();
         credentials.game_net = this.account.gameNetwork();
         credentials.play_platform = this.account.playPlatform();
         return credentials;
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onDataResponse(data);
         }
         else
         {
            this.onTextError(data);
         }
         completeTask(isOK);
      }
      
      private function onDataResponse(data:String) : void
      {
         this.model.offers = new Offers(new XML(data));
      }
      
      private function onTextError(error:String) : void
      {
         this.logger.error(error);
      }
   }
}
