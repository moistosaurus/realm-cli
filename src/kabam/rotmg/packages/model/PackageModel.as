package kabam.rotmg.packages.model
{
   import org.osflash.signals.Signal;
   
   public class PackageModel
   {
      
      public static const INFINITE:int = -1;
       
      
      private var _initialized:Boolean = false;
      
      public var dataChanged:Signal;
      
      public var packageIDChanged:Signal;
      
      public var endDateChanged:Signal;
      
      public var durationChanged:Signal;
      
      public var nameChanged:Signal;
      
      public var quantityChanged:Signal;
      
      public var maxChanged:Signal;
      
      public var priceChanged:Signal;
      
      public var imageURLChanged:Signal;
      
      private var _packageID:int;
      
      private var _endDate:Date;
      
      private var _name:String;
      
      private var _quantity:int;
      
      private var _max:int;
      
      private var _price:int;
      
      private var _imageURL:String;
      
      private var _priority:int;
      
      private var _numPurchased:int;
      
      public function PackageModel()
      {
         this.dataChanged = new Signal();
         this.packageIDChanged = new Signal(int);
         this.endDateChanged = new Signal(Date);
         this.durationChanged = new Signal(int);
         this.nameChanged = new Signal(String);
         this.quantityChanged = new Signal(int);
         this.maxChanged = new Signal(int);
         this.priceChanged = new Signal(int);
         this.imageURLChanged = new Signal(String);
         super();
      }
      
      public function setData(packageID:int, endDate:Date, name:String, quantity:int, max:int, priority:int, price:int, imageURL:String, numPurchased:int) : void
      {
         this._packageID = packageID;
         this._endDate = endDate;
         this._name = name;
         this._quantity = quantity;
         this._max = max;
         this._priority = priority;
         this._price = price;
         this._imageURL = imageURL;
         this._numPurchased = numPurchased;
         this._initialized = true;
         this.dataChanged.dispatch();
      }
      
      public function getDuration() : int
      {
         var now:Date = new Date();
         return this._endDate.time - now.time;
      }
      
      public function get quantity() : int
      {
         return this._quantity;
      }
      
      public function set quantity(value:int) : void
      {
         this._quantity = value;
         this.quantityChanged.dispatch(value);
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(value:int) : void
      {
         this._priority = value;
      }
      
      public function get packageID() : int
      {
         return this._packageID;
      }
      
      public function set packageID(value:int) : void
      {
         this._packageID = value;
         this.packageIDChanged.dispatch(value);
      }
      
      public function get endDate() : Date
      {
         return this._endDate;
      }
      
      public function set endDate(value:Date) : void
      {
         this._endDate = value;
         this.endDateChanged.dispatch(value);
         this.durationChanged.dispatch(this.getDuration());
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
         this.nameChanged.dispatch(value);
      }
      
      public function get max() : int
      {
         return this._max;
      }
      
      public function set max(value:int) : void
      {
         this._max = value;
         this.maxChanged.dispatch(value);
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      public function set price(value:int) : void
      {
         this._price = value;
         this.priceChanged.dispatch(value);
      }
      
      public function get imageURL() : String
      {
         return this._imageURL;
      }
      
      public function set imageURL(value:String) : void
      {
         this._imageURL = value;
         this.imageURLChanged.dispatch(value);
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function get numPurchased() : int
      {
         return this._numPurchased;
      }
      
      public function set numPurchased(value:int) : void
      {
         this._numPurchased = value;
      }
      
      public function hasPurchased() : Boolean
      {
         return this._numPurchased > 0;
      }
      
      public function canPurchase() : Boolean
      {
         if(this.max == INFINITE)
         {
            return true;
         }
         return this._numPurchased < this._max;
      }
   }
}
