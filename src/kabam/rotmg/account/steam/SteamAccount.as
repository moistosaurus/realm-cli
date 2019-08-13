package kabam.rotmg.account.steam
{
   import com.company.util.EmailValidator;
   import kabam.rotmg.account.core.Account;
   
   public class SteamAccount implements Account
   {
      
      public static const NETWORK_NAME:String = "steam";
       
      
      [Inject]
      public var api:SteamApi;
      
      private var userId:String = "";
      
      private var password:String = null;
      
      private var isVerifiedEmail:Boolean;
      
      private var platformToken:String;
      
      public function SteamAccount()
      {
         super();
      }
      
      public function updateUser(userId:String, password:String) : void
      {
         this.userId = userId;
         this.password = password;
      }
      
      public function getUserName() : String
      {
         return this.api.getPersonaName();
      }
      
      public function getUserId() : String
      {
         return this.userId = this.userId || "";
      }
      
      public function getPassword() : String
      {
         return "";
      }
      
      public function getSecret() : String
      {
         return this.password = this.password || "";
      }
      
      public function getCredentials() : Object
      {
         var obj:Object = {};
         obj.guid = this.getUserId();
         obj.secret = this.getSecret();
         obj.steamid = this.api.getSteamId();
         return obj;
      }
      
      public function isRegistered() : Boolean
      {
         return this.getSecret() != "";
      }
      
      public function isLinked() : Boolean
      {
         return EmailValidator.isValidEmail(this.userId);
      }
      
      public function gameNetworkUserId() : String
      {
         return this.api.getSteamId();
      }
      
      public function gameNetwork() : String
      {
         return NETWORK_NAME;
      }
      
      public function playPlatform() : String
      {
         return "steam";
      }
      
      public function reportIntStat(name:String, value:int) : void
      {
         this.api.reportStatistic(name,value);
      }
      
      public function getRequestPrefix() : String
      {
         return "/steamworks";
      }
      
      public function getEntryTag() : String
      {
         return "steamworks";
      }
      
      public function clear() : void
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
         throw new Error("No current support for new Kabam offer wall on Steam.");
      }
      
      public function getMoneyUserId() : String
      {
         throw new Error("No current support for new Kabam offer wall on Steam.");
      }
   }
}
