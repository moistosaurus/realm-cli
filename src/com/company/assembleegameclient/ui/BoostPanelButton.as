package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BoostPanelButton extends Sprite
   {
       
      
      private var boostPanel:BoostPanel;
      
      private var player:Player;
      
      public function BoostPanelButton(player:Player)
      {
         var bitmap:Bitmap = null;
         super();
         this.player = player;
         var rawBitmapData:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig",22);
         var bitmapData:BitmapData = TextureRedrawer.redraw(rawBitmapData,20,true,0,0);
         bitmap = new Bitmap(bitmapData);
         bitmap.x = -7;
         bitmap.y = -10;
         addChild(bitmap);
         addEventListener(MouseEvent.MOUSE_OVER,this.onButtonOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onButtonOut);
      }
      
      private function onButtonOver(event:Event) : void
      {
         addChild(this.boostPanel = new BoostPanel(this.player));
         this.boostPanel.resized.add(this.positionBoostPanel);
         this.positionBoostPanel();
      }
      
      private function positionBoostPanel() : void
      {
         this.boostPanel.x = -this.boostPanel.width;
         this.boostPanel.y = -this.boostPanel.height;
      }
      
      private function onButtonOut(event:Event) : void
      {
         if(this.boostPanel)
         {
            removeChild(this.boostPanel);
         }
      }
   }
}
