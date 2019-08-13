package kabam.rotmg.game.logging
{
   import kabam.lib.console.model.Watch;
   
   public class GameSpriteLoopWatch extends Watch
   {
      
      private static const WATCH_PATTERN:String = "[{NAME}] [0x33FF33:{/x {MEAN}ms (min {MIN}ms, max {MAX}ms)]";
      
      private static const COUNT:int = 10;
       
      
      private var times:Vector.<int>;
      
      private var index:int;
      
      private var count:int;
      
      public var rollingTotal:int;
      
      public var mean:int;
      
      public var max:int;
      
      public var min:int;
      
      public function GameSpriteLoopWatch(name:String)
      {
         super(name);
         this.times = new Vector.<int>(COUNT,true);
         this.index = 0;
         this.rollingTotal = 0;
         this.count = 0;
         this.min = int.MAX_VALUE;
         this.max = -1;
      }
      
      public function logTime(time:int) : void
      {
         if(this.count < COUNT)
         {
            this.rollingTotal = this.rollingTotal + time;
            this.count++;
            this.times[this.index] = time;
         }
         else
         {
            this.rollingTotal = this.rollingTotal - this.times[this.index];
            this.rollingTotal = this.rollingTotal + time;
            this.times[this.index] = time;
         }
         if(++this.index == COUNT)
         {
            this.index = 0;
         }
         this.mean = this.rollingTotal / this.count;
         if(time > this.max)
         {
            this.max = time;
         }
         if(time < this.min)
         {
            this.min = time;
         }
         data = WATCH_PATTERN.replace("{NAME}",name).replace("{MEAN}",this.mean).replace("{MIN}",this.min).replace("{MAX}",this.max);
      }
   }
}
