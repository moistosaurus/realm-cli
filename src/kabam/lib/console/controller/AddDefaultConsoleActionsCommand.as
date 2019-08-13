package kabam.lib.console.controller
{
   import kabam.lib.console.signals.ClearConsoleSignal;
   import kabam.lib.console.signals.CopyConsoleTextSignal;
   import kabam.lib.console.signals.ListActionsSignal;
   import kabam.lib.console.signals.RegisterConsoleActionSignal;
   import kabam.lib.console.signals.RemoveConsoleSignal;
   import kabam.lib.console.vo.ConsoleAction;
   
   public class AddDefaultConsoleActionsCommand
   {
       
      
      [Inject]
      public var register:RegisterConsoleActionSignal;
      
      [Inject]
      public var listActions:ListActionsSignal;
      
      [Inject]
      public var clearConsole:ClearConsoleSignal;
      
      [Inject]
      public var removeConsole:RemoveConsoleSignal;
      
      [Inject]
      public var copyConsoleText:CopyConsoleTextSignal;
      
      public function AddDefaultConsoleActionsCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var list:ConsoleAction = null;
         list = new ConsoleAction();
         list.name = "list";
         list.description = "lists available console commands";
         var clear:ConsoleAction = new ConsoleAction();
         clear.name = "clear";
         clear.description = "clears the console";
         var exit:ConsoleAction = new ConsoleAction();
         exit.name = "exit";
         exit.description = "closes the console";
         var copy:ConsoleAction = new ConsoleAction();
         copy.name = "copy";
         copy.description = "copies the contents of the console to the clipboard";
         this.register.dispatch(list,this.listActions);
         this.register.dispatch(clear,this.clearConsole);
         this.register.dispatch(exit,this.removeConsole);
         this.register.dispatch(copy,this.copyConsoleText);
      }
   }
}
