package kabam.rotmg.account.kongregate.services
{
   import com.company.assembleegameclient.util.GUID;
   import flash.net.SharedObject;
   
   public class KongregateSharedObject
   {
       
      
      private var guid:String;
      
      public function KongregateSharedObject()
      {
         super();
      }
      
      public function getGuestGUID() : String
      {
         return this.guid = this.guid || this.makeGuestGUID();
      }
      
      private function makeGuestGUID() : String
      {
         var value:String = null;
         var rotmg:SharedObject = null;
         try
         {
            rotmg = SharedObject.getLocal("KongregateRotMG","/");
            if(rotmg.data.hasOwnProperty("GuestGUID"))
            {
               value = rotmg.data["GuestGUID"];
            }
         }
         catch(error:Error)
         {
         }
         if(value == null)
         {
            value = GUID.create();
            try
            {
               rotmg = SharedObject.getLocal("KongregateRotMG","/");
               rotmg.data["GuestGUID"] = value;
               rotmg.flush();
            }
            catch(error:Error)
            {
            }
         }
         return value;
      }
   }
}
