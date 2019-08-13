package kabam.rotmg.appengine.impl
{
   import flash.utils.getTimer;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import org.osflash.signals.OnceSignal;
   
   public class TrackingAppEngineClient implements AppEngineClient
   {
      [Inject]
      public var wrapped:SimpleAppEngineClient;
      
      private var target:String;
      
      private var time:int;
      
      public function TrackingAppEngineClient()
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
         this.target = target;
         this.time = getTimer();
         this.wrapped.sendRequest(target,params);
      }
   }
}
