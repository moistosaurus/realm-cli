package kabam.rotmg.protip.view
{
   import com.gskinner.motion.GTween;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class ProTipView extends Sprite
   {
       
      
      private var text:ProTipText;
      
      public function ProTipView()
      {
         super();
         this.text = new ProTipText();
         this.text.x = 300;
         this.text.y = 125;
         addChild(this.text);
         filters = [new GlowFilter(0,1,3,3,2,1)];
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function setTip(tip:String) : void
      {
         this.text.setTip(tip);
         var tween:GTween = new GTween(this,5,{"alpha":0});
         tween.delay = 5;
         tween.onComplete = this.removeSelf;
      }
      
      private function removeSelf(tween:GTween) : void
      {
         parent && parent.removeChild(this);
      }
   }
}
