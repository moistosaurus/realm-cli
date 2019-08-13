package kabam.rotmg.account.kongregate
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   
   public class KongregateAccount implements Account
   {
      
      public static const NETWORK_NAME:String = "kongregate";
       
      
      [Inject]
      public var api:KongregateApi;
      
      private var userId:String = "";
      
      private var password:String;
      
      private var isVerifiedEmail:Boolean;
      
      private var platformToken:String;
      
      public function KongregateAccount()
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
         return this.api.getUserName();
      }
      
      public function getUserId() : String
      {
         return this.userId;
      }
      
      public function getPassword() : String
      {
         return "";
      }
      
      public function getSecret() : String
      {
         return this.password || "";
      }
      
      public function getCredentials() : Object
      {
         return {
            "guid":this.getUserId(),
            "secret":this.getSecret()
         };
      }
      
      public function isRegistered() : Boolean
      {
         return this.getSecret() != "";
      }
      
      public function gameNetworkUserId() : String
      {
         return this.api.getUserId();
      }
      
      public function gameNetwork() : String
      {
         return NETWORK_NAME;
      }
      
      public function playPlatform() : String
      {
         return "kongregate";
      }
      
      public function reportIntStat(name:String, value:int) : void
      {
         this.api.reportStatistic(name,value);
      }
      
      public function getRequestPrefix() : String
      {
         return "/kongregate";
      }
      
      public function getEntryTag() : String
      {
         return "kongregate";
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
         throw new Error("No current support for new Kabam offer wall on Kongregate.");
      }
      
      public function getMoneyUserId() : String
      {
         throw new Error("No current support for new Kabam offer wall on Kongregate.");
      }
   }
}
