package com.company.assembleegameclient.game
{
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.tutorial.Tutorial;
   import com.company.assembleegameclient.tutorial.doneAction;
   import com.company.assembleegameclient.ui.options.Options;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.KeyCodes;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.constants.GeneralConstants;
   import kabam.rotmg.constants.UseType;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.view.Layers;
   import kabam.rotmg.game.model.AddTextLineVO;
   import kabam.rotmg.game.model.PotionInventoryModel;
   import kabam.rotmg.game.model.UseBuyPotionVO;
   import kabam.rotmg.game.signals.AddTextLineSignal;
   import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
   import kabam.rotmg.game.signals.SetTextBoxVisibilitySignal;
   import kabam.rotmg.game.signals.UseBuyPotionSignal;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.minimap.control.MiniMapZoomSignal;
   import kabam.rotmg.ui.model.TabStripModel;
   import net.hires.debug.Stats;
   import org.swiftsuspenders.Injector;
   
   public class MapUserInput
   {
      
      private static var stats_:Stats = new Stats();
      
      private static const MOUSE_DOWN_WAIT_PERIOD:uint = 175;
      
      private static var arrowWarning_:Boolean = false;
       
      
      public var gs_:GameSprite;
      
      private var moveLeft_:Boolean = false;
      
      private var moveRight_:Boolean = false;
      
      private var moveUp_:Boolean = false;
      
      private var moveDown_:Boolean = false;
      
      private var rotateLeft_:Boolean = false;
      
      private var rotateRight_:Boolean = false;
      
      private var mouseDown_:Boolean = false;
      
      private var autofire_:Boolean = false;
      
      private var specialKeyDown_:Boolean = false;
      
      private var enablePlayerInput_:Boolean = true;
      
      private var mouseDownTimer:Timer;
      
      private var mouseDownCount:uint;
      
      private var giftStatusUpdateSignal:GiftStatusUpdateSignal;
      
      private var addTextLine:AddTextLineSignal;
      
      private var setTextBoxVisibility:SetTextBoxVisibilitySignal;
      
      private var miniMapZoom:MiniMapZoomSignal;
      
      private var useBuyPotionSignal:UseBuyPotionSignal;
      
      private var potionInventoryModel:PotionInventoryModel;
      
      private var tabStripModel:TabStripModel;
      
      private var layers:Layers;
      
      private var areFKeysAvailable:Boolean;
      
      public function MapUserInput(gs:GameSprite)
      {
         super();
         this.gs_ = gs;
         this.mouseDownTimer = new Timer(MOUSE_DOWN_WAIT_PERIOD,1);
         this.mouseDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onMouseDownWaitPeriodOver);
         this.gs_.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.gs_.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         var injector:Injector = StaticInjectorContext.getInjector();
         this.giftStatusUpdateSignal = injector.getInstance(GiftStatusUpdateSignal);
         this.addTextLine = injector.getInstance(AddTextLineSignal);
         this.setTextBoxVisibility = injector.getInstance(SetTextBoxVisibilitySignal);
         this.miniMapZoom = injector.getInstance(MiniMapZoomSignal);
         this.useBuyPotionSignal = injector.getInstance(UseBuyPotionSignal);
         this.potionInventoryModel = injector.getInstance(PotionInventoryModel);
         this.tabStripModel = injector.getInstance(TabStripModel);
         this.layers = injector.getInstance(Layers);
         var setup:ApplicationSetup = injector.getInstance(ApplicationSetup);
         this.areFKeysAvailable = setup.areDeveloperHotkeysEnabled();
      }
      
      public function clearInput() : void
      {
         this.moveLeft_ = false;
         this.moveRight_ = false;
         this.moveUp_ = false;
         this.moveDown_ = false;
         this.rotateLeft_ = false;
         this.rotateRight_ = false;
         this.mouseDown_ = false;
         this.autofire_ = false;
         this.setPlayerMovement();
      }
      
      public function setEnablePlayerInput(enable:Boolean) : void
      {
         if(this.enablePlayerInput_ != enable)
         {
            this.enablePlayerInput_ = enable;
            this.clearInput();
         }
      }
      
      private function onAddedToStage(event:Event) : void
      {
         var stage:Stage = this.gs_.stage;
         stage.addEventListener(Event.ACTIVATE,this.onActivate);
         stage.addEventListener(Event.DEACTIVATE,this.onDeactivate);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.gs_.map.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.gs_.map.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.gs_.map.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         var stage:Stage = this.gs_.stage;
         stage.removeEventListener(Event.ACTIVATE,this.onActivate);
         stage.removeEventListener(Event.DEACTIVATE,this.onDeactivate);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.gs_.map.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.gs_.map.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.gs_.map.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onActivate(event:Event) : void
      {
      }
      
      private function onDeactivate(event:Event) : void
      {
         this.clearInput();
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         var itemType:int = 0;
         var objectXML:XML = null;
         var player:Player = this.gs_.map.player_;
         if(player == null)
         {
            return;
         }
         if(this.mouseDownTimer.running == false)
         {
            this.mouseDownCount = 1;
            this.mouseDownTimer.start();
         }
         else
         {
            this.mouseDownCount++;
         }
         if(!this.enablePlayerInput_)
         {
            return;
         }
         if(event.shiftKey)
         {
            itemType = player.equipment_[1];
            if(itemType == -1)
            {
               return;
            }
            objectXML = ObjectLibrary.xmlLibrary_[itemType];
            if(objectXML == null || objectXML.hasOwnProperty("EndMpCost"))
            {
               return;
            }
            player.useAltWeapon(event.localX,event.localY,UseType.START_USE);
            return;
         }
         doneAction(this.gs_,Tutorial.ATTACK_ACTION);
         var angle:Number = Math.atan2(event.localY,event.localX);
         player.attemptAttackAngle(angle);
         this.mouseDown_ = true;
      }
      
      private function onMouseDownWaitPeriodOver(e:TimerEvent) : void
      {
         var pt:Point = null;
         if(this.mouseDownCount > 1)
         {
            pt = this.gs_.map.pSTopW(this.gs_.map.mouseX,this.gs_.map.mouseY);
            trace("World point: " + pt.x + ", " + pt.y);
         }
      }
      
      private function onMouseUp(event:MouseEvent) : void
      {
         this.mouseDown_ = false;
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         if(event.delta > 0)
         {
            this.miniMapZoom.dispatch(MiniMapZoomSignal.IN);
         }
         else
         {
            this.miniMapZoom.dispatch(MiniMapZoomSignal.OUT);
         }
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var angle:Number = NaN;
         var player:Player = null;
         doneAction(this.gs_,Tutorial.UPDATE_ACTION);
         if(this.enablePlayerInput_ && (this.mouseDown_ || this.autofire_))
         {
            angle = Math.atan2(this.gs_.map.mouseY,this.gs_.map.mouseX);
            player = this.gs_.map.player_;
            if(player != null)
            {
               player.attemptAttackAngle(angle);
            }
         }
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         var success:Boolean = false;
         var square:Square = null;
         var stage:Stage = this.gs_.stage;
         switch(event.keyCode)
         {
            case KeyCodes.F1:
            case KeyCodes.F2:
            case KeyCodes.F3:
            case KeyCodes.F4:
            case KeyCodes.F5:
            case KeyCodes.F6:
            case KeyCodes.F7:
            case KeyCodes.F8:
            case KeyCodes.F9:
            case KeyCodes.F10:
            case KeyCodes.F11:
            case KeyCodes.F12:
            case KeyCodes.INSERT:
               break;
            default:
               if(stage.focus != null)
               {
                  return;
               }
               break;
         }
         var player:Player = this.gs_.map.player_;
         switch(event.keyCode)
         {
            case Parameters.data_.moveUp:
               doneAction(this.gs_,Tutorial.MOVE_FORWARD_ACTION);
               this.moveUp_ = true;
               break;
            case Parameters.data_.moveDown:
               doneAction(this.gs_,Tutorial.MOVE_BACKWARD_ACTION);
               this.moveDown_ = true;
               break;
            case Parameters.data_.moveLeft:
               doneAction(this.gs_,Tutorial.MOVE_LEFT_ACTION);
               this.moveLeft_ = true;
               break;
            case Parameters.data_.moveRight:
               doneAction(this.gs_,Tutorial.MOVE_RIGHT_ACTION);
               this.moveRight_ = true;
               break;
            case Parameters.data_.rotateLeft:
               if(!Parameters.data_.allowRotation)
               {
                  break;
               }
               doneAction(this.gs_,Tutorial.ROTATE_LEFT_ACTION);
               this.rotateLeft_ = true;
               break;
            case Parameters.data_.rotateRight:
               if(!Parameters.data_.allowRotation)
               {
                  break;
               }
               doneAction(this.gs_,Tutorial.ROTATE_RIGHT_ACTION);
               this.rotateRight_ = true;
               break;
            case Parameters.data_.resetToDefaultCameraAngle:
               Parameters.data_.cameraAngle = Parameters.data_.defaultCameraAngle;
               Parameters.save();
               break;
            case Parameters.data_.useSpecial:
               if(!this.specialKeyDown_)
               {
                  success = player.useAltWeapon(this.gs_.map.mouseX,this.gs_.map.mouseY,UseType.START_USE);
                  if(success)
                  {
                     this.specialKeyDown_ = true;
                  }
               }
               break;
            case Parameters.data_.autofireToggle:
               this.autofire_ = !this.autofire_;
               break;
            case Parameters.data_.useInvSlot1:
               this.useItem(4);
               break;
            case Parameters.data_.useInvSlot2:
               this.useItem(5);
               break;
            case Parameters.data_.useInvSlot3:
               this.useItem(6);
               break;
            case Parameters.data_.useInvSlot4:
               this.useItem(7);
               break;
            case Parameters.data_.useInvSlot5:
               this.useItem(8);
               break;
            case Parameters.data_.useInvSlot6:
               this.useItem(9);
               break;
            case Parameters.data_.useInvSlot7:
               this.useItem(10);
               break;
            case Parameters.data_.useInvSlot8:
               this.useItem(11);
               break;
            case Parameters.data_.useHealthPotion:
               if(this.potionInventoryModel.getPotionModel(PotionInventoryModel.HEALTH_POTION_ID).available)
               {
                  this.useBuyPotionSignal.dispatch(new UseBuyPotionVO(PotionInventoryModel.HEALTH_POTION_ID,UseBuyPotionVO.CONTEXTBUY));
               }
               break;
            case Parameters.data_.useMagicPotion:
               if(this.potionInventoryModel.getPotionModel(PotionInventoryModel.MAGIC_POTION_ID).available)
               {
                  this.useBuyPotionSignal.dispatch(new UseBuyPotionVO(PotionInventoryModel.MAGIC_POTION_ID,UseBuyPotionVO.CONTEXTBUY));
               }
               break;
            case Parameters.data_.miniMapZoomOut:
               this.miniMapZoom.dispatch(MiniMapZoomSignal.OUT);
               break;
            case Parameters.data_.miniMapZoomIn:
               this.miniMapZoom.dispatch(MiniMapZoomSignal.IN);
               break;
            case Parameters.data_.togglePerformanceStats:
               this.togglePerformanceStats();
               break;
            case Parameters.data_.escapeToNexus:
            case Parameters.data_.escapeToNexus2:
               this.gs_.gsc_.escape();
               Parameters.data_.needsRandomRealm = false;
               Parameters.save();
               break;
            case Parameters.data_.options:
               this.clearInput();
               this.layers.overlay.addChild(new Options(this.gs_));
               break;
            case Parameters.data_.toggleCentering:
               Parameters.data_.centerOnPlayer = !Parameters.data_.centerOnPlayer;
               Parameters.save();
               break;
            case Parameters.data_.toggleFullscreen:
               if(Capabilities.playerType == "Desktop")
               {
                  Parameters.data_.fullscreenMode = !Parameters.data_.fullscreenMode;
                  Parameters.save();
                  stage.displayState = Boolean(Parameters.data_.fullscreenMode)?"fullScreenInteractive":StageDisplayState.NORMAL;
               }
               break;
            case Parameters.data_.testOne:
               break;
            case Parameters.data_.testTwo:
         }
         if(Parameters.ALLOW_SCREENSHOT_MODE)
         {
            switch(event.keyCode)
            {
               case KeyCodes.F2:
                  this.toggleScreenShotMode();
                  break;
               case KeyCodes.F3:
                  Parameters.screenShotSlimMode_ = !Parameters.screenShotSlimMode_;
                  break;
               case KeyCodes.F4:
                  this.gs_.map.mapOverlay_.visible = !this.gs_.map.mapOverlay_.visible;
                  this.gs_.map.partyOverlay_.visible = !this.gs_.map.partyOverlay_.visible;
            }
         }
         if(this.areFKeysAvailable)
         {
            switch(event.keyCode)
            {
               case KeyCodes.F6:
                  TextureRedrawer.clearCache();
                  Parameters.projColorType_ = (Parameters.projColorType_ + 1) % 7;
                  this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,"Projectile Color Type: " + Parameters.projColorType_));
                  break;
               case KeyCodes.F7:
                  for each(square in this.gs_.map.squares_)
                  {
                     if(square != null)
                     {
                        square.faces_.length = 0;
                     }
                  }
                  Parameters.blendType_ = (Parameters.blendType_ + 1) % 2;
                  this.addTextLine.dispatch(new AddTextLineVO(Parameters.CLIENT_CHAT_NAME,"Blend type: " + Parameters.blendType_));
                  break;
               case KeyCodes.F8:
                  Parameters.data_.surveyDate = 0;
                  Parameters.data_.needsSurvey = true;
                  Parameters.data_.playTimeLeftTillSurvey = 5;
                  Parameters.data_.surveyGroup = "testing";
                  break;
               case KeyCodes.F9:
                  Parameters.drawProj_ = !Parameters.drawProj_;
                  break;
               case KeyCodes.F12:
                  this.addTextLine.dispatch(new AddTextLineVO(Parameters.SERVER_CHAT_NAME,"Server Chat"));
                  this.addTextLine.dispatch(new AddTextLineVO(Parameters.CLIENT_CHAT_NAME,"Client Chat"));
                  this.addTextLine.dispatch(new AddTextLineVO(Parameters.HELP_CHAT_NAME,"Help Chat"));
                  this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,"Error Chat"));
                  this.addTextLine.dispatch(new AddTextLineVO("#Enemy Name","Enemy Chat"));
                  this.addTextLine.dispatch(new AddTextLineVO("@Admin","Admin Chat"));
                  this.addTextLine.dispatch(new AddTextLineVO("Player","Player Chat"));
                  this.addTextLine.dispatch(new AddTextLineVO("Player","Tell from another Player",-1,0,"Crunchy"));
                  this.addTextLine.dispatch(new AddTextLineVO("Crunchy","Tell to another Player",-1,0,"Player"));
                  this.addTextLine.dispatch(new AddTextLineVO("Crunchy","Guild Chat",-1,0,Parameters.GUILD_CHAT_NAME));
            }
         }
         this.setPlayerMovement();
      }
      
      private function onKeyUp(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case Parameters.data_.moveUp:
               this.moveUp_ = false;
               break;
            case Parameters.data_.moveDown:
               this.moveDown_ = false;
               break;
            case Parameters.data_.moveLeft:
               this.moveLeft_ = false;
               break;
            case Parameters.data_.moveRight:
               this.moveRight_ = false;
               break;
            case Parameters.data_.rotateLeft:
               this.rotateLeft_ = false;
               break;
            case Parameters.data_.rotateRight:
               this.rotateRight_ = false;
               break;
            case Parameters.data_.useSpecial:
               if(this.specialKeyDown_)
               {
                  this.specialKeyDown_ = false;
                  this.gs_.map.player_.useAltWeapon(this.gs_.map.mouseX,this.gs_.map.mouseY,UseType.END_USE);
               }
         }
         this.setPlayerMovement();
      }
      
      private function setPlayerMovement() : void
      {
         var player:Player = this.gs_.map.player_;
         if(player != null)
         {
            if(this.enablePlayerInput_)
            {
               player.setRelativeMovement((!!this.rotateRight_?1:0) - (!!this.rotateLeft_?1:0),(!!this.moveRight_?1:0) - (!!this.moveLeft_?1:0),(!!this.moveDown_?1:0) - (!!this.moveUp_?1:0));
            }
            else
            {
               player.setRelativeMovement(0,0,0);
            }
         }
      }
      
      private function useItem(slotId:int) : void
      {
         if(this.tabStripModel.currentSelection == TabStripModel.BACKPACK)
         {
            slotId = slotId + GeneralConstants.NUM_INVENTORY_SLOTS;
         }
         GameServerConnection.instance.useItem_new(this.gs_.map.player_,slotId);
      }
      
      private function togglePerformanceStats() : void
      {
         if(this.gs_.contains(stats_))
         {
            this.gs_.removeChild(stats_);
            this.gs_.removeChild(this.gs_.gsc_.jitterWatcher_);
            this.gs_.gsc_.disableJitterWatcher();
         }
         else
         {
            this.gs_.addChild(stats_);
            this.gs_.gsc_.enableJitterWatcher();
            this.gs_.gsc_.jitterWatcher_.y = stats_.height;
            this.gs_.addChild(this.gs_.gsc_.jitterWatcher_);
         }
      }
      
      private function toggleScreenShotMode() : void
      {
         Parameters.screenShotMode_ = !Parameters.screenShotMode_;
         if(Parameters.screenShotMode_)
         {
            this.gs_.hudView.visible = false;
            this.setTextBoxVisibility.dispatch(false);
         }
         else
         {
            this.gs_.hudView.visible = true;
            this.setTextBoxVisibility.dispatch(true);
         }
      }
   }
}
