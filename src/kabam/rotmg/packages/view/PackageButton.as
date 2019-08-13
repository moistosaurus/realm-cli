package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.TimeUtil;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.packages.model.PackageModel;
   import kabam.rotmg.ui.UIUtils;
   import org.osflash.signals.Signal;
   
   public class PackageButton extends Sprite
   {
       
      
      private var _quantity:int;
      
      private const SHOW_DURATION:String = "showDuration";
      
      private const SHOW_QUANTITY:String = "showQuantity";
      
      private var _state:String = "showDuration";
      
      var durationText:SimpleText;
      
      var quantityText:SimpleText;
      
      var _icon:DisplayObject;
      
      public var clicked:Signal;
      
      public function PackageButton()
      {
         this.durationText = this.makeText();
         this.quantityText = this.makeText();
         this.clicked = new Signal();
         super();
      }
      
      private function makeText() : SimpleText
      {
         var simple:SimpleText = null;
         simple = new SimpleText(16,16777215,false,0,0);
         simple.filters = [new DropShadowFilter(0,0,0)];
         return simple;
      }
      
      public function init() : void
      {
         addChild(UIUtils.returnHudNotificationBackground());
         var redLootBag:BitmapData = AssetLibrary.getImageFromSet("redLootBag",0);
         redLootBag = TextureRedrawer.redraw(redLootBag,40,true,0,0);
         var icon:DisplayObject = new Bitmap(redLootBag);
         icon.x = -7;
         icon.y = -7;
         this.durationText.height = this.durationText.textHeight;
         this.quantityText.height = this.quantityText.textHeight;
         addChild(this.durationText);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.setIcon(icon);
      }
      
      private function setState(state:String) : void
      {
         if(this._state == state)
         {
            return;
         }
         if(state == this.SHOW_DURATION)
         {
            removeChild(this.quantityText);
            addChild(this.durationText);
         }
         else if(state == this.SHOW_QUANTITY)
         {
            removeChild(this.durationText);
            addChild(this.quantityText);
         }
         else
         {
            throw new Error("PackageButton.setState: Unexpected state " + state);
         }
         this._state = state;
      }
      
      public function setQuantity(value:int) : void
      {
         this._quantity = value;
         if(this._quantity == PackageModel.INFINITE)
         {
            this.setState(this.SHOW_DURATION);
         }
         else
         {
            this.setState(this.SHOW_QUANTITY);
         }
         this.quantityText.text = String(value);
         this.quantityText.updateMetrics();
         this.moveText(this.quantityText);
      }
      
      private function moveText(simpleText:SimpleText) : void
      {
         simpleText.x = this._icon.x + this._icon.width;
         simpleText.y = this._icon.y + this._icon.height / 2 - simpleText.actualHeight_ / 2;
      }
      
      public function setDuration(value:int) : void
      {
         var days:int = Math.ceil(value / TimeUtil.DAY_IN_MS);
         var daysString:String = days + " day";
         if(days > 1)
         {
            daysString = daysString + "s";
         }
         this.durationText.text = daysString;
         this.durationText.updateMetrics();
         this.moveText(this.durationText);
      }
      
      private function setIcon(value:DisplayObject) : void
      {
         this._icon = value;
         addChild(value);
      }
      
      private function onMouseUp(event:Event) : void
      {
         this.clicked.dispatch();
      }
   }
}
