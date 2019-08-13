package kabam.rotmg.account.core
{
   public interface Account
   {
      function updateUser(param1:String, param2:String) : void;
      
      function getUserName() : String;
      
      function getUserId() : String;
      
      function getPassword() : String;
      
      function getCredentials() : Object;
      
      function isRegistered() : Boolean;
      
      function clear() : void;
      
      function reportIntStat(param1:String, param2:int) : void;
   }
}
