package kabam.rotmg.account.kabam.view
{
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class AccountLoadErrorMediator extends Mediator
   {
      
      private static const GET_KABAM_PAGE_JS:String = "rotmg.KabamDotComLib.getKabamGamePage";
      
      private static const KABAM_DOT_COM:String = "https://www.kabam.com";
      
      private static const TOP:String = "_top";
       
      
      [Inject]
      public var view:AccountLoadErrorDialog;
      
      public function AccountLoadErrorMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.close.addOnce(this.onClose);
      }
      
      private function onClose() : void
      {
         navigateToURL(new URLRequest(this.getUrl()),TOP);
      }
      
      private function getUrl() : String
      {
         var value:String = null;
         var url:String = KABAM_DOT_COM;
         try
         {
            value = ExternalInterface.call(GET_KABAM_PAGE_JS);
            if(value && value.length)
            {
               url = value;
            }
         }
         catch(error:Error)
         {
         }
         return url;
      }
   }
}
