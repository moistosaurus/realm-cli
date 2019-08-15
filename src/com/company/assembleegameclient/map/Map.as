package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.background.Background;
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.map.mapoverlay.MapOverlay;
   import com.company.assembleegameclient.map.partyoverlay.PartyOverlay;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Party;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.ConditionEffect;
   import flash.display.Graphics;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.game.logging.RollingMeanLoopMonitor;
   
   public class Map extends Sprite
   {
      
      public static const NEXUS:String = "Nexus";
      
      private static const VISIBLE_SORT_FIELDS:Array = ["sortVal_","objectId_"];
      
      private static const VISIBLE_SORT_PARAMS:Array = [Array.NUMERIC,Array.NUMERIC];
      
      protected static const BLIND_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.05,0.05,0.05,0,0,0.05,0.05,0.05,0,0,0.05,0.05,0.05,0,0,0.05,0.05,0.05,1,0]);
      
      protected static var BREATH_CT:ColorTransform = new ColorTransform(255 / 255,55 / 255,0 / 255,0);
       
      
      private var loopMonitor:RollingMeanLoopMonitor;
      
      public var gs_:GameSprite;
      
      public var width_:int;
      
      public var height_:int;
      
      public var name_:String;
      
      public var back_:int;
      
      public var allowPlayerTeleport_:Boolean;
      
      public var showDisplays_:Boolean;
      
      public var background_:Background = null;
      
      public var map_:Sprite;
      
      public var hurtOverlay_:HurtOverlay = null;
      
      public var gradientOverlay_:GradientOverlay = null;
      
      public var mapOverlay_:MapOverlay = null;
      
      public var partyOverlay_:PartyOverlay = null;
      
      public var squareList_:Vector.<Square>;
      
      public var squares_:Vector.<Square>;
      
      public var goDict_:Dictionary;
      
      public var boDict_:Dictionary;
      
      public var merchLookup_:Object;
      
      public var player_:Player = null;
      
      public var party_:Party = null;
      
      public var quest_:Quest = null;
      
      private var inUpdate_:Boolean = false;
      
      private var objsToAdd_:Vector.<BasicObject>;
      
      private var idsToRemove_:Vector.<int>;
      
      private var graphicsData_:Vector.<IGraphicsData>;
      
      public var visible_:Array;
      
      public var visibleUnder_:Array;
      
      public var visibleSquares_:Vector.<Square>;
      
      public var topSquares_:Vector.<Square>;
      
      public function Map(gs:GameSprite)
      {
         this.map_ = new Sprite();
         this.squareList_ = new Vector.<Square>();
         this.squares_ = new Vector.<Square>();
         this.goDict_ = new Dictionary();
         this.boDict_ = new Dictionary();
         this.merchLookup_ = new Object();
         this.objsToAdd_ = new Vector.<BasicObject>();
         this.idsToRemove_ = new Vector.<int>();
         this.graphicsData_ = new Vector.<IGraphicsData>();
         this.visible_ = new Array();
         this.visibleUnder_ = new Array();
         this.visibleSquares_ = new Vector.<Square>();
         this.topSquares_ = new Vector.<Square>();
         super();
         this.gs_ = gs;
         this.hurtOverlay_ = new HurtOverlay();
         this.gradientOverlay_ = new GradientOverlay();
         this.mapOverlay_ = new MapOverlay();
         this.partyOverlay_ = new PartyOverlay(this);
         this.party_ = new Party(this);
         this.quest_ = new Quest(this);
         this.loopMonitor = StaticInjectorContext.getInjector().getInstance(RollingMeanLoopMonitor);
      }
      
      public function setProps(width:int, height:int, name:String, back:int, allowPlayerTeleport:Boolean, showDisplays:Boolean) : void
      {
         this.width_ = width;
         this.height_ = height;
         this.name_ = name;
         this.back_ = back;
         this.allowPlayerTeleport_ = allowPlayerTeleport;
         this.showDisplays_ = showDisplays;
      }
      
      public function initialize() : void
      {
         this.squares_.length = this.width_ * this.height_;
         this.background_ = Background.getBackground(this.back_);
         if(this.background_ != null)
         {
            addChild(this.background_);
         }
         addChild(this.map_);
         addChild(this.hurtOverlay_);
         addChild(this.gradientOverlay_);
         addChild(this.mapOverlay_);
         addChild(this.partyOverlay_);
      }
      
      public function dispose() : void
      {
         var square:Square = null;
         var go:GameObject = null;
         var bo:BasicObject = null;
         this.gs_ = null;
         this.background_ = null;
         this.map_ = null;
         this.hurtOverlay_ = null;
         this.gradientOverlay_ = null;
         this.mapOverlay_ = null;
         this.partyOverlay_ = null;
         for each(square in this.squareList_)
         {
            square.dispose();
         }
         this.squareList_.length = 0;
         this.squareList_ = null;
         this.squares_.length = 0;
         this.squares_ = null;
         for each(go in this.goDict_)
         {
            go.dispose();
         }
         this.goDict_ = null;
         for each(bo in this.boDict_)
         {
            bo.dispose();
         }
         this.boDict_ = null;
         this.merchLookup_ = null;
         this.player_ = null;
         this.party_ = null;
         this.quest_ = null;
         this.objsToAdd_ = null;
         this.idsToRemove_ = null;
      }
      
      public function update(time:int, dt:int) : void
      {
         var bo:BasicObject = null;
         var objId:int = 0;
         this.inUpdate_ = true;
         for each(bo in this.goDict_)
         {
            if(!bo.update(time,dt))
            {
               this.idsToRemove_.push(bo.objectId_);
            }
         }
         for each(bo in this.boDict_)
         {
            if(!bo.update(time,dt))
            {
               this.idsToRemove_.push(bo.objectId_);
            }
         }
         this.inUpdate_ = false;
         for each(bo in this.objsToAdd_)
         {
            this.internalAddObj(bo);
         }
         this.objsToAdd_.length = 0;
         for each(objId in this.idsToRemove_)
         {
            this.internalRemoveObj(objId);
         }
         this.idsToRemove_.length = 0;
         this.party_.update(time,dt);
      }
      
      public function pSTopW(xS:Number, yS:Number) : Point
      {
         var square:Square = null;
         var p:Point = null;
         for each(square in this.visibleSquares_)
         {
            if(square.faces_.length != 0 && square.faces_[0].face_.contains(xS,yS))
            {
               return new Point(square.center_.x,square.center_.y);
            }
         }
         return null;
      }
      
      public function setGroundTile(x:int, y:int, tileType:uint) : void
      {
         var yi:int = 0;
         var ind:int = 0;
         var n:Square = null;
         var square:Square = this.getSquare(x,y);
         square.setTileType(tileType);
         var xend:int = x < this.width_ - 1?int(x + 1):int(x);
         var yend:int = y < this.height_ - 1?int(y + 1):int(y);
         for(var xi:int = x > 0?int(x - 1):int(x); xi <= xend; xi++)
         {
            for(yi = y > 0?int(y - 1):int(y); yi <= yend; yi++)
            {
               ind = xi + yi * this.width_;
               n = this.squares_[ind];
               if(n != null && (n.props_.hasEdge_ || n.tileType_ != tileType))
               {
                  n.faces_.length = 0;
               }
            }
         }
      }
      
      public function addObj(bo:BasicObject, posX:Number, posY:Number) : void
      {
         bo.x_ = posX;
         bo.y_ = posY;
         if(this.inUpdate_)
         {
            this.objsToAdd_.push(bo);
         }
         else
         {
            this.internalAddObj(bo);
         }
      }
      
      public function internalAddObj(bo:BasicObject) : void
      {
         if(!bo.addTo(this,bo.x_,bo.y_))
         {
            trace("ERROR: adding: " + bo);
            return;
         }
         var dict:Dictionary = bo is GameObject?this.goDict_:this.boDict_;
         if(dict[bo.objectId_] != null)
         {
            trace("ERROR: duplicate add: " + bo + " would replace: " + dict[bo.objectId_]);
            return;
         }
         dict[bo.objectId_] = bo;
      }
      
      public function removeObj(objectId:int) : void
      {
         if(this.inUpdate_)
         {
            this.idsToRemove_.push(objectId);
         }
         else
         {
            this.internalRemoveObj(objectId);
         }
      }
      
      public function internalRemoveObj(objectId:int) : void
      {
         var dict:Dictionary = this.goDict_;
         var bo:BasicObject = dict[objectId];
         if(bo == null)
         {
            dict = this.boDict_;
            bo = dict[objectId];
            if(bo == null)
            {
               return;
            }
         }
         bo.removeFromMap();
         delete dict[objectId];
      }
      
      public function getSquare(posX:Number, posY:Number) : Square
      {
         if(posX < 0 || posX >= this.width_ || posY < 0 || posY >= this.height_)
         {
            return null;
         }
         var ind:int = int(posX) + int(posY) * this.width_;
         var square:Square = this.squares_[ind];
         if(square == null)
         {
            square = new Square(this,int(posX),int(posY));
            this.squares_[ind] = square;
            this.squareList_.push(square);
         }
         return square;
      }
      
      public function lookupSquare(x:int, y:int) : Square
      {
         if(x < 0 || x >= this.width_ || y < 0 || y >= this.height_)
         {
            return null;
         }
         return this.squares_[x + y * this.width_];
      }
      
      public function draw(camera:Camera, time:int) : void
      {
         var square:Square = null;
         var go:GameObject = null;
         var bo:BasicObject = null;
         var yi:int = 0;
         var dX:Number = NaN;
         var dY:Number = NaN;
         var distSq:Number = NaN;
         var b:Number = NaN;
         var t:Number = NaN;
         var d:Number = NaN;
         var screenRect:Rectangle = camera.clipRect_;
         x = -screenRect.x;
         y = -screenRect.y;
         var distW:Number = (-screenRect.y - screenRect.height / 2) / 50;
         var screenCenterW:Point = new Point(camera.x_ + distW * Math.cos(camera.angleRad_ - Math.PI / 2),camera.y_ + distW * Math.sin(camera.angleRad_ - Math.PI / 2));
         if(this.background_ != null)
         {
            this.background_.draw(camera,time);
         }
         this.visible_.length = 0;
         this.visibleUnder_.length = 0;
         this.visibleSquares_.length = 0;
         this.topSquares_.length = 0;
         var delta:int = camera.maxDist_;
         var xStart:int = Math.max(0,screenCenterW.x - delta);
         var xEnd:int = Math.min(this.width_ - 1,screenCenterW.x + delta);
         var yStart:int = Math.max(0,screenCenterW.y - delta);
         var yEnd:int = Math.min(this.height_ - 1,screenCenterW.y + delta);
         this.graphicsData_.length = 0;
         for(var xi:int = xStart; xi <= xEnd; xi++)
         {
            for(yi = yStart; yi <= yEnd; yi++)
            {
               square = this.squares_[xi + yi * this.width_];
               if(square != null)
               {
                  dX = screenCenterW.x - square.center_.x;
                  dY = screenCenterW.y - square.center_.y;
                  distSq = dX * dX + dY * dY;
                  if(distSq <= camera.maxDistSq_)
                  {
                     square.lastVisible_ = time;
                     square.draw(this.graphicsData_,camera,time);
                     this.visibleSquares_.push(square);
                     if(square.topFace_ != null)
                     {
                        this.topSquares_.push(square);
                     }
                  }
               }
            }
         }
         for each(go in this.goDict_)
         {
            go.drawn_ = false;
            if(!go.dead_)
            {
               square = go.square_;
               if(!(square == null || square.lastVisible_ != time))
               {
                  go.drawn_ = true;
                  go.computeSortVal(camera);
                  if(go.props_.drawUnder_)
                  {
                     if(go.props_.drawOnGround_)
                     {
                        go.draw(this.graphicsData_,camera,time);
                     }
                     else
                     {
                        this.visibleUnder_.push(go);
                     }
                  }
                  else
                  {
                     this.visible_.push(go);
                  }
               }
            }
         }
         for each(bo in this.boDict_)
         {
            bo.drawn_ = false;
            square = bo.square_;
            if(!(square == null || square.lastVisible_ != time))
            {
               bo.drawn_ = true;
               bo.computeSortVal(camera);
               this.visible_.push(bo);
            }
         }
         if(this.visibleUnder_.length > 0)
         {
            this.visibleUnder_.sortOn(VISIBLE_SORT_FIELDS,VISIBLE_SORT_PARAMS);
            for each(bo in this.visibleUnder_)
            {
               bo.draw(this.graphicsData_,camera,time);
            }
         }
         this.visible_.sortOn(VISIBLE_SORT_FIELDS,VISIBLE_SORT_PARAMS);
         if(Parameters.data_.drawShadows)
         {
            for each(bo in this.visible_)
            {
               if(bo.hasShadow_)
               {
                  bo.drawShadow(this.graphicsData_,camera,time);
               }
            }
         }
         for each(bo in this.visible_)
         {
            bo.draw(this.graphicsData_,camera,time);
         }
         if(this.topSquares_.length > 0)
         {
            for each(square in this.topSquares_)
            {
               square.drawTop(this.graphicsData_,camera,time);
            }
         }
         if(this.player_ != null && this.player_.breath_ >= 0 && this.player_.breath_ < Parameters.BREATH_THRESH)
         {
            b = (Parameters.BREATH_THRESH - this.player_.breath_) / Parameters.BREATH_THRESH;
            t = Math.abs(Math.sin(time / 300)) * 0.75;
            BREATH_CT.alphaMultiplier = b * t;
            this.hurtOverlay_.transform.colorTransform = BREATH_CT;
            this.hurtOverlay_.visible = true;
            this.hurtOverlay_.x = screenRect.left;
            this.hurtOverlay_.y = screenRect.top;
         }
         else
         {
            this.hurtOverlay_.visible = false;
         }
         if(this.player_ != null)
         {
            this.gradientOverlay_.visible = true;
            this.gradientOverlay_.x = screenRect.right - 10;
            this.gradientOverlay_.y = screenRect.top;
         }
         else
         {
            this.gradientOverlay_.visible = false;
         }
         var g:Graphics = this.map_.graphics;
         g.clear();
         g.drawGraphicsData(this.graphicsData_);
         this.map_.filters.length = 0;
         if(this.player_ != null && (this.player_.condition_ & ConditionEffect.MAP_FILTER_BITMASK) != 0)
         {
            var filters:Array = [];
            if(this.player_.isDrunk())
            {
               d = 20 + 10 * Math.sin(time / 1000);
               filters.push(new BlurFilter(d,d));
            }
            if(this.player_.isBlind())
            {
               filters.push(BLIND_FILTER);
            }
            this.map_.filters = filters;
         }
         else if(this.map_.filters.length > 0)
         {
            this.map_.filters = [];
         }
         this.mapOverlay_.draw(camera,time);
         this.partyOverlay_.draw(camera,time);
      }
   }
}
