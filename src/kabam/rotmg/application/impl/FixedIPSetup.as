package kabam.rotmg.application.impl
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.application.api.ApplicationSetup;
   
   public class FixedIPSetup implements ApplicationSetup
   {
       
      
      private const SERVER:String = "127.0.0.1";
      
      private const UNENCRYPTED:String = "http://" + SERVER;
      
      private const ENCRYPTED:String = "http://" + SERVER;
      
      private const ANALYTICS:String = "UA-99999999-1";
      
      private const BUILD_LABEL:String = "<font color=\'#9900FF\'>{IP}</font> #{VERSION}";
      
      private var ipAddress:String;
      
      public function FixedIPSetup()
      {
         super();
      }
      
      public function setAddress(ipAddress:String) : FixedIPSetup
      {
         this.ipAddress = ipAddress;
         return this;
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
         return this.BUILD_LABEL.replace("{IP}",this.ipAddress).replace("{VERSION}",version);
      }
      
      public function useLocalTextures() : Boolean
      {
         return true;
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
         return false;
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
