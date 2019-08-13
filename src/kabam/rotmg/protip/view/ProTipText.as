package kabam.rotmg.protip.view
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ProTipText extends Sprite
   {
       
      
      private var text:SimpleText;
      
      public function ProTipText()
      {
         super();
      }
      
      public function setTip(tip:String) : void
      {
         this.text = new SimpleText(18,16777215,false,0,0);
         this.text.wordWrap = true;
         this.text.multiline = true;
         this.text.height = 100;
         this.text.width = 580;
         this.text.x = -290;
         this.text.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.text.text = "Tip: " + tip;
         var format:TextFormat = this.text.getTextFormat();
         format.align = TextFormatAlign.CENTER;
         this.text.setTextFormat(format);
         mouseEnabled = false;
         mouseChildren = false;
         addChild(this.text);
      }
   }
}
