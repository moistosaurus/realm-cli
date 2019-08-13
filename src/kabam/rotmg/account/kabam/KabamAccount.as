package kabam.rotmg.account.kabam
{
   import flash.external.ExternalInterface;
   import kabam.lib.json.JsonParser;
   import kabam.rotmg.account.core.Account;
   
   public class KabamAccount implements Account
   {
      
      public static const NETWORK_NAME:String = "kabam.com";
      
      private static const PLAY_PLATFORM_NAME:String = "kabam.com";
       
      
      private var entryTag:String;
      
      private var userId:String = "";
      
      private var password:String = null;
      
      private var isVerifiedEmail:Boolean;
      
      private var platformToken:String;
      
      public var signedRequest:String;
      
      public var userSession:Object;
      
      [Inject]
      public var json:JsonParser;
      
      public function KabamAccount()
      {
         var value:String = null;
         super();
         try
         {
            value = ExternalInterface.call("rotmg.UrlLib.getParam","entrypt");
            if(value != null)
            {
               this.entryTag = value;
            }
         }
         catch(error:Error)
         {
         }
      }
      
      public function updateUser(userId:String, password:String) : void
      {
         this.userId = userId;
         this.password = password;
      }
      
      public function getRequestPrefix() : String
      {
         return "/credits";
      }
      
      public function getCredentials() : Object
      {
         return {
            "guid":this.getUserId(),
            "secret":this.getSecret(),
            "signedRequest":this.signedRequest
         };
      }
      
      public function getEntryTag() : String
      {
         return this.entryTag || "";
      }
      
      public function gameNetworkUserId() : String
      {
         if(this.userSession == null || this.userSession["kabam_naid"] == null)
         {
            return "";
         }
         return this.userSession["kabam_naid"];
      }
      
      public function gameNetwork() : String
      {
         return NETWORK_NAME;
      }
      
      public function getUserName() : String
      {
         if(this.userSession == null || this.userSession["user"] == null || this.userSession["user"]["email"] == null)
         {
            return "";
         }
         var email:String = this.userSession["user"]["email"];
         var emailParts:Array = email.split("@",2);
         if(emailParts.length != 2)
         {
            return "";
         }
         return emailParts[0];
      }
      
      public function getUserId() : String
      {
         return this.userId;
      }
      
      public function isLinked() : Boolean
      {
         return false;
      }
      
      public function isRegistered() : Boolean
      {
         return true;
      }
      
      public function playPlatform() : String
      {
         return PLAY_PLATFORM_NAME;
      }
      
      public function getSecret() : String
      {
         return this.password || "";
      }
      
      public function getPassword() : String
      {
         return "";
      }
      
      public function clear() : void
      {
      }
      
      public function reportIntStat(name:String, value:int) : void
      {
      }
      
      public function verify(value:Boolean) : void
      {
         this.isVerifiedEmail = value;
      }
      
      public function isVerified() : Boolean
      {
         return this.isVerifiedEmail;
      }
      
      public function getPlatformToken() : String
      {
         return this.platformToken || "";
      }
      
      public function setPlatformToken(token:String) : void
      {
         this.platformToken = token;
      }
      
      public function getMoneyAccessToken() : String
      {
         return this.userSession["oauth_token"];
      }
      
      public function getMoneyUserId() : String
      {
         return this.gameNetworkUserId();
      }
   }
}
