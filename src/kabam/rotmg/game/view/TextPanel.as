package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   
   public class TextPanel extends Panel
   {
       
      
      private var textField:SimpleText;
      
      private var virtualWidth:Number;
      
      private var virtualHeight:Number;
      
      public function TextPanel(gs:GameSprite)
      {
         super(gs);
         this.initTextfield();
      }
      
      public function init(text:String) : void
      {
         this.textField.text = text;
         this.textField.x = (WIDTH - this.textField.width) / 2;
         this.textField.y = (HEIGHT - this.textField.height) / 2;
      }
      
      private function initTextfield() : void
      {
         this.textField = new SimpleText(16,16777215,false,0,0);
         this.textField.setBold(true);
         this.textField.text = "Gift Chest Is Empty";
         this.textField.updateMetrics();
         this.textField.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.textField);
      }
   }
}
