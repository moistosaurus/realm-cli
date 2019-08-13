package kabam.rotmg.build.impl
{
   import kabam.rotmg.build.api.BuildEnvironment;
   
   public final class BuildEnvironments
   {
      
      public static const LOCALHOST:String = "localhost";
      
      public static const PRIVATE:String = "private";
      
      public static const DEV:String = "dev";
      
      public static const TESTING:String = "testing";
      
      public static const PRODTEST:String = "prodtest";
      
      public static const PRODUCTION:String = "production";
      
      private static const IP_MATCHER:RegExp = /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/;
       
      
      public function BuildEnvironments()
      {
         super();
      }
      
      public function getEnvironment(name:String) : BuildEnvironment
      {
         return !!this.isFixedIP(name)?BuildEnvironment.FIXED_IP:this.getEnvironmentFromName(name);
      }
      
      private function isFixedIP(name:String) : Boolean
      {
         return name.match(IP_MATCHER) != null;
      }
      
      private function getEnvironmentFromName(name:String) : BuildEnvironment
      {
         switch(name)
         {
            case LOCALHOST:
               return BuildEnvironment.LOCALHOST;
            case PRIVATE:
               return BuildEnvironment.PRIVATE;
            case DEV:
               return BuildEnvironment.DEV;
            case TESTING:
               return BuildEnvironment.TESTING;
            case PRODTEST:
               return BuildEnvironment.PRODTEST;
            case PRODUCTION:
               return BuildEnvironment.PRODUCTION;
            default:
               return null;
         }
      }
   }
}
