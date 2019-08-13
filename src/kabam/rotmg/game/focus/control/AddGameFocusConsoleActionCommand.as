package kabam.rotmg.game.focus.control
{
   import kabam.lib.console.signals.RegisterConsoleActionSignal;
   import kabam.lib.console.vo.ConsoleAction;
   
   public class AddGameFocusConsoleActionCommand
   {
       
      
      [Inject]
      public var register:RegisterConsoleActionSignal;
      
      [Inject]
      public var setFocus:SetGameFocusSignal;
      
      public function AddGameFocusConsoleActionCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var action:ConsoleAction = null;
         action = new ConsoleAction();
         action.name = "follow";
         action.description = "follow a game object (by name)";
         this.register.dispatch(action,this.setFocus);
      }
   }
}
