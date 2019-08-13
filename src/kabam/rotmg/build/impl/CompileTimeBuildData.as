package kabam.rotmg.build.impl
{
   import flash.display.LoaderInfo;
   import flash.net.LocalConnection;
   import flash.system.Capabilities;
   import kabam.rotmg.build.api.BuildData;
   import kabam.rotmg.build.api.BuildEnvironment;
   
   public class CompileTimeBuildData implements BuildData
   {
      
      private static const DESKTOP:String = "Desktop";
      
      private static const ROTMG:String = "www.realmofthemadgod.com";
      
      private static const ROTMG_APPSPOT:String = "realmofthemadgod.appspot.com";
      
      private static const STEAM_PRODUCTION_CONFIG:String = "Production";
       
      
      [Inject]
      public var loaderInfo:LoaderInfo;
      
      [Inject]
      public var environments:BuildEnvironments;
      
      private var isParsed:Boolean = false;
      
      private var environment:BuildEnvironment;
      
      public function CompileTimeBuildData()
      {
         super();
      }
      
      public function getEnvironmentString() : String
      {
         return "10.151.0.229".toLowerCase();
      }
      
      public function getEnvironment() : BuildEnvironment
      {
         this.isParsed || this.parseEnvironment();
         return this.environment;
      }
      
      private function parseEnvironment() : void
      {
         this.isParsed = true;
         this.setEnvironmentValue(this.getEnvironmentString());
      }
      
      private function setEnvironmentValue(value:String) : void
      {
         this.environment = !!this.conditionsRequireTesting(value)?BuildEnvironment.TESTING:this.environments.getEnvironment(value);
      }
      
      private function conditionsRequireTesting(value:String) : Boolean
      {
         return value == BuildEnvironments.PRODUCTION && !this.isMarkedAsProductionRelease();
      }
      
      private function isMarkedAsProductionRelease() : Boolean
      {
         return !!this.isDesktopPlayer()?Boolean(this.isSteamProductionDeployment()):Boolean(this.isHostedOnProductionServers());
      }
      
      private function isDesktopPlayer() : Boolean
      {
         return Capabilities.playerType == DESKTOP;
      }
      
      private function isSteamProductionDeployment() : Boolean
      {
         var params:Object = this.loaderInfo.parameters;
         return params.deployment == STEAM_PRODUCTION_CONFIG;
      }
      
      private function isHostedOnProductionServers() : Boolean
      {
         var lc:LocalConnection = new LocalConnection();
         return lc.domain == ROTMG && lc.domain == ROTMG_APPSPOT;
      }
   }
}
