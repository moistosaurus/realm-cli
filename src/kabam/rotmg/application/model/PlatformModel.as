package kabam.rotmg.application.model
{
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import flash.system.Capabilities;
   
   public class PlatformModel
   {
      
      private static var platform:PlatformType;
       
      
      [Inject]
      public var root:DisplayObjectContainer;
      
      private const DESKTOP:String = "Desktop";
      
      public function PlatformModel()
      {
         super();
      }
      
      public function isWeb() : Boolean
      {
         return Capabilities.playerType != this.DESKTOP;
      }
      
      public function isDesktop() : Boolean
      {
         return Capabilities.playerType == this.DESKTOP;
      }
      
      public function getPlatform() : PlatformType
      {
         return platform = platform || this.determinePlatform();
      }
      
      private function determinePlatform() : PlatformType
      {
         var params:Object = LoaderInfo(this.root.stage.root.loaderInfo).parameters;
         if(this.isKongregate(params))
         {
            return PlatformType.KONGREGATE;
         }
         if(this.isSteam(params))
         {
            return PlatformType.STEAM;
         }
         if(this.isKabam(params))
         {
            return PlatformType.KABAM;
         }
         return PlatformType.WEB;
      }
      
      private function isKongregate(params:Object) : Boolean
      {
         return params.kongregate_api_path != null;
      }
      
      private function isSteam(params:Object) : Boolean
      {
         return params.steam_api_path != null;
      }
      
      private function isKabam(params:Object) : Boolean
      {
         return params.kabam_signed_request != null;
      }
   }
}
