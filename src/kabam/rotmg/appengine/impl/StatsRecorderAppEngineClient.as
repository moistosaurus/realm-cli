package kabam.rotmg.appengine.impl
{
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import org.osflash.signals.OnceSignal;
   
   public class StatsRecorderAppEngineClient extends EventDispatcher implements AppEngineClient
   {
       
      
      [Inject]
      public var stats:AppEngineRequestStats;
      
      [Inject]
      public var wrapped:SimpleAppEngineClient;
      
      private var timeAtRequest:int;
      
      private var target:String;
      
      public function StatsRecorderAppEngineClient()
      {
         super();
      }
      
      public function get complete() : OnceSignal
      {
         return this.wrapped.complete;
      }
      
      public function setDataFormat(dataFormat:String) : void
      {
         this.wrapped.setDataFormat(dataFormat);
      }
      
      public function setSendEncrypted(value:Boolean) : void
      {
         this.wrapped.setSendEncrypted(value);
      }
      
      public function setMaxRetries(value:int) : void
      {
         this.wrapped.setMaxRetries(value);
      }
      
      public function sendRequest(target:String, params:Object) : void
      {
         this.timeAtRequest = getTimer();
         this.target = target;
         this.wrapped.complete.addOnce(this.onComplete);
         this.wrapped.sendRequest(target,params);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         this.stats.recordStats(this.target,isOK,getTimer() - this.timeAtRequest);
      }
   }
}
