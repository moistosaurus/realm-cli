package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   
   public class Particle extends BasicObject
   {
       
      
      public var size_:int;
      
      public var color_:uint;
      
      protected var bitmapFill_:GraphicsBitmapFill;
      
      protected var path_:GraphicsPath;
      
      protected var vS_:Vector.<Number>;
      
      protected var fillMatrix_:Matrix;
      
      public function Particle(color:uint, z:Number, size:int)
      {
         this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
         this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
         this.vS_ = new Vector.<Number>();
         this.fillMatrix_ = new Matrix();
         super();
         objectId_ = getNextFakeObjectId();
         this.setZ(z);
         this.setColor(color);
         this.setSize(size);
      }
      
      public function moveTo(x:Number, y:Number) : Boolean
      {
         var square:Square = null;
         square = map_.getSquare(x,y);
         if(square == null)
         {
            return false;
         }
         x_ = x;
         y_ = y;
         square_ = square;
         return true;
      }
      
      public function setColor(color:uint) : void
      {
         this.color_ = color;
      }
      
      public function setZ(z:Number) : void
      {
         z_ = z;
      }
      
      public function setSize(size:int) : void
      {
         this.size_ = size / 100 * 5;
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var texture:BitmapData = TextureRedrawer.redrawSolidSquare(this.color_,this.size_);
         var w:int = texture.width;
         var h:int = texture.height;
         this.vS_.length = 0;
         this.vS_.push(posS_[3] - w / 2,posS_[4] - h / 2,posS_[3] + w / 2,posS_[4] - h / 2,posS_[3] + w / 2,posS_[4] + h / 2,posS_[3] - w / 2,posS_[4] + h / 2);
         this.path_.data = this.vS_;
         this.bitmapFill_.bitmapData = texture;
         this.fillMatrix_.identity();
         this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
         this.bitmapFill_.matrix = this.fillMatrix_;
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.path_);
         graphicsData.push(GraphicsUtil.END_FILL);
      }
   }
}
