package kabam.rotmg.packages.services
{
   import kabam.rotmg.packages.model.PackageModel;
   import org.osflash.signals.Signal;
   
   public class Packages
   {
       
      
      private var models:Object;
      
      public var numSpammed:int = 0;
      
      public var dataChanged:Signal;
      
      private var initialized:Boolean;
      
      public function Packages()
      {
         this.models = {};
         this.dataChanged = new Signal();
         super();
      }
      
      public function getInitialized() : Boolean
      {
         return this.initialized;
      }
      
      public function getPackageById(id:int) : PackageModel
      {
         return this.models[id];
      }
      
      public function hasPackage(id:int) : Boolean
      {
         return id in this.models;
      }
      
      public function setModels(value:Array) : void
      {
         var packageModel:PackageModel = null;
         for each(packageModel in value)
         {
            packageModel.dataChanged.add(this.onDataChanged);
            this.models[packageModel.packageID] = packageModel;
         }
         this.initialized = true;
         this.dataChanged.dispatch();
      }
      
      private function onDataChanged() : void
      {
         this.dataChanged.dispatch();
      }
      
      public function canPurchasePackage(id:int) : Boolean
      {
         var model:PackageModel = this.models[id];
         return model && model.canPurchase();
      }
      
      public function getPriorityPackage() : PackageModel
      {
         var packageModel:PackageModel = null;
         var top:PackageModel = null;
         for each(packageModel in this.models)
         {
            if(top == null || packageModel.priority < top.priority)
            {
               top = packageModel;
            }
         }
         return packageModel;
      }
      
      public function shouldSpam() : Boolean
      {
         return this.numSpammed == 0;
      }
   }
}
