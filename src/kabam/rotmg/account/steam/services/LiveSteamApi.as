package kabam.rotmg.account.steam.services
{
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import kabam.rotmg.account.steam.SteamApi;
   import org.osflash.signals.OnceSignal;
   import org.osflash.signals.Signal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class LiveSteamApi extends Sprite implements SteamApi
   {
       
      
      [Inject]
      public var logger:ILogger;
      
      private const _loaded:Signal = new Signal();
      
      private const _sessionReceived:Signal = new Signal(Boolean);
      
      private const _paymentAuthorized:Signal = new Signal(uint,String,Boolean);
      
      private var loader:Loader;
      
      private var api;
      
      private var steamID:String;
      
      private var sessionTicket:String;
      
      public function LiveSteamApi()
      {
         super();
      }
      
      public function load(path:String) : void
      {
         this.logger.info("LiveSteamApi load");
         addChild(this.loader = new Loader());
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAPILoaded);
         this.loader.load(new URLRequest(path));
      }
      
      private function onAPILoaded(event:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onAPILoaded);
         this.api = event.target.content;
         this.api.addEventListener("STEAM_MICRO_TXN_AUTH",this.onSteamMicroTxnAuthEvent);
         this.loaded.dispatch();
      }
      
      private function onSteamMicroTxnAuthEvent(event:*) : void
      {
         this.logger.debug("LiveSteamApi onSteamMicroTxnAuthEvent: {0}",[this.sessionTicket]);
         var appID:uint = uint(event.appID);
         var orderID:String = String(event.orderID);
         var isAuthorized:Boolean = Boolean(event.isAuthorized);
         this._paymentAuthorized.dispatch(appID,orderID,isAuthorized);
      }
      
      public function requestSessionTicket() : void
      {
         this.logger.debug("LiveSteamApi requestSessionTicket");
         this.api.requestSessionTicket(this.onSessionTicketResponse);
      }
      
      private function onSessionTicketResponse(ticket:String) : void
      {
         var isTicket:Boolean = ticket != null;
         isTicket && (this.sessionTicket = ticket);
         this.logger.debug("LiveSteamApi sessionTicket: {0}",[this.sessionTicket]);
         this.sessionReceived.dispatch(isTicket);
      }
      
      public function getSessionAuthentication() : Object
      {
         var obj:Object = {};
         obj.steamid = this.steamID = this.steamID || this.api.getSteamID();
         obj.sessionticket = this.sessionTicket;
         return obj;
      }
      
      public function getSteamId() : String
      {
         return this.api.getSteamID();
      }
      
      public function reportStatistic(name:String, value:int) : void
      {
         this.api.setStatFromInt(name,value);
      }
      
      public function get loaded() : Signal
      {
         return this._loaded;
      }
      
      public function get sessionReceived() : Signal
      {
         return this._sessionReceived;
      }
      
      public function get paymentAuthorized() : OnceSignal
      {
         return this._paymentAuthorized;
      }
      
      public function getPersonaName() : String
      {
         return this.api.getPersonaName();
      }
   }
}
