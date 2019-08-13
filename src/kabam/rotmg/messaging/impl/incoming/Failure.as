package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class Failure extends IncomingMessage
   {
      
      public static const INCORRECT_VERSION:int = 4;
      
      public static const BAD_KEY:int = 5;
      
      public static const INVALID_TELEPORT_TARGET:int = 6;
       
      
      public var errorId_:int;
      
      public var errorDescription_:String;
      
      public function Failure(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.errorId_ = data.readInt();
         this.errorDescription_ = data.readUTF();
      }
      
      override public function toString() : String
      {
         return formatToString("FAILURE","errorId_","errorDescription_");
      }
   }
}
