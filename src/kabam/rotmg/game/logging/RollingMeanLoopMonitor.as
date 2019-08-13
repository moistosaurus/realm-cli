package kabam.rotmg.game.logging
{
   import kabam.lib.console.signals.ConsoleWatchSignal;
   
   public class RollingMeanLoopMonitor implements LoopMonitor
   {
       
      
      [Inject]
      public var watch:ConsoleWatchSignal;
      
      private var watchMap:Object;
      
      public function RollingMeanLoopMonitor()
      {
         super();
         this.watchMap = {};
      }
      
      public function recordTime(name:String, deltaTime:int) : void
      {
         var data:GameSpriteLoopWatch = this.watchMap[name] = this.watchMap[name] || new GameSpriteLoopWatch(name);
         data.logTime(deltaTime);
         this.watch.dispatch(data);
      }
   }
}
