package kabam.rotmg.account.kongregate.commands
{
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.LinkAccountsTask;
   import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
   import kabam.rotmg.account.kongregate.view.KongregateAccountDetailDialog;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.core.signals.InvalidateDataSignal;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class KongregateLinkAccountsCommand
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
      
      public function KongregateLinkAccountsCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var branch:BranchingTask = new BranchingTask(this.task,this.makeSuccessTask(),this.makeFailureTask());
         this.monitor.add(branch);
         branch.start();
      }
      
      private function makeSuccessTask() : Task
      {
         var success:TaskSequence = new TaskSequence();
         success.add(new DispatchSignalTask(this.invalidate));
         success.add(new DispatchSignalTask(this.openDialog,new KongregateAccountDetailDialog()));
         success.add(new DispatchSignalTask(this.update));
         return success;
      }
      
      private function makeFailureTask() : Task
      {
         return new DispatchSignalTask(this.taskError,this.task);
      }
   }
}
