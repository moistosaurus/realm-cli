package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.util.graphics.ButtonLayoutHelper;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class PackageInfoDialog extends Sprite
   {
      
      public static const BUTTON_TEXT:String = "Close";
      
      private static const TITLE_Y:int = 4;
      
      private static const BUTTON_WIDTH:int = 120;
      
      private static const BUTTON_FONT:int = 16;
      
      private static const DIALOG_WIDTH:int = 546;
      
      private static const INNER_WIDTH:int = 416;
      
      private static const BUTTON_Y:int = 368;
      
      private static const MESSAGE_TITLE_Y:int = 164;
      
      private static const MESSAGE_BODY_Y:int = 210;
       
      
      private const background:DisplayObject = makeBackground();
      
      private const title:SimpleText = makeTitle();
      
      private const messageTitle:SimpleText = makeMessageTitle();
      
      private const messageBody:SimpleText = makeMessageBody();
      
      private const close:TextButton = makeCloseButton();
      
      public const closed:Signal = new NativeMappedSignal(close,MouseEvent.CLICK);
      
      public function PackageInfoDialog()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         x = (stage.stageWidth - width) / 2;
         y = (stage.stageHeight - height) / 2;
      }
      
      public function setTitle(text:String) : PackageInfoDialog
      {
         this.title.setText(text);
         return this;
      }
      
      public function setBody(title:String, body:String) : PackageInfoDialog
      {
         this.messageTitle.setText(title);
         this.messageBody.setText(body);
         return this;
      }
      
      private function makeBackground() : DisplayObject
      {
         var background:PackageBackground = new PackageBackground();
         addChild(background);
         return background;
      }
      
      private function makeTitle() : SimpleText
      {
         var text:SimpleText = null;
         text = new SimpleText(18,11974326,false,DIALOG_WIDTH,0).setAlignment(TextFormatAlign.CENTER).setBold(true);
         text.y = TITLE_Y;
         addChild(text);
         return text;
      }
      
      private function makeMessageTitle() : SimpleText
      {
         var text:SimpleText = null;
         text = new SimpleText(14,14864077,false,INNER_WIDTH,0).setAlignment(TextFormatAlign.CENTER).setBold(true);
         text.x = (DIALOG_WIDTH - INNER_WIDTH) * 0.5;
         text.y = MESSAGE_TITLE_Y;
         addChild(text);
         return text;
      }
      
      private function makeMessageBody() : SimpleText
      {
         var text:SimpleText = new SimpleText(14,10914439,false,INNER_WIDTH,0).setAlignment(TextFormatAlign.CENTER);
         text.x = (DIALOG_WIDTH - INNER_WIDTH) * 0.5;
         text.y = MESSAGE_BODY_Y;
         addChild(text);
         return text;
      }
      
      private function makeCloseButton() : TextButton
      {
         var button:TextButton = new TextButton(BUTTON_FONT,BUTTON_TEXT,BUTTON_WIDTH);
         new ButtonLayoutHelper().layout(DIALOG_WIDTH,button);
         button.y = BUTTON_Y;
         addChild(button);
         return button;
      }
   }
}
