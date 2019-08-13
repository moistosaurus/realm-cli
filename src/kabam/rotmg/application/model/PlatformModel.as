package kabam.rotmg.application.model
{
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import flash.system.Capabilities;
   
   public class PlatformModel
   {
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
   }
}
