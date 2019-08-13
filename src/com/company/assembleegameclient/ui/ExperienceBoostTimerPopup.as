package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.ui.components.TimerDisplay;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   
   public class ExperienceBoostTimerPopup extends Sprite
   {
       
      
      private var timerDisplay:TimerDisplay;
      
      private var textField:SimpleText;
      
      public function ExperienceBoostTimerPopup()
      {
         super();
         this.textField = this.returnTimerTextField();
         this.textField.x = 5;
         this.timerDisplay = new TimerDisplay(this.textField);
         addChild(this.timerDisplay);
         this.timerDisplay.update(100000);
         graphics.lineStyle(2,16777215);
         graphics.beginFill(3552822);
         graphics.drawRoundRect(0,0,150,25,10);
         filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
      }
      
      public function update(time:Number) : void
      {
         this.timerDisplay.update(time);
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
   }
}
