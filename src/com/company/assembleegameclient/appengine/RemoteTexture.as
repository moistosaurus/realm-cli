package com.company.assembleegameclient.appengine
{
   import flash.display.BitmapData;
   import flash.net.URLLoaderDataFormat;
   import flash.utils.ByteArray;
   import ion.utils.png.PNGDecoder;
   import kabam.rotmg.appengine.api.RetryLoader;
   import kabam.rotmg.appengine.impl.AppEngineRetryLoader;
   import kabam.rotmg.core.StaticInjectorContext;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.ILogger;
   
   public class RemoteTexture
   {
      
      private static const URL_PATTERN:String = "http://{DOMAIN}/picture/get";
      
      private static const ERROR_PATTERN:String = "Remote Texture Error: {ERROR} (id:{ID}, instance:{INSTANCE})";
      
      private static const START_TIME:int = int(new Date().getTime());
       
      
      public var id_:String;
      
      public var instance_:String;
      
      public var callback_:Function;
      
      private var logger:ILogger;
      
      public function RemoteTexture(id:String, instance:String, callback:Function)
      {
         super();
         this.id_ = id;
         this.instance_ = instance;
         this.callback_ = callback;
         var injector:Injector = StaticInjectorContext.getInjector();
         this.logger = injector.getInstance(ILogger);
      }
      
      public function run() : void
      {
         var domain:String = this.instance_ == "testing"?"rotmgtesting.appspot.com":"realmofthemadgod.appspot.com";
         var url:String = URL_PATTERN.replace("{DOMAIN}",domain);
         var params:Object = {};
         params.id = this.id_;
         params.time = START_TIME;
         var loader:RetryLoader = new AppEngineRetryLoader();
         loader.setDataFormat(URLLoaderDataFormat.BINARY);
         loader.complete.addOnce(this.onComplete);
         loader.sendRequest(url,params);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.makeTexture(data);
         }
         else
         {
            this.reportError(data);
         }
      }
      
      public function makeTexture(data:ByteArray) : void
      {
         var texture:BitmapData = PNGDecoder.decodeImage(data);
         this.callback_(texture);
      }
      
      public function reportError(error:String) : void
      {
         error = ERROR_PATTERN.replace("{ERROR}",error).replace("{ID}",this.id_).replace("{INSTANCE}",this.instance_);
         this.logger.warn("RemoteTexture.reportError: {0}",[error]);
         var nullTexture:BitmapData = new BitmapData(1,1);
         this.callback_(nullTexture);
      }
   }
}
