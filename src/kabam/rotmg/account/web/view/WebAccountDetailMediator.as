package kabam.rotmg.account.web.view
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.signals.SendConfirmEmailSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebAccountDetailMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebAccountDetailDialog;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var verify:SendConfirmEmailSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      public function WebAccountDetailMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.setUserInfo(this.account.getUserName(),this.account.isVerified());
         this.view.change.add(this.onChange);
         this.view.logout.add(this.onLogout);
         this.view.cancel.add(this.onDone);
         this.view.verify.add(this.onVerify);
      }
      
      override public function destroy() : void
      {
         this.view.change.remove(this.onChange);
         this.view.logout.remove(this.onLogout);
         this.view.cancel.remove(this.onDone);
         this.view.verify.remove(this.onVerify);
      }
      
      private function onChange() : void
      {
         this.openDialog.dispatch(new WebChangePasswordDialog());
      }
      
      private function onLogout() : void
      {
         this.account.clear();
         this.openDialog.dispatch(new WebLoginDialog());
      }
      
      private function onDone() : void
      {
         this.closeDialog.dispatch();
      }
      
      private function onVerify() : void
      {
         this.verify.dispatch();
      }
   }
}
