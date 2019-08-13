package kabam.rotmg.packages.view
{
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BusyIndicator extends Sprite
   {
       
      
      private const pinwheel:Sprite = makePinWheel();
      
      private const innerCircleMask:Sprite = makeInner();
      
      private const quarterCircleMask:Sprite = makeQuarter();
      
      private const timer:Timer = new Timer(25);
      
      private const radius:int = 22;
      
      private const color:uint = 16777215;
      
      public function BusyIndicator()
      {
         super();
         x = y = this.radius;
         this.addChildren();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function makePinWheel() : Sprite
      {
         var s:Sprite = null;
         s = new Sprite();
         s.blendMode = BlendMode.LAYER;
         s.graphics.beginFill(this.color);
         s.graphics.drawCircle(0,0,this.radius);
         s.graphics.endFill();
         return s;
      }
      
      private function makeInner() : Sprite
      {
         var s:Sprite = new Sprite();
         s.blendMode = BlendMode.ERASE;
         s.graphics.beginFill(16777215 * 0.6);
         s.graphics.drawCircle(0,0,this.radius / 2);
         s.graphics.endFill();
         return s;
      }
      
      private function makeQuarter() : Sprite
      {
         var s:Sprite = new Sprite();
         s.graphics.beginFill(16777215);
         s.graphics.drawRect(0,0,this.radius,this.radius);
         s.graphics.endFill();
         return s;
      }
      
      private function addChildren() : void
      {
         this.pinwheel.addChild(this.innerCircleMask);
         this.pinwheel.addChild(this.quarterCircleMask);
         this.pinwheel.mask = this.quarterCircleMask;
         addChild(this.pinwheel);
      }
      
      private function onAdded(event:Event) : void
      {
         this.timer.addEventListener(TimerEvent.TIMER,this.updatePinwheel);
         this.timer.start();
      }
      
      private function onRemoved(event:Event) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.updatePinwheel);
      }
      
      private function updatePinwheel(event:TimerEvent) : void
      {
         this.quarterCircleMask.rotation = this.quarterCircleMask.rotation + 20;
      }
   }
}
