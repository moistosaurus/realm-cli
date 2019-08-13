package kabam.rotmg.promotions.commands
{
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.GetOffersTask;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   import kabam.rotmg.promotions.service.GetDaysRemainingTask;
   import kabam.rotmg.promotions.view.AlreadyPurchasedBeginnersPackageDialog;
   import kabam.rotmg.promotions.view.BeginnersPackageOfferDialog;
   
   public class ShowBeginnersPackageCommand
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:BeginnersPackageModel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var getDaysRemaining:GetDaysRemainingTask;
      
      [Inject]
      public var getOffers:GetOffersTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      public function ShowBeginnersPackageCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var branch:BranchingTask = new BranchingTask(this.getDaysRemaining,this.makeSuccessTask(),this.makeFailureTask());
         this.monitor.add(branch);
         branch.start();
      }
      
      private function makeSuccessTask() : Task
      {
         var sequence:TaskSequence = new TaskSequence();
         this.account.isRegistered() && sequence.add(this.getOffers);
         sequence.add(new DispatchSignalTask(this.openDialog,new BeginnersPackageOfferDialog()));
         return sequence;
      }
      
      private function makeFailureTask() : Task
      {
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(new DispatchSignalTask(this.openDialog,new AlreadyPurchasedBeginnersPackageDialog()));
         return sequence;
      }
   }
}
