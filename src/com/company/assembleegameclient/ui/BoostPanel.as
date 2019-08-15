package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.Timer;
   import org.osflash.signals.Signal;
   
   public class BoostPanel extends Sprite
   {
       
      
      public const resized:Signal = new Signal();
      
      private const SPACE:uint = 40;
      
      private var timer:Timer;
      
      private var player:Player;
      
      private var tierBoostTimer:BoostTimer;
      
      private var dropBoostTimer:BoostTimer;
      
      public function BoostPanel(player:Player)
      {
         super();
         this.player = player;
         this.createHeader();
         this.createBoostTimers();
         this.createTimer();
      }
      
      private function createTimer() : void
      {
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.update);
         this.timer.start();
      }
      
      private function update(event:TimerEvent) : void
      {
         this.updateTimer(this.tierBoostTimer,this.player.tierBoost);
         this.updateTimer(this.dropBoostTimer,this.player.dropBoost);
      }
      
      private function updateTimer(timer:BoostTimer, value:int) : void
      {
         if(timer)
         {
            if(value)
            {
               timer.setTime(value);
            }
            else
            {
               this.destroyBoostTimers();
               this.createBoostTimers();
            }
         }
      }
      
      private function createHeader() : void
      {
         var bitmap:Bitmap = null;
         var headerTextField:SimpleText = null;
         var bitmapData:BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterfaceBig",22),20,true,0);
         bitmap = new Bitmap(bitmapData);
         bitmap.x = -3;
         bitmap.y = -1;
         addChild(bitmap);
         headerTextField = new SimpleText(16,65280,false,0,0);
         headerTextField.setBold(true);
         headerTextField.text = "Active Boosts";
         headerTextField.multiline = true;
         headerTextField.mouseEnabled = true;
         headerTextField.updateMetrics();
         headerTextField.filters = [new DropShadowFilter(0,0,0)];
         headerTextField.x = 20;
         headerTextField.y = 4;
         addChild(headerTextField);
      }
      
      private function createBackground() : void
      {
         graphics.clear();
         graphics.lineStyle(2,16777215);
         graphics.beginFill(3355443);
         graphics.drawRoundRect(0,0,150,height + 5,10);
         this.resized.dispatch();
      }
      
      private function createBoostTimers() : void
      {
         var posY:uint = 0;
         posY = 25;
         if(this.player.dropBoost)
         {
            addChild(this.dropBoostTimer = this.returnBoostTimer("1.5x drop rate",this.player.dropBoost));
            this.dropBoostTimer.y = posY;
            this.dropBoostTimer.x = 10;
            posY = posY + this.SPACE;
         }
         if(this.player.tierBoost)
         {
            addChild(this.tierBoostTimer = this.returnBoostTimer("Tier level increased",this.player.tierBoost));
            this.tierBoostTimer.y = posY;
            this.tierBoostTimer.x = 10;
            posY = posY + this.SPACE;
         }
         this.createBackground();
      }
      
      private function destroyBoostTimers() : void
      {
         if(this.tierBoostTimer && this.tierBoostTimer.parent)
         {
            removeChild(this.tierBoostTimer);
         }
         if(this.dropBoostTimer && this.dropBoostTimer.parent)
         {
            removeChild(this.dropBoostTimer);
         }
         this.tierBoostTimer = null;
         this.dropBoostTimer = null;
      }
      
      private function returnBoostTimer(label:String, time:int) : BoostTimer
      {
         var boostTimer:BoostTimer = new BoostTimer();
         boostTimer.setLabel(label);
         boostTimer.setTime(time);
         return boostTimer;
      }
   }
}
