package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import kabam.display.Loader.LoaderProxy;
   import kabam.display.Loader.LoaderProxyConcrete;
   import kabam.lib.resizing.view.Resizable;
   import kabam.rotmg.packages.model.PackageModel;
   import org.osflash.signals.Signal;
   
   public class PackageOfferDialog extends Sprite implements Resizable
   {
      
      public static var CloseButtonAsset:Class = PackageOfferDialog_CloseButtonAsset;
       
      
      public var ready:Signal;
      
      public var buy:Signal;
      
      public var close:Signal;
      
      var loader:LoaderProxy;
      
      var goldDisplay:GoldDisplay;
      
      var image:DisplayObject;
      
      const paddingTop:Number = 6;
      
      const paddingRight:Number = 6;
      
      const paddingBottom:Number = 16;
      
      const fontSize:int = 27;
      
      private const busyIndicator:DisplayObject = makeBusyIndicator();
      
      private const buyNow:Sprite = makeBuyNow();
      
      private const title:SimpleText = makeTitle();
      
      private const closeButton:Sprite = makeCloseButton();
      
      private var packageModel:PackageModel;
      
      private var imageURL:String;
      
      private var spaceAvailable:Rectangle;
      
      public function PackageOfferDialog()
      {
         this.ready = new Signal();
         this.buy = new Signal();
         this.close = new Signal();
         this.loader = new LoaderProxyConcrete();
         this.goldDisplay = new GoldDisplay();
         this.spaceAvailable = new Rectangle();
         super();
      }
      
      private function makeBusyIndicator() : DisplayObject
      {
         var indicator:DisplayObject = new BusyIndicator();
         addChild(indicator);
         return indicator;
      }
      
      private function makeCloseButton() : Sprite
      {
         var closeButton:Sprite = new Sprite();
         closeButton.addChild(new CloseButtonAsset());
         return closeButton;
      }
      
      private function makeBuyNow() : TextButton
      {
         var buyNow:TextButton = new TextButton(16,"Buy Now",120);
         return buyNow;
      }
      
      private function makeTitle() : SimpleText
      {
         var text:SimpleText = new SimpleText(this.fontSize,11776947,false,0,0);
         return text;
      }
      
      public function setModel(value:PackageModel) : PackageOfferDialog
      {
         removeChild(this.busyIndicator);
         this.packageModel = value;
         this.setImageURL(this.packageModel.imageURL);
         return this;
      }
      
      public function getModel() : PackageModel
      {
         return this.packageModel;
      }
      
      private function onMouseUp(event:MouseEvent) : void
      {
         this.closeButton.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.close.dispatch();
      }
      
      private function setImageURL(value:String) : void
      {
         this.loader && this.loader.unload();
         this.imageURL = value;
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.load(new URLRequest(this.imageURL));
      }
      
      public function destroy() : void
      {
         this.loader.unload();
      }
      
      private function onIOError(event:IOErrorEvent) : void
      {
         this.removeListeners();
         this.populateDialog(new PackageBackground());
         this.ready.dispatch();
      }
      
      private function onComplete(event:Event) : void
      {
         this.removeListeners();
         this.populateDialog(this.loader);
         this.ready.dispatch();
      }
      
      private function populateDialog(image:DisplayObject) : void
      {
         this.setImage(image);
         this.handleTitle();
         this.handleCloseButton();
         this.handleBuyNow();
         this.handleGold();
         this.setTitle(this.packageModel.name);
         this.setGold(this.packageModel.price);
      }
      
      private function removeListeners() : void
      {
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
      }
      
      private function handleGold() : void
      {
         this.goldDisplay.init();
         addChild(this.goldDisplay);
         this.goldDisplay.x = this.buyNow.x - 16;
         this.goldDisplay.y = this.buyNow.y + this.buyNow.height / 2;
      }
      
      private function handleBuyNow() : void
      {
         addChild(this.buyNow);
         this.buyNow.x = this.image.width / 2 - this.buyNow.width / 2;
         this.buyNow.y = this.image.height - this.buyNow.height - this.paddingBottom;
         this.buyNow.addEventListener(MouseEvent.MOUSE_UP,this.onBuyNow);
      }
      
      private function onBuyNow(event:Event) : void
      {
         this.buyNow.removeEventListener(MouseEvent.MOUSE_UP,this.onBuyNow);
         this.buy.dispatch();
      }
      
      private function handleCloseButton() : void
      {
         addChild(this.closeButton);
         this.closeButton.x = this.image.width - this.closeButton.width - this.paddingRight;
         this.closeButton.y = this.paddingTop;
         this.closeButton.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      private function handleTitle() : void
      {
         addChild(this.title);
      }
      
      private function setImage(value:DisplayObject) : void
      {
         this.image && removeChild(this.image);
         this.image = value;
         this.image && addChild(this.image);
         this.center();
      }
      
      private function center() : void
      {
         x = (this.spaceAvailable.width - width) / 2;
         y = (this.spaceAvailable.height - height) / 2;
      }
      
      private function setTitle(value:String) : void
      {
         this.title.text = value;
         this.title.updateMetrics();
         this.title.height = this.title.actualHeight_;
         this.title.x = this.image.width / 2 - this.title.actualWidth_ / 2;
         this.title.y = this.paddingTop - this.fontSize / 3;
      }
      
      private function setGold(value:int) : void
      {
         this.goldDisplay.setGold(value);
      }
      
      public function resize(rectangle:Rectangle) : void
      {
         this.spaceAvailable = rectangle;
         this.center();
      }
   }
}
