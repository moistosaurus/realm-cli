package com.company.assembleegameclient.engine3d
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.util.Trig;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsEndFill;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   
   public class Point3D
   {
      
      private static const commands_:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];
      
      private static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
       
      
      public var size_:Number;
      
      public var posS_:Vector3D;
      
      private const data_:Vector.<Number> = new Vector.<Number>();
      
      private const path_:GraphicsPath = new GraphicsPath(commands_,data_);
      
      private const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,new Matrix(),false,false);
      
      private const solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
      
      public function Point3D(size:Number)
      {
         super();
         this.size_ = size;
      }
      
      public function setSize(size:Number) : void
      {
         this.size_ = size;
      }
      
      public function draw(graphicsData:Vector.<IGraphicsData>, posL:Vector3D, angle:Number, lToS:Matrix3D, camera:Camera, bitmapData:BitmapData, color:uint = 0) : void
      {
         var ca:Number = NaN;
         var sa:Number = NaN;
         var m:Matrix = null;
         this.posS_ = Utils3D.projectVector(lToS,posL);
         if(this.posS_.w < 0)
         {
            return;
         }
         var o:Number = this.posS_.w * Math.sin(camera.pp_.fieldOfView / 2 * Trig.toRadians);
         var s:Number = this.size_ / o;
         this.data_.length = 0;
         if(angle == 0)
         {
            this.data_.push(this.posS_.x - s,this.posS_.y - s,this.posS_.x + s,this.posS_.y - s,this.posS_.x + s,this.posS_.y + s,this.posS_.x - s,this.posS_.y + s);
         }
         else
         {
            ca = Math.cos(angle);
            sa = Math.sin(angle);
            this.data_.push(this.posS_.x + (ca * -s + sa * -s),this.posS_.y + (sa * -s - ca * -s),this.posS_.x + (ca * s + sa * -s),this.posS_.y + (sa * s - ca * -s),this.posS_.x + (ca * s + sa * s),this.posS_.y + (sa * s - ca * s),this.posS_.x + (ca * -s + sa * s),this.posS_.y + (sa * -s - ca * s));
         }
         if(bitmapData != null)
         {
            this.bitmapFill_.bitmapData = bitmapData;
            m = this.bitmapFill_.matrix;
            m.identity();
            m.scale(2 * s / bitmapData.width,2 * s / bitmapData.height);
            m.translate(-s,-s);
            m.rotate(angle);
            m.translate(this.posS_.x,this.posS_.y);
            graphicsData.push(this.bitmapFill_);
         }
         else
         {
            this.solidFill_.color = color;
            graphicsData.push(this.solidFill_);
         }
         graphicsData.push(this.path_);
         graphicsData.push(END_FILL);
      }
   }
}
