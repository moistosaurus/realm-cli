package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.ObjectFace3D;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   
   public class ConnectedWall extends ConnectedObject
   {
       
      
      protected var objectXML_:XML;
      
      protected var bI_:Number = 0.5;
      
      protected var tI_:Number = 0.25;
      
      protected var h_:Number = 1.0;
      
      protected var wallRepeat_:Boolean;
      
      protected var topRepeat_:Boolean;
      
      public function ConnectedWall(objectXML:XML)
      {
         super(objectXML);
         this.objectXML_ = objectXML;
         if(objectXML.hasOwnProperty("BaseIndent"))
         {
            this.bI_ = 0.5 - Number(objectXML.BaseIndent);
         }
         if(objectXML.hasOwnProperty("TopIndent"))
         {
            this.tI_ = 0.5 - Number(objectXML.TopIndent);
         }
         if(objectXML.hasOwnProperty("Height"))
         {
            this.h_ = Number(objectXML.Height);
         }
         this.wallRepeat_ = !objectXML.hasOwnProperty("NoWallTextureRepeat");
         this.topRepeat_ = !objectXML.hasOwnProperty("NoTopTextureRepeat");
      }
      
      override protected function buildDot() : void
      {
         var v0:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
         var v1:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var v2:Vector3D = new Vector3D(this.bI_,this.bI_,0);
         var v3:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var v4:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
         var v5:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var v6:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
         var v7:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         this.addQuad(v5,v4,v0,v1,texture_,true,true);
         this.addQuad(v6,v5,v1,v2,texture_,true,true);
         this.addQuad(v4,v7,v3,v0,texture_,true,true);
         this.addQuad(v7,v6,v2,v3,texture_,true,true);
         var texture:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("DotTexture"))
         {
            texture = AssetLibrary.getImageFromSet(String(this.objectXML_.DotTexture.File),int(this.objectXML_.DotTexture.Index));
         }
         this.addTop([v4,v5,v6,v7],new <Number>[0.25,0.25,0.75,0.25,0.25,0.75],texture);
      }
      
      override protected function buildShortLine() : void
      {
         var v0:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var v1:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var v2:Vector3D = new Vector3D(this.bI_,this.bI_,0);
         var v3:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var v4:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var v5:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var v6:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
         var v7:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         this.addQuad(v6,v5,v1,v2,texture_,true,false);
         this.addQuad(v4,v7,v3,v0,texture_,false,true);
         this.addQuad(v7,v6,v2,v3,texture_,true,true);
         var texture:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("ShortLineTexture"))
         {
            texture = AssetLibrary.getImageFromSet(String(this.objectXML_.ShortLineTexture.File),int(this.objectXML_.ShortLineTexture.Index));
         }
         this.addTop([v4,v5,v6,v7],new <Number>[0.25,0,0.75,0,0.25,0.75],texture);
      }
      
      override protected function buildL() : void
      {
         var v0:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var v1:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var v2:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var v3:Vector3D = new Vector3D(0.5,-this.bI_,0);
         var v4:Vector3D = new Vector3D(0.5,this.bI_,0);
         var v5:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var v6:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var v7:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var v8:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var v9:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
         var va:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
         var vb:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         this.addBit(v8,v7,v1,v2,texture_,N2,true);
         this.addBit(v9,v8,v2,v3,texture_,N2,false);
         this.addQuad(vb,va,v4,v5,texture_,true,false);
         this.addQuad(v6,vb,v5,v0,texture_,false,true);
         var texture:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("LTexture"))
         {
            texture = AssetLibrary.getImageFromSet(String(this.objectXML_.LTexture.File),int(this.objectXML_.LTexture.Index));
         }
         this.addTop([v6,v7,v8,v9,va,vb],new <Number>[0.25,0,0.75,0,0.25,0.75],texture);
      }
      
      override protected function buildLine() : void
      {
         var v0:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var v1:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var v2:Vector3D = new Vector3D(this.bI_,0.5,0);
         var v3:Vector3D = new Vector3D(-this.bI_,0.5,0);
         var v4:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var v5:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var v6:Vector3D = new Vector3D(this.tI_,0.5,this.h_);
         var v7:Vector3D = new Vector3D(-this.tI_,0.5,this.h_);
         this.addQuad(v6,v5,v1,v2,texture_,false,false);
         this.addQuad(v4,v7,v3,v0,texture_,false,false);
         var texture:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("LineTexture"))
         {
            texture = AssetLibrary.getImageFromSet(String(this.objectXML_.LineTexture.File),int(this.objectXML_.LineTexture.Index));
         }
         this.addTop([v4,v5,v6,v7],new <Number>[0.25,0,0.75,0,0.25,1],texture);
      }
      
      override protected function buildT() : void
      {
         var v0:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var v1:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var v2:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var v3:Vector3D = new Vector3D(0.5,-this.bI_,0);
         var v4:Vector3D = new Vector3D(0.5,this.bI_,0);
         var v5:Vector3D = new Vector3D(-0.5,this.bI_,0);
         var v6:Vector3D = new Vector3D(-0.5,-this.bI_,0);
         var v7:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
         var v8:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var v9:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var va:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var vb:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
         var vc:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
         var vd:Vector3D = new Vector3D(-0.5,this.tI_,this.h_);
         var ve:Vector3D = new Vector3D(-0.5,-this.tI_,this.h_);
         var vf:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
         this.addBit(va,v9,v1,v2,texture_,N2,true);
         this.addBit(vb,va,v2,v3,texture_,N2,false);
         this.addQuad(vd,vc,v4,v5,texture_,false,false);
         this.addBit(vf,ve,v6,v7,texture_,N0,true);
         this.addBit(v8,vf,v7,v0,texture_,N0,false);
         var texture:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("TTexture"))
         {
            texture = AssetLibrary.getImageFromSet(String(this.objectXML_.TTexture.File),int(this.objectXML_.TTexture.Index));
         }
         this.addTop([v8,v9,va,vb,vc,vd,ve,vf],new <Number>[0.25,0,0.75,0,0.25,0.25],texture);
      }
      
      override protected function buildCross() : void
      {
         var vb0:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var vb1:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var vb2:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var vb3:Vector3D = new Vector3D(0.5,-this.bI_,0);
         var vb4:Vector3D = new Vector3D(0.5,this.bI_,0);
         var vb5:Vector3D = new Vector3D(this.bI_,this.bI_,0);
         var vb6:Vector3D = new Vector3D(this.bI_,0.5,0);
         var vb7:Vector3D = new Vector3D(-this.bI_,0.5,0);
         var vb8:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var vb9:Vector3D = new Vector3D(-0.5,this.bI_,0);
         var vba:Vector3D = new Vector3D(-0.5,-this.bI_,0);
         var vbb:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
         var vt0:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var vt1:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var vt2:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var vt3:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
         var vt4:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
         var vt5:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
         var vt6:Vector3D = new Vector3D(this.tI_,0.5,this.h_);
         var vt7:Vector3D = new Vector3D(-this.tI_,0.5,this.h_);
         var vt8:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         var vt9:Vector3D = new Vector3D(-0.5,this.tI_,this.h_);
         var vta:Vector3D = new Vector3D(-0.5,-this.tI_,this.h_);
         var vtb:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
         this.addBit(vt2,vt1,vb1,vb2,texture_,N2,true);
         this.addBit(vt3,vt2,vb2,vb3,texture_,N2,false);
         this.addBit(vt5,vt4,vb4,vb5,texture_,N4,true);
         this.addBit(vt6,vt5,vb5,vb6,texture_,N4,false);
         this.addBit(vt8,vt7,vb7,vb8,texture_,N6,true);
         this.addBit(vt9,vt8,vb8,vb9,texture_,N6,false);
         this.addBit(vtb,vta,vba,vbb,texture_,N0,true);
         this.addBit(vt0,vtb,vbb,vb0,texture_,N0,false);
         var texture:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("CrossTexture"))
         {
            texture = AssetLibrary.getImageFromSet(String(this.objectXML_.CrossTexture.File),int(this.objectXML_.CrossTexture.Index));
         }
         this.addTop([vt0,vt1,vt2,vt3,vt4,vt5,vt6,vt7,vt8,vt9,vta,vtb],new <Number>[0.25,0,0.75,0,0.25,0.25],texture);
      }
      
      protected function addQuad(v0:Vector3D, v1:Vector3D, v2:Vector3D, v3:Vector3D, texture:BitmapData, leftIndent:Boolean, rightIndent:Boolean) : void
      {
         var offset:int = obj3D_.vL_.length / 3;
         obj3D_.vL_.push(v0.x,v0.y,v0.z,v1.x,v1.y,v1.z,v2.x,v2.y,v2.z,v3.x,v3.y,v3.z);
         var n:Number = !!leftIndent?Number(-(this.bI_ - this.tI_) / (1 - (this.bI_ - this.tI_) - (!!rightIndent?this.bI_ - this.tI_:0))):Number(0);
         obj3D_.uvts_.push(0,0,0,1,0,0,1,1,0,n,1,0);
         var face:ObjectFace3D = new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 2,offset + 3]);
         face.texture_ = texture;
         face.bitmapFill_.repeat = this.wallRepeat_;
         obj3D_.faces_.push(face);
      }
      
      protected function addBit(v0:Vector3D, v1:Vector3D, v2:Vector3D, v3:Vector3D, texture:BitmapData, normalL:Vector3D, indent:Boolean) : void
      {
         var offset:int = obj3D_.vL_.length / 3;
         obj3D_.vL_.push(v0.x,v0.y,v0.z,v1.x,v1.y,v1.z,v2.x,v2.y,v2.z,v3.x,v3.y,v3.z);
         if(indent)
         {
            obj3D_.uvts_.push(-0.5 + this.tI_,0,0,0,0,0,0,0,0,-0.5 + this.bI_,1,0);
         }
         else
         {
            obj3D_.uvts_.push(1,0,0,1.5 - this.tI_,0,0,0,0,0,1,1,0);
         }
         var face:ObjectFace3D = new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 2,offset + 3]);
         face.texture_ = texture;
         face.bitmapFill_.repeat = this.wallRepeat_;
         face.normalL_ = normalL;
         obj3D_.faces_.push(face);
      }
      
      protected function addTop(verts:Array, uvs:Vector.<Number>, texture:BitmapData) : void
      {
         var offset:int = obj3D_.vL_.length / 3;
         var indices:Vector.<int> = new Vector.<int>();
         for(var i:uint = 0; i < verts.length; i++)
         {
            obj3D_.vL_.push(verts[i].x,verts[i].y,verts[i].z);
            indices.push(offset + i);
            if(i == 0)
            {
               obj3D_.uvts_.push(uvs[0],uvs[1],0);
            }
            else if(i == 1)
            {
               obj3D_.uvts_.push(uvs[2],uvs[3],0);
            }
            else if(i == verts.length - 1)
            {
               obj3D_.uvts_.push(uvs[4],uvs[5],0);
            }
            else
            {
               obj3D_.uvts_.push(0,0,0);
            }
         }
         var face:ObjectFace3D = new ObjectFace3D(obj3D_,indices);
         face.texture_ = texture;
         face.bitmapFill_.repeat = this.topRepeat_;
         obj3D_.faces_.push(face);
      }
   }
}
