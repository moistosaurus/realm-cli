package kabam.lib.console.view
{
   import flash.display.DisplayObjectContainer;
   import flash.events.KeyboardEvent;
   import kabam.lib.console.signals.ToggleConsoleSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ConsoleKeyMediator extends Mediator
   {
       
      
      private const TILDE:uint = 192;
      
      [Inject]
      public var view:DisplayObjectContainer;
      
      [Inject]
      public var toggle:ToggleConsoleSignal;
      
      public function ConsoleKeyMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      override public function destroy() : void
      {
         this.view.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == this.TILDE)
         {
            this.toggle.dispatch();
         }
      }
   }
}
