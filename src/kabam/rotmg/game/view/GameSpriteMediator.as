package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.game.events.ReconnectEvent;
   import com.company.assembleegameclient.objects.Player;
   import kabam.rotmg.core.model.MapModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.InvalidateDataSignal;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.game.logging.LoopMonitor;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.DisconnectGameSignal;
   import kabam.rotmg.game.signals.GameClosedSignal;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import kabam.rotmg.game.signals.SetWorldInteractionSignal;
   import kabam.rotmg.packages.control.BeginnersPackageAvailableSignal;
   import kabam.rotmg.packages.control.InitPackagesSignal;
   import kabam.rotmg.packages.control.OpenPackageSignal;
   import kabam.rotmg.packages.control.PackageAvailableSignal;
   import kabam.rotmg.packages.model.PackageModel;
   import kabam.rotmg.packages.services.Packages;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   import kabam.rotmg.promotions.signals.ShowBeginnersPackageSignal;
   import kabam.rotmg.ui.signals.HUDModelInitialized;
   import kabam.rotmg.ui.signals.HUDSetupStarted;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class GameSpriteMediator extends Mediator
   {
       
      
      [Inject]
      public var view:GameSprite;
      
      [Inject]
      public var setWorldInteraction:SetWorldInteractionSignal;
      
      [Inject]
      public var invalidate:InvalidateDataSignal;
      
      [Inject]
      public var setScreenWithValidData:SetScreenWithValidDataSignal;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var gameClosed:GameClosedSignal;
      
      [Inject]
      public var mapModel:MapModel;
      
      [Inject]
      public var beginnersPackageModel:BeginnersPackageModel;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var disconnect:DisconnectGameSignal;
      
      [Inject]
      public var monitor:LoopMonitor;
      
      [Inject]
      public var hudSetupStarted:HUDSetupStarted;
      
      [Inject]
      public var updateHUDSignal:UpdateHUDSignal;
      
      [Inject]
      public var hudModelInitialized:HUDModelInitialized;
      
      [Inject]
      public var beginnersPackageAvailable:BeginnersPackageAvailableSignal;
      
      [Inject]
      public var packageAvailable:PackageAvailableSignal;
      
      [Inject]
      public var initPackages:InitPackagesSignal;
      
      [Inject]
      public var showBeginnersPackage:ShowBeginnersPackageSignal;
      
      [Inject]
      public var packages:Packages;
      
      [Inject]
      public var openPackageSignal:OpenPackageSignal;
      
      public function GameSpriteMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.packages = this.packages;
         this.setWorldInteraction.add(this.onSetWorldInteraction);
         addViewListener(ReconnectEvent.RECONNECT,this.onReconnect);
         this.view.modelInitialized.add(this.onGameSpriteModelInitialized);
         this.view.drawCharacterWindow.add(this.onStatusPanelDraw);
         this.hudModelInitialized.add(this.onHUDModelInitialized);
         this.disconnect.add(this.onDisconnect);
         this.view.monitor.add(this.onMonitor);
         this.view.closed.add(this.onClosed);
         this.view.mapModel = this.mapModel;
         this.view.beginnersPackageModel = this.beginnersPackageModel;
         this.view.connect();
         this.view.showBeginnersPackage = this.showBeginnersPackage;
         this.view.showPackage.add(this.onShowPackage);
      }
      
      private function onShowPackage() : void
      {
         var model:PackageModel = this.packages.getPriorityPackage();
         if(model)
         {
            this.openPackageSignal.dispatch(model.packageID);
         }
      }
      
      override public function destroy() : void
      {
         this.view.showPackage.remove(this.onShowPackage);
         this.setWorldInteraction.remove(this.onSetWorldInteraction);
         removeViewListener(ReconnectEvent.RECONNECT,this.onReconnect);
         this.view.modelInitialized.remove(this.onGameSpriteModelInitialized);
         this.view.drawCharacterWindow.remove(this.onStatusPanelDraw);
         this.hudModelInitialized.remove(this.onHUDModelInitialized);
         this.disconnect.remove(this.onDisconnect);
         this.beginnersPackageAvailable.remove(this.onBeginner);
         this.packageAvailable.remove(this.onPackage);
         this.view.closed.remove(this.onClosed);
         this.view.monitor.remove(this.onMonitor);
         this.view.disconnect();
      }
      
      private function onDisconnect() : void
      {
         this.view.disconnect();
      }
      
      private function onMonitor(name:String, time:int) : void
      {
         this.monitor.recordTime(name,time);
      }
      
      public function onSetWorldInteraction(value:Boolean) : void
      {
         this.view.mui_.setEnablePlayerInput(value);
      }
      
      private function onClosed() : void
      {
         this.closeDialogs.dispatch();
         this.gameClosed.dispatch();
      }
      
      private function onReconnect(event:ReconnectEvent) : void
      {
         if(this.view.isEditor)
         {
            return;
         }
         var data:GameInitData = new GameInitData();
         data.server = event.server_;
         data.gameId = event.gameId_;
         data.createCharacter = event.createCharacter_;
         data.charId = event.charId_;
         data.keyTime = event.keyTime_;
         data.key = event.key_;
         this.playGame.dispatch(data);
      }
      
      private function onGameSpriteModelInitialized() : void
      {
         this.hudSetupStarted.dispatch(this.view);
         this.beginnersPackageAvailable.add(this.onBeginner);
         this.packageAvailable.add(this.onPackage);
         this.initPackages.dispatch();
      }
      
      private function onBeginner() : void
      {
         this.view.showBeginnersOfferButton();
      }
      
      private function onPackage() : void
      {
         this.view.showPackageButton();
      }
      
      private function onStatusPanelDraw(player:Player) : void
      {
         this.updateHUDSignal.dispatch(player);
      }
      
      private function onHUDModelInitialized() : void
      {
         this.view.hudModelInitialized();
      }
   }
}
