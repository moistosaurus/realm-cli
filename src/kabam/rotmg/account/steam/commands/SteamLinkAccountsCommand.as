package kabam.rotmg.account.steam.commands
{
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.LinkAccountsTask;
   import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
   import kabam.rotmg.account.steam.view.SteamAccountDetailDialog;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.core.signals.InvalidateDataSignal;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class SteamLinkAccountsCommand
   {
       
      
      [Inject]
      public var task:LinkAccountsTask;
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var update:UpdateAccountInfoSignal;
      
      [Inject]
      public var taskError:TaskErrorSignal;
      
      [Inject]
      public var invalidate:InvalidateDataSignal;
      
      public function SteamLinkAccountsCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var branch:BranchingTask = new BranchingTask(this.task,this.onSuccess(),this.onFailure());
         this.monitor.add(branch);
         branch.start();
      }
      
      private function onSuccess() : TaskSequence
      {
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(new DispatchSignalTask(this.invalidate));
         sequence.add(new DispatchSignalTask(this.update));
         sequence.add(new DispatchSignalTask(this.openDialog,new SteamAccountDetailDialog()));
         return sequence;
      }

      private function onFailure() : Task
      {
         return new DispatchSignalTask(this.taskError,this.task);
      }
   }
}
