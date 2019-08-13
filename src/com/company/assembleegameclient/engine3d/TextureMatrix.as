package com.company.assembleegameclient.engine3d
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class TextureMatrix
   {
       
      
      public var texture_:BitmapData = null;
      
      public var tToS_:Matrix;
      
      private var uvMatrix_:Matrix = null;
      
      private var tempMatrix_:Matrix;
      
      public function TextureMatrix(texture:BitmapData, uvt:Vector.<Number>)
      {
         this.tToS_ = new Matrix();
         this.tempMatrix_ = new Matrix();
         super();
         this.texture_ = texture;
         this.calculateUVMatrix(uvt);
      }
      
      public function setUVT(uvt:Vector.<Number>) : void
      {
         this.calculateUVMatrix(uvt);
      }
      
      public function setVOut(vout:Vector.<Number>) : void
      {
         this.calculateTextureMatrix(vout);
      }
      
      public function calculateTextureMatrix(vout:Vector.<Number>) : void
      {
         this.tToS_.a = this.uvMatrix_.a;
         this.tToS_.b = this.uvMatrix_.b;
         this.tToS_.c = this.uvMatrix_.c;
         this.tToS_.d = this.uvMatrix_.d;
         this.tToS_.tx = this.uvMatrix_.tx;
         this.tToS_.ty = this.uvMatrix_.ty;
         var li:int = vout.length - 2;
         var liplus1:int = li + 1;
         this.tempMatrix_.a = vout[2] - vout[0];
         this.tempMatrix_.b = vout[3] - vout[1];
         this.tempMatrix_.c = vout[li] - vout[0];
         this.tempMatrix_.d = vout[liplus1] - vout[1];
         this.tempMatrix_.tx = vout[0];
         this.tempMatrix_.ty = vout[1];
         this.tToS_.concat(this.tempMatrix_);
      }
      
      public function calculateUVMatrix(uvt:Vector.<Number>) : void
      {
         if(this.texture_ == null)
         {
            this.uvMatrix_ = null;
            return;
         }
         var li:int = uvt.length - 3;
         var uv0x:Number = uvt[0] * this.texture_.width;
         var uv0y:Number = uvt[1] * this.texture_.height;
         var uv1x:Number = uvt[3] * this.texture_.width;
         var uv1y:Number = uvt[4] * this.texture_.height;
         var uv2x:Number = uvt[li] * this.texture_.width;
         var uv2y:Number = uvt[li + 1] * this.texture_.height;
         var uv_xx:Number = uv1x - uv0x;
         var uv_xy:Number = uv1y - uv0y;
         var uv_yx:Number = uv2x - uv0x;
         var uv_yy:Number = uv2y - uv0y;
         this.uvMatrix_ = new Matrix(uv_xx,uv_xy,uv_yx,uv_yy,uv0x,uv0y);
         this.uvMatrix_.invert();
      }
   }
}
