package kabam.lib.console.view
{
   import com.junkbyte.console.Console;
   import com.junkbyte.console.ConsoleConfig;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import kabam.lib.console.model.Watch;
   import kabam.lib.resizing.view.Resizable;
   
   public final class ConsoleOutputView extends Sprite implements Resizable
   {
      
      private static const DEFAULT_OUTPUT:String = "kabam.lib/console";
       
      
      private const PATTERN:RegExp = /\[0x(.+)\:(.+)\]/ig;
      
      private const HTML_TEMPLATE:String = "<font color=\'#$1\'>$2</font>";
      
      private var watchTextField:TextField;
      
      private var logConsole:Console;
      
      private const logged:Array = [];
      
      private const watched:Array = [];
      
      private const watchMap:Object = {};
      
      private var watchBottom:Number;
      
      public function ConsoleOutputView()
      {
         this.watchTextField = new TextField();
         super();
         alpha = 0.8;
         blendMode = BlendMode.LAYER;
         addChild(this.watchTextField);
         this.watchTextField.alpha = 0.6;
         this.watchTextField.defaultTextFormat = new TextFormat("_sans",14,16777215,true);
         this.watchTextField.htmlText = DEFAULT_OUTPUT;
         this.watchTextField.selectable = false;
         this.watchTextField.multiline = true;
         this.watchTextField.wordWrap = true;
         this.watchTextField.autoSize = TextFieldAutoSize.LEFT;
         this.watchTextField.background = true;
         this.watchTextField.border = false;
         this.watchTextField.backgroundColor = 13056;
         this.logConsole = new Console("",new ConsoleConfig());
         addChild(this.logConsole);
      }
      
      public function watch(input:Watch) : void
      {
         var watch:Watch = this.watchMap[input.name] = this.watchMap[input.name] || this.makeWatch(input.name);
         watch.data = input.data.replace(this.PATTERN,this.HTML_TEMPLATE);
         this.updateOutputText();
      }
      
      public function unwatch(name:String) : void
      {
         var watch:Watch = this.watchMap[name];
         if(watch)
         {
            delete this.watchMap[name];
            this.watched.splice(this.watched.indexOf(watch),1);
         }
      }
      
      private function makeWatch(name:String) : Watch
      {
         var watch:Watch = new Watch(name);
         this.watched.push(watch);
         return watch;
      }
      
      public function log(data:String) : void
      {
         var logString:String = data.replace(this.PATTERN,this.HTML_TEMPLATE);
         this.logged.push(logString);
         this.logConsole.addHTML(logString);
      }
      
      public function clear() : void
      {
         var key:* = null;
         this.logged.length = 0;
         this.watched.length = 0;
         for(key in this.watchMap)
         {
            delete this.watchMap[key];
         }
      }
      
      public function resize(rectangle:Rectangle) : void
      {
         this.watchBottom = rectangle.height - ConsoleInputView.HEIGHT;
         x = rectangle.x;
         y = rectangle.y;
         this.watchTextField.width = rectangle.width;
         this.logConsole.width = rectangle.width;
         this.snapWatchTextToInputView();
      }
      
      private function snapWatchTextToInputView() : void
      {
         this.watchTextField.y = this.watchBottom - this.watchTextField.height;
      }
      
      private function updateOutputText() : void
      {
         this.watchTextField.htmlText = this.watched.join("\n");
         this.snapWatchTextToInputView();
      }
      
      public function getText() : String
      {
         return this.logged.join("\r");
      }
   }
}
