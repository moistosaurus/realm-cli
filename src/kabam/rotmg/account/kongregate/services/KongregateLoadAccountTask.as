package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.LoadAccountTask;
   
   public class KongregateLoadAccountTask extends BaseTask implements LoadAccountTask
   {
       
      
      [Inject]
      public var loadApi:KongregateLoadApiTask;
      
      [Inject]
      public var getCredentials:KongregateGetCredentialsTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      public function KongregateLoadAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(this.loadApi);
         sequence.add(this.getCredentials);
         sequence.lastly.add(this.onTasksComplete);
         this.monitor.add(sequence);
         sequence.start();
      }
      
      private function onTasksComplete(task:Task, isOK:Boolean, error:String) : void
      {
         completeTask(true);
      }
   }
}
