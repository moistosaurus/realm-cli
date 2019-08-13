package com.company.assembleegameclient.util
{
   import com.company.util.AssetLibrary;
   import com.company.util.PointUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.GradientType;
   import flash.display.Shader;
   import flash.display.Shape;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.filters.ShaderFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class TextureRedrawer
   {
      
      private static const BORDER:int = 4;
      
      private static const GRADIENT_MAX_SUB:uint = 2631720;
      
      private static const OUTLINE_FILTER:GlowFilter = new GlowFilter(0,0.8,1.4,1.4,255,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER:GlowFilter = new GlowFilter(0,0.3,12,12,2,BitmapFilterQuality.LOW,false,false);
      
      private static var cache_:Dictionary = new Dictionary();
      
      private static var faceCache_:Dictionary = new Dictionary();
      
      private static var gradient_:Shape = getGradient();
      
      private static var drawMatrix_:Matrix = getDrawMatrix();
      
      private static var tempMatrix_:Matrix = new Matrix();
      
      public static var sharedTexture_:BitmapData = null;
      
      private static var textureShaderEmbed_:Class = TextureRedrawer_textureShaderEmbed_;
      
      private static var textureShaderData_:ByteArray = new textureShaderEmbed_() as ByteArray;
      
      private static var colorTexture1:BitmapData = new BitmapData(1,1,false);
      
      private static var colorTexture2:BitmapData = new BitmapData(1,1,false);
       
      
      public function TextureRedrawer()
      {
         super();
      }
      
      public static function redraw(texture:BitmapData, size:int, includeBottom:Boolean, outlineColor:uint, glowColor:uint, useCaching:Boolean = true, scaleValue:int = 5) : BitmapData
      {
         var sizeCache:Dictionary = null;
         var newTexture:BitmapData = null;
         if(useCaching)
         {
            sizeCache = cache_[size];
            if(sizeCache == null)
            {
               sizeCache = new Dictionary();
               cache_[size] = sizeCache;
            }
            newTexture = sizeCache[texture];
            if(newTexture != null)
            {
               return newTexture;
            }
         }
         newTexture = resize(texture,null,size,includeBottom,0,0,scaleValue);
         newTexture = outlineGlow(newTexture,outlineColor,glowColor);
         if(useCaching)
         {
            sizeCache[texture] = newTexture;
         }
         return newTexture;
      }
      
      public static function resize(texture:BitmapData, mask:BitmapData, size:int, includeBottom:Boolean, texture1Id:int, texture2Id:int, scale:int = 5) : BitmapData
      {
         if(mask != null && (texture1Id != 0 || texture2Id != 0))
         {
            texture = retexture(texture,mask,texture1Id,texture2Id);
            size = size / 5;
         }
         var w:int = scale * (size / 100) * texture.width;
         var h:int = scale * (size / 100) * texture.height;
         var drawMatrix:Matrix = new Matrix();
         drawMatrix.scale(w / texture.width,h / texture.height);
         drawMatrix.translate(12,12);
         var newTexture:BitmapData = new BitmapData(w + 12 + 12,h + (!!includeBottom?12:1) + 12,true,0);
         newTexture.draw(texture,drawMatrix);
         return newTexture;
      }
      
      public static function outlineGlow(texture:BitmapData, outlineColor:uint, glowColor:uint) : BitmapData
      {
         var newTexture:BitmapData = texture.clone();
         tempMatrix_.identity();
         tempMatrix_.scale(texture.width / 256,texture.height / 256);
         newTexture.draw(gradient_,tempMatrix_,null,BlendMode.SUBTRACT);
         var origBitmap:Bitmap = new Bitmap(texture);
         newTexture.draw(origBitmap,null,null,BlendMode.ALPHA);
         OUTLINE_FILTER.color = outlineColor;
         newTexture.applyFilter(newTexture,newTexture.rect,PointUtil.ORIGIN,OUTLINE_FILTER);
         if(glowColor != 4294967295)
         {
            GLOW_FILTER.color = glowColor;
            newTexture.applyFilter(newTexture,newTexture.rect,PointUtil.ORIGIN,GLOW_FILTER);
         }
         return newTexture;
      }
      
      public static function redrawSolidSquare(color:uint, size:int) : BitmapData
      {
         var sizeCache:Dictionary = cache_[size];
         if(sizeCache == null)
         {
            sizeCache = new Dictionary();
            cache_[size] = sizeCache;
         }
         var newTexture:BitmapData = sizeCache[color];
         if(newTexture != null)
         {
            return newTexture;
         }
         newTexture = new BitmapData(size + 4 + 4,size + 4 + 4,true,0);
         newTexture.fillRect(new Rectangle(4,4,size,size),4278190080 | color);
         newTexture.applyFilter(newTexture,newTexture.rect,PointUtil.ORIGIN,OUTLINE_FILTER);
         sizeCache[color] = newTexture;
         return newTexture;
      }
      
      public static function clearCache() : void
      {
         var texture:BitmapData = null;
         var sizeCache:Dictionary = null;
         var shadeCache:Dictionary = null;
         for each(sizeCache in cache_)
         {
            for each(texture in sizeCache)
            {
               texture.dispose();
            }
         }
         cache_ = new Dictionary();
         for each(shadeCache in faceCache_)
         {
            for each(texture in shadeCache)
            {
               texture.dispose();
            }
         }
         faceCache_ = new Dictionary();
      }
      
      public static function redrawFace(texture:BitmapData, shade:Number) : BitmapData
      {
         if(shade == 1)
         {
            return texture;
         }
         var shadeCache:Dictionary = faceCache_[shade];
         if(shadeCache == null)
         {
            shadeCache = new Dictionary();
            faceCache_[shade] = shadeCache;
         }
         var newTexture:BitmapData = shadeCache[texture];
         if(newTexture != null)
         {
            return newTexture;
         }
         newTexture = texture.clone();
         newTexture.colorTransform(newTexture.rect,new ColorTransform(shade,shade,shade));
         shadeCache[texture] = newTexture;
         return newTexture;
      }
      
      private static function getTexture(texId:int, colorTexture:BitmapData) : BitmapData
      {
         var texture:BitmapData = null;
         var fileId:int = texId >> 24 & 255;
         var index:int = texId & 16777215;
         switch(fileId)
         {
            case 0:
               texture = colorTexture;
               break;
            case 1:
               colorTexture.setPixel(0,0,index);
               texture = colorTexture;
               break;
            case 4:
               texture = AssetLibrary.getImageFromSet("textile4x4",index);
               break;
            case 5:
               texture = AssetLibrary.getImageFromSet("textile5x5",index);
               break;
            case 9:
               texture = AssetLibrary.getImageFromSet("textile9x9",index);
               break;
            case 10:
               texture = AssetLibrary.getImageFromSet("textile10x10",index);
               break;
            case 255:
               texture = sharedTexture_;
               break;
            default:
               trace("Unrecognized fileId: " + fileId);
               texture = colorTexture;
         }
         return texture;
      }
      
      private static function retexture(texture:BitmapData, mask:BitmapData, tex1Id:int, tex2Id:int) : BitmapData
      {
         var drawMatrix:Matrix = new Matrix();
         drawMatrix.scale(5,5);
         var newTexture:BitmapData = new BitmapData(texture.width * 5,texture.height * 5,true,0);
         newTexture.draw(texture,drawMatrix);
         var texture1:BitmapData = getTexture(tex1Id,colorTexture1);
         var texture2:BitmapData = getTexture(tex2Id,colorTexture2);
         var shader:Shader = new Shader(textureShaderData_);
         shader.data.src.input = newTexture;
         shader.data.mask.input = mask;
         shader.data.texture1.input = texture1;
         shader.data.texture2.input = texture2;
         shader.data.texture1Size.value = [tex1Id == 0?0:texture1.width];
         shader.data.texture2Size.value = [tex2Id == 0?0:texture2.width];
         newTexture.applyFilter(newTexture,newTexture.rect,PointUtil.ORIGIN,new ShaderFilter(shader));
         return newTexture;
      }
      
      private static function getGradient() : Shape
      {
         var gradient:Shape = new Shape();
         var gm:Matrix = new Matrix();
         gm.createGradientBox(256,256,Math.PI / 2,0,0);
         gradient.graphics.beginGradientFill(GradientType.LINEAR,[0,GRADIENT_MAX_SUB],[1,1],[127,255],gm);
         gradient.graphics.drawRect(0,0,256,256);
         gradient.graphics.endFill();
         return gradient;
      }
      
      private static function getDrawMatrix() : Matrix
      {
         var m:Matrix = new Matrix();
         m.scale(8,8);
         m.translate(BORDER,BORDER);
         return m;
      }
   }
}
