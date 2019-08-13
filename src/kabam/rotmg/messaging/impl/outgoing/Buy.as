package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class Buy extends OutgoingMessage
   {
       
      
      public var objectId_:int;
      
      public var multiplier_:Number = -1;
      
      public function Buy(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.objectId_);
         data.writeFloat(this.multiplier_);
      }
      
      override public function toString() : String
      {
         return formatToString("BUY","objectId_","multiplier_");
      }
   }
}
