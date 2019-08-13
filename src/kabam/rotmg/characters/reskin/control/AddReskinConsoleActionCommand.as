package kabam.rotmg.characters.reskin.control
{
   import kabam.lib.console.signals.RegisterConsoleActionSignal;
   import kabam.lib.console.vo.ConsoleAction;
   
   public class AddReskinConsoleActionCommand
   {
       
      
      [Inject]
      public var register:RegisterConsoleActionSignal;
      
      [Inject]
      public var openReskinDialogSignal:OpenReskinDialogSignal;
      
      public function AddReskinConsoleActionCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var reskin:ConsoleAction = null;
         reskin = new ConsoleAction();
         reskin.name = "reskin";
         reskin.description = "opens the reskin UI";
         this.register.dispatch(reskin,this.openReskinDialogSignal);
      }
   }
}
