package kabam.lib.console.view
{
   import flash.display.Sprite;
   
   public final class ConsoleView extends Sprite
   {
       
      
      public var output:ConsoleOutputView;
      
      public var input:ConsoleInputView;
      
      public function ConsoleView()
      {
         super();
         addChild(this.output = new ConsoleOutputView());
         addChild(this.input = new ConsoleInputView());
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(value && stage)
         {
            stage.focus = this.input;
         }
      }
   }
}
