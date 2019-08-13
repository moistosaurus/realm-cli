package kabam.rotmg.application.model
{
   import flash.net.LocalConnection;
   import flash.system.Security;
   
   public class DomainModel
   {
       
      
      private const LOCALHOST:String = "localhost";
      
      private const PRODUCTION_WHITELIST:Array = ["www.realmofthemadgod.com","realmofthemadgod.appspot.com"];
      
      private const TESTING_WHITELIST:Array = ["testing.realmofthemadgod.com","rotmgtesting.appspot.com"];
      
      private const WHITELIST:Array = PRODUCTION_WHITELIST.concat(TESTING_WHITELIST);
      
      [Inject]
      public var client:PlatformModel;
      
      private var localDomain:String;
      
      public function DomainModel()
      {
         super();
      }
      
      public function applyDomainSecurity() : void
      {
         var domain:String = null;
         for each(domain in this.WHITELIST)
         {
            Security.allowDomain(domain);
         }
      }
      
      public function isLocalDomainValid() : Boolean
      {
         return this.client.isDesktop() || this.isLocalDomainInWhiteList();
      }
      
      public function isLocalDomainProduction() : Boolean
      {
         var local:String = this.getLocalDomain();
         return this.PRODUCTION_WHITELIST.indexOf(local) != -1;
      }
      
      private function isLocalDomainInWhiteList() : Boolean
      {
         var domain:String = null;
         var local:String = this.getLocalDomain();
         var isInWhiteList:Boolean = local == this.LOCALHOST;
         for each(domain in this.WHITELIST)
         {
            isInWhiteList = isInWhiteList || local == domain;
         }
         return isInWhiteList;
      }
      
      private function getLocalDomain() : String
      {
         return this.localDomain = this.localDomain || new LocalConnection().domain;
      }
   }
}
