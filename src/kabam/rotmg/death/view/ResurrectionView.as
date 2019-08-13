package kabam.rotmg.death.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import org.osflash.signals.Signal;
   
   public class ResurrectionView extends Sprite
   {
       
      
      public const showDialog:Signal = new Signal(Sprite);
      
      public const closed:Signal = new Signal();
      
      private const POPUP_BACKGROUND_COLOR:Number = 0;
      
      private const POPUP_LINE_COLOR:Number = 3881787;
      
      private const POPUP_WIDTH:Number = 300;
      
      private const POPUP_HEIGHT:Number = 400;
      
      private var deathTextString:String = "";
      
      private var popup:Dialog;
      
      public function ResurrectionView()
      {
         super();
         this.deathTextString = this.deathTextString + "Realm of the Mad God is a perma-death game.";
         this.deathTextString = this.deathTextString + "If you die, you\'ll lose your character and any items in your inventory, but you\'ll gain fame based on your deeds.";
         this.deathTextString = this.deathTextString + "<br>";
         this.deathTextString = this.deathTextString + "<br>";
         this.deathTextString = this.deathTextString + "You\'ve just been saved from death. ";
         this.deathTextString = this.deathTextString + "This won\'t happen again, so be careful adventurer!";
      }
      
      public function init(backgroundBitmapData:BitmapData) : void
      {
         this.createBackground(backgroundBitmapData);
         this.createPopup();
      }
      
      private function createBackground(backgroundBitmapData:BitmapData) : void
      {
         var matrix:Array = [0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,1,0];
         var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
         var background:Bitmap = new Bitmap(backgroundBitmapData);
         background.filters = [colorMatrixFilter];
         addChild(background);
      }
      
      public function createPopup() : void
      {
         this.popup = new Dialog(this.deathTextString,"YOU HAVE DIED!","Save Me",null);
         this.popup.addEventListener(Dialog.BUTTON1_EVENT,this.onButtonClick);
         this.showDialog.dispatch(this.popup);
      }
      
      private function onButtonClick(event:Event) : void
      {
         this.closed.dispatch();
      }
   }
}
