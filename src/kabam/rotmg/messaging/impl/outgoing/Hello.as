package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.ByteArray;
   import flash.utils.IDataOutput;
   
   public class Hello extends OutgoingMessage
   {
       
      
      public var buildVersion_:String;
      
      public var gameId_:int = 0;
      
      public var guid_:String;
      
      public var password_:String;
      
      public var secret_:String;
      
      public var keyTime_:int = 0;
      
      public var key_:ByteArray;
      
      public var mapJSON_:String;
      
      public var entrytag_:String = "";
      
      public var gameNet:String = "";
      
      public var gameNetUserId:String = "";
      
      public var playPlatform:String = "";
      
      public var platformToken:String = "";
      
      public function Hello(id:uint, callback:Function)
      {
         this.buildVersion_ = new String();
         this.guid_ = new String();
         this.password_ = new String();
         this.secret_ = new String();
         this.key_ = new ByteArray();
         this.mapJSON_ = new String();
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeUTF(this.buildVersion_);
         data.writeInt(this.gameId_);
         data.writeUTF(this.guid_);
         data.writeUTF(this.password_);
         data.writeUTF(this.secret_);
         data.writeInt(this.keyTime_);
         data.writeShort(this.key_.length);
         data.writeBytes(this.key_);
         data.writeInt(this.mapJSON_.length);
         data.writeUTFBytes(this.mapJSON_);
         data.writeUTF(this.entrytag_);
         data.writeUTF(this.gameNet);
         data.writeUTF(this.gameNetUserId);
         data.writeUTF(this.playPlatform);
         data.writeUTF(this.platformToken);
      }
      
      override public function toString() : String
      {
         return formatToString("HELLO","buildVersion_","gameId_","guid_","password_","secret_");
      }
   }
}
