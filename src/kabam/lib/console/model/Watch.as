package kabam.lib.console.model
{
   public class Watch
   {
       
      
      public var name:String;
      
      public var data:String;
      
      public function Watch(name:String, data:String = "")
      {
         super();
         this.name = name;
         this.data = data;
      }
      
      public function toString() : String
      {
         return this.data;
      }
   }
}
