package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.ui.components.TimerDisplay;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   
   public class BoostTimer extends Sprite
   {
       
      
      private var labelTextField:SimpleText;
      
      private var timerDisplay:TimerDisplay;
      
      public function BoostTimer()
      {
         super();
         this.createLabelTextField();
         this.labelTextField.x = 0;
         this.labelTextField.y = 0;
         var timerDisplayTextField:SimpleText = this.returnTimerTextField();
         this.timerDisplay = new TimerDisplay(timerDisplayTextField);
         this.timerDisplay.x = 0;
         this.timerDisplay.y = 20;
         addChild(this.timerDisplay);
         addChild(this.labelTextField);
      }
      
      private function returnTimerTextField() : SimpleText
      {
         var timeTextField:SimpleText = null;
         timeTextField = new SimpleText(16,16777103,false,0,0);
         timeTextField.setBold(true);
         timeTextField.multiline = true;
         timeTextField.mouseEnabled = true;
         timeTextField.filters = [new DropShadowFilter(0,0,0)];
         return timeTextField;
      }
      
      private function createLabelTextField() : void
      {
         this.labelTextField = new SimpleText(16,16777215,false,0,0);
         this.labelTextField.multiline = true;
         this.labelTextField.mouseEnabled = true;
         this.labelTextField.filters = [new DropShadowFilter(0,0,0)];
      }
      
      public function setLabel(string:String) : void
      {
         this.labelTextField.text = string;
         this.labelTextField.updateMetrics();
      }
      
      public function setTime(value:Number) : void
      {
         this.timerDisplay.update(value);
      }
   }
}
