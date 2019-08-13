package kabam.rotmg.application
{
   import flash.display.DisplayObjectContainer;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.application.impl.DevSetup;
   import kabam.rotmg.application.impl.FakeProductionSetup;
   import kabam.rotmg.application.impl.FixedIPSetup;
   import kabam.rotmg.application.impl.LocalhostSetup;
   import kabam.rotmg.application.impl.PrivateSetup;
   import kabam.rotmg.application.impl.ProductionSetup;
   import kabam.rotmg.application.impl.TestingSetup;
   import kabam.rotmg.application.model.DomainModel;
   import kabam.rotmg.application.model.PlatformModel;
   import kabam.rotmg.build.api.BuildData;
   import kabam.rotmg.build.api.BuildEnvironment;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.IConfig;
   
   public class ApplicationConfig implements IConfig
   {
       
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var root:DisplayObjectContainer;
      
      [Inject]
      public var data:BuildData;
      
      public function ApplicationConfig()
      {
         super();
      }
      
      public function configure() : void
      {
         this.injector.map(ApplicationSetup).toValue(this.makeTestingSetup());
         this.injector.map(PlatformModel).asSingleton();
         this.injector.map(DomainModel).asSingleton();
      }
      
      private function makeTestingSetup() : ApplicationSetup
      {
         var env:BuildEnvironment = this.data.getEnvironment();
         switch(env)
         {
            case BuildEnvironment.LOCALHOST:
               return new LocalhostSetup();
            case BuildEnvironment.FIXED_IP:
               return this.makeFixedIPSetup();
            case BuildEnvironment.PRIVATE:
               return new PrivateSetup();
            case BuildEnvironment.DEV:
               return new DevSetup();
            case BuildEnvironment.TESTING:
               return new TestingSetup();
            case BuildEnvironment.PRODTEST:
               return new FakeProductionSetup();
            case BuildEnvironment.PRODUCTION:
            default:
               return new ProductionSetup();
         }
      }
      
      private function makeFixedIPSetup() : FixedIPSetup
      {
         return new FixedIPSetup().setAddress(this.data.getEnvironmentString());
      }
   }
}
