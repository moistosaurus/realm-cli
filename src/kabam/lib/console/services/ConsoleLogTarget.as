package kabam.lib.console.services
{
   import kabam.lib.console.signals.ConsoleLogSignal;
   import robotlegs.bender.extensions.logging.impl.LogMessageParser;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILogTarget;
   import robotlegs.bender.framework.api.LogLevel;
   
   public class ConsoleLogTarget implements ILogTarget
   {
       
      
      private var consoleLog:ConsoleLogSignal;
      
      private var messageParser:LogMessageParser;
      
      public function ConsoleLogTarget(context:IContext)
      {
         super();
         this.consoleLog = context.injector.getInstance(ConsoleLogSignal);
         this.messageParser = new LogMessageParser();
      }
      
      public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null) : void
      {
         var text:String = LogLevel.NAME[level] + " " + source + " " + this.messageParser.parseMessage(message,params);
         this.consoleLog.dispatch(text);
      }
   }
}
