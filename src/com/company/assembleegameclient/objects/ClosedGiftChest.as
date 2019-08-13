package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.game.signals.TextPanelMessageUpdateSignal;
   import kabam.rotmg.game.view.TextPanel;
   
   public class ClosedGiftChest extends GameObject implements IInteractiveObject
   {
       
      
      private var textPanelUpdateSignal:TextPanelMessageUpdateSignal;
      
      public function ClosedGiftChest(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
         this.textPanelUpdateSignal = StaticInjectorContext.getInjector().getInstance(TextPanelMessageUpdateSignal);
      }
      
      public function getTooltip() : ToolTip
      {
         var toolTip:ToolTip = new TextToolTip(3552822,10197915,"Gift Chest","Gift Chest is empty",200);
         return toolTip;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         this.textPanelUpdateSignal.dispatch("Gift chest Is empty");
         return new TextPanel(gs);
      }
   }
}
