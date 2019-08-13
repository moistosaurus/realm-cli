package kabam.rotmg.application.impl
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.application.api.ApplicationSetup;
   
   public class FakeProductionSetup implements ApplicationSetup
   {
       
      
      private const SERVER:String = "realmofthemadgod.appspot.com";
      
      private const UNENCRYPTED:String = "http://" + SERVER;
      
      private const ENCRYPTED:String = "https://" + SERVER;
      
      private const ANALYTICS:String = "UA-99999999-1";
      
      private const BUILD_LABEL:String = "<font color=\'#FF8800\'>PRODUCTION TESTING</font> #{VERSION}";
      
      public function FakeProductionSetup()
      {
         super();
      }
      
      public function getAppEngineUrl(forceUnencrypted:Boolean = false) : String
      {
         return !!forceUnencrypted?this.UNENCRYPTED:this.ENCRYPTED;
      }
      
      public function getAnalyticsCode() : String
      {
         return this.ANALYTICS;
      }
      
      public function getBuildLabel() : String
      {
         var version:String = Parameters.BUILD_VERSION + "." + Parameters.MINOR_VERSION;
         return this.BUILD_LABEL.replace("{VERSION}",version);
      }
      
      public function useLocalTextures() : Boolean
      {
         return false;
      }
      
      public function isToolingEnabled() : Boolean
      {
         return true;
      }
      
      public function isGameLoopMonitored() : Boolean
      {
         return true;
      }
      
      public function useProductionDialogs() : Boolean
      {
         return true;
      }
      
      public function areErrorsReported() : Boolean
      {
         return false;
      }
      
      public function areDeveloperHotkeysEnabled() : Boolean
      {
         return true;
      }
   }
}
