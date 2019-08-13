package kabam.lib.console.view
{
   import kabam.lib.console.model.Console;
   import kabam.lib.console.signals.ConsoleLogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public final class ConsoleInputMediator extends Mediator
   {
      
      private static const ERROR_PATTERN:String = "[0xFF3333:error - \"${value}\" not found]";
      
      private static const ACTION_PATTERN:String = "[0xFFEE00:${value}]";
       
      
      [Inject]
      public var view:ConsoleInputView;
      
      [Inject]
      public var console:Console;
      
      [Inject]
      public var log:ConsoleLogSignal;
      
      public function ConsoleInputMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         addViewListener(ConsoleEvent.INPUT,this.onInput,ConsoleEvent);
         addViewListener(ConsoleEvent.GET_PREVIOUS,this.onGetPrevious,ConsoleEvent);
         addViewListener(ConsoleEvent.GET_NEXT,this.onGetNext,ConsoleEvent);
      }
      
      override public function destroy() : void
      {
         removeViewListener(ConsoleEvent.INPUT,this.onInput,ConsoleEvent);
         removeViewListener(ConsoleEvent.GET_PREVIOUS,this.onGetPrevious,ConsoleEvent);
         removeViewListener(ConsoleEvent.GET_NEXT,this.onGetNext,ConsoleEvent);
      }
      
      private function onInput(event:ConsoleEvent) : void
      {
         var data:String = event.data;
         this.logInput(data);
         this.console.execute(data);
      }
      
      private function logInput(data:String) : void
      {
         if(this.console.hasAction(data))
         {
            this.logAction(data);
         }
         else
         {
            this.logError(data);
         }
      }
      
      private function logAction(data:String) : void
      {
         var split:Array = data.split(" ");
         split[0] = ACTION_PATTERN.replace("${value}",split[0]);
         this.log.dispatch(split.join(" "));
      }
      
      private function logError(data:String) : void
      {
         var message:String = ERROR_PATTERN.replace("${value}",data);
         this.log.dispatch(message);
      }
      
      private function onGetPrevious(event:ConsoleEvent) : void
      {
         this.view.text = this.console.getPreviousAction();
      }
      
      private function onGetNext(event:ConsoleEvent) : void
      {
         this.view.text = this.console.getNextAction();
      }
   }
}
