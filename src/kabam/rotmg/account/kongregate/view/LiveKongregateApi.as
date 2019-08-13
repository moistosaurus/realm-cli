package kabam.rotmg.account.kongregate.view
{
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.Security;
   import kabam.rotmg.account.kongregate.services.KongregateSharedObject;
   import kabam.rotmg.account.kongregate.signals.RelayApiLoginSignal;
   import org.osflash.signals.Signal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class LiveKongregateApi extends Sprite implements KongregateApi
   {
       
      
      [Inject]
      public var local:KongregateSharedObject;
      
      [Inject]
      public var apiLogin:RelayApiLoginSignal;
      
      [Inject]
      public var logger:ILogger;
      
      private var _loaded:Signal;
      
      private var _purchaseResponse:Signal;
      
      private var loader:Loader;
      
      private var api;
      
      public function LiveKongregateApi()
      {
         super();
         this._loaded = new Signal();
         this._purchaseResponse = new Signal(Object);
      }
      
      public function load(path:String) : void
      {
         Security.allowDomain(path);
         this.logger.info("kongregate api loading");
         addChild(this.loader = new Loader());
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAPILoaded);
         this.loader.load(new URLRequest(path));
      }
      
      private function onAPILoaded(event:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onAPILoaded);
         this.api = event.target.content;
         this.api.services.connect();
         this.addExternalLoginListenerForGuestUser();
         this.loaded.dispatch();
         this.logger.info("kongregate api loaded");
      }
      
      private function addExternalLoginListenerForGuestUser() : void
      {
         if(this.api.services.isGuest())
         {
            this.logger.info("kongregate guest detected - listening for external login");
            this.api.services.addEventListener("login",this.onExternalLogin);
         }
      }
      
      private function onExternalLogin(event:Event) : void
      {
         this.logger.info("external login from kongregate detected");
         this.apiLogin.dispatch();
      }
      
      public function get loaded() : Signal
      {
         return this._loaded;
      }
      
      public function showRegistrationDialog() : void
      {
         this.logger.info("showRegistrationBox request sent to kongregate");
         this.api.services.showRegistrationBox();
      }
      
      public function isGuest() : Boolean
      {
         return this.api.services.isGuest();
      }
      
      public function getAuthentication() : Object
      {
         var obj:Object = {};
         obj.userId = this.api.services.getUserId();
         obj.username = this.api.services.getUsername();
         obj.gameAuthToken = this.api.services.getGameAuthToken();
         return obj;
      }
      
      public function reportStatistic(name:String, value:int) : void
      {
         this.api.stats.submit(name,value);
      }
      
      public function getUserName() : String
      {
         return this.api.services.getUsername();
      }
      
      public function getUserId() : String
      {
         return this.api.services.getUserId();
      }
      
      public function purchaseItems(data:Object) : void
      {
         this.api.mtx.purchaseItems([data],this.onPurchase);
      }
      
      private function onPurchase(data:Object) : void
      {
         this._purchaseResponse.dispatch(data);
      }
      
      public function get purchaseResponse() : Signal
      {
         return this._purchaseResponse;
      }
   }
}
