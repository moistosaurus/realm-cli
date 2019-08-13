package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class MapInfo extends IncomingMessage
   {
       
      
      public var width_:int;
      
      public var height_:int;
      
      public var name_:String;
      
      public var displayName_:String;
      
      public var difficulty_:int;
      
      public var fp_:uint;
      
      public var background_:int;
      
      public var allowPlayerTeleport_:Boolean;
      
      public var showDisplays_:Boolean;
      
      public var clientXML_:Vector.<String>;
      
      public var extraXML_:Vector.<String>;
      
      public function MapInfo(id:uint, callback:Function)
      {
         this.clientXML_ = new Vector.<String>();
         this.extraXML_ = new Vector.<String>();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         var len:int = 0;
         var i:int = 0;
         var xmlLen:int = 0;
         this.width_ = data.readInt();
         this.height_ = data.readInt();
         this.name_ = data.readUTF();
         this.displayName_ = data.readUTF();
         this.fp_ = data.readUnsignedInt();
         this.background_ = data.readInt();
         this.difficulty_ = data.readInt();
         this.allowPlayerTeleport_ = data.readBoolean();
         this.showDisplays_ = data.readBoolean();
         len = data.readShort();
         this.clientXML_.length = 0;
         for(i = 0; i < len; i++)
         {
            xmlLen = data.readInt();
            this.clientXML_.push(data.readUTFBytes(xmlLen));
         }
         len = data.readShort();
         this.extraXML_.length = 0;
         for(i = 0; i < len; i++)
         {
            xmlLen = data.readInt();
            this.extraXML_.push(data.readUTFBytes(xmlLen));
         }
      }
      
      override public function toString() : String
      {
         return formatToString("MAPINFO","width_","height_","name_","fp_","background_","allowPlayerTeleport_","showDisplays_","clientXML_","extraXML_");
      }
   }
}
