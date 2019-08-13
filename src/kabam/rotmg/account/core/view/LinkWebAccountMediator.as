package kabam.rotmg.account.core.view
{
   import kabam.lib.tasks.Task;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.signals.LinkWebAccountSignal;
   import kabam.rotmg.account.kongregate.KongregateAccount;
   import kabam.rotmg.account.kongregate.view.KongregateAccountDetailDialog;
   import kabam.rotmg.account.steam.SteamAccount;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class LinkWebAccountMediator extends Mediator
   {
       
      
      [Inject]
      public var view:LinkWebAccountDialog;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var linkAccounts:LinkWebAccountSignal;
      
      [Inject]
      public var linkFailed:TaskErrorSignal;
      
      [Inject]
      public var account:Account;
      
      public function LinkWebAccountMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.cancel.add(this.onCancel);
         this.view.link.add(this.onLink);
         this.linkFailed.add(this.onLinkFailed);
      }

      override public function destroy() : void
      {
         this.view.cancel.add(this.onCancel);
         this.view.link.add(this.onLink);
         this.linkFailed.remove(this.onLinkFailed);
      }
      
      private function onCancel() : void
      {
         this.openDialog.dispatch(new KongregateAccountDetailDialog());
      }
      
      private function onLink(data:AccountData) : void
      {
         this.view.disable();
         this.linkAccounts.dispatch(data);
      }
      
      private function onLinkFailed(task:Task) : void
      {
         this.view.setError(task.error);
         this.view.enable();
      }
   }
}
