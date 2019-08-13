package kabam.rotmg.ui.model
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeSignal;
   
   public class PotionModel
   {
       
      
      public var objectId:uint;
      
      private var _costs:Array;
      
      private var _priceCooldownMillis:uint;
      
      public var _purchaseCooldownMillis:uint;
      
      public var maxPotionCount:int;
      
      public var position:int;
      
      public var available:Boolean;
      
      private var costIndex:int;
      
      private var costCoolDownTimer:Timer;
      
      private var costTimerSignal:NativeSignal;
      
      private var purchaseCoolDownTimer:Timer;
      
      private var purchaseTimerSignal:NativeSignal;
      
      public var update:Signal;
      
      public function PotionModel()
      {
         super();
         this.update = new Signal(int);
         this.available = true;
      }
      
      public function set costs(costs:Array) : void
      {
         this._costs = costs;
         if(costs != null && costs.length > 0)
         {
            this.costIndex = 0;
         }
      }
      
      public function get costs() : Array
      {
         return this._costs;
      }
      
      public function set priceCooldownMillis(millis:uint) : void
      {
         this._priceCooldownMillis = millis;
         this.costCoolDownTimer = new Timer(millis,0);
         this.costTimerSignal = new NativeSignal(this.costCoolDownTimer,TimerEvent.TIMER,TimerEvent);
         this.costTimerSignal.add(this.coolDownPrice);
      }
      
      public function set purchaseCooldownMillis(millis:uint) : void
      {
         this._purchaseCooldownMillis = millis;
         this.purchaseCoolDownTimer = new Timer(millis,0);
         this.purchaseTimerSignal = new NativeSignal(this.purchaseCoolDownTimer,TimerEvent.TIMER,TimerEvent);
         this.purchaseTimerSignal.add(this.coolDownPurchase);
      }
      
      public function purchasedPot() : void
      {
         if(this.available)
         {
            this.costCoolDownTimer.reset();
            this.costCoolDownTimer.start();
            this.purchaseCoolDownTimer.reset();
            this.purchaseCoolDownTimer.start();
            this.available = false;
            this.costIndex = this.costIndex + (this.costIndex > this.costs.length - 1?0:1);
            this.update.dispatch(this.position);
         }
      }
      
      private function coolDownPurchase(e:TimerEvent) : void
      {
         if(this.costIndex == 0)
         {
            this.purchaseCoolDownTimer.stop();
         }
         this.available = true;
         this.update.dispatch(this.position);
      }
      
      private function coolDownPrice(e:TimerEvent) : void
      {
         this.costIndex--;
         if(this.costIndex == 0)
         {
            this.costCoolDownTimer.stop();
         }
         this.update.dispatch(this.position);
      }
      
      public function currentCost(currentPotionCount:int) : int
      {
         var cost:int = 0;
         if(currentPotionCount <= 0)
         {
            cost = this.costs[this.costIndex];
         }
         return cost;
      }
   }
}
