package kabam.rotmg.packages.control
{
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.packages.view.PackageInfoDialog;
   
   public class BuyPackageSuccessfulCommand
   {
      
      private static const DIALOG_TITLE:String = "Package Purchased";
      
      private static const MESSAGE_TITLE:String = "Your purchase was successful";
      
      private static const MESSAGE_BODY:String = "Check your vault for any items purchased";
       
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function BuyPackageSuccessfulCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.openDialog.dispatch(this.makeDialog());
      }
      
      private function makeDialog() : PackageInfoDialog
      {
         return new PackageInfoDialog().setTitle(DIALOG_TITLE).setBody(MESSAGE_TITLE,MESSAGE_BODY);
      }
   }
}
