package kabam.lib.console.model
{
   import kabam.lib.console.vo.ConsoleAction;
   import org.osflash.signals.Signal;
   
   public final class Console
   {
       
      
      private var hash:ActionHash;
      
      private var history:ActionHistory;
      
      public function Console()
      {
         super();
         this.hash = new ActionHash();
         this.history = new ActionHistory();
      }
      
      public function register(action:ConsoleAction, signal:Signal) : void
      {
         this.hash.register(action.name,action.description,signal);
      }
      
      public function hasAction(action:String) : Boolean
      {
         return this.hash.has(action);
      }
      
      public function execute(data:String) : void
      {
         this.history.add(data);
         this.hash.execute(data);
      }
      
      public function getNames() : Vector.<String>
      {
         return this.hash.getNames();
      }
      
      public function getPreviousAction() : String
      {
         return this.history.getPrevious();
      }
      
      public function getNextAction() : String
      {
         return this.history.getNext();
      }
   }
}
