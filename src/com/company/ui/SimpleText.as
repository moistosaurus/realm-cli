package com.company.ui
{
import com.company.ui.fonts.BaseSimpleText_MyriadPro;

import flash.events.Event;
import flash.text.Font;
import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class SimpleText extends TextField
   {
      public static const MyriadPro:Class = BaseSimpleText_MyriadPro;
      
      public var inputWidth_:int;
      
      public var inputHeight_:int;
      
      public var actualWidth_:int;
      
      public var actualHeight_:int;
      
      public function SimpleText(textSize:int, color:uint, settable:Boolean = false, widthParam:int = 0, heightParam:int = 0)
      {
         super();
         this.inputWidth_ = widthParam;
         if(this.inputWidth_ != 0)
         {
            width = widthParam;
         }
         this.inputHeight_ = heightParam;
         if(this.inputHeight_ != 0)
         {
            height = heightParam;
         }
         Font.registerFont(MyriadPro);
         var font:Font = new MyriadPro();
         var format:TextFormat = this.defaultTextFormat;
         format.font = font.fontName;
         format.bold = false;
         format.size = textSize;
         format.color = color;
         defaultTextFormat = format;
         if(settable)
         {
            selectable = true;
            mouseEnabled = true;
            type = TextFieldType.INPUT;
            border = true;
            borderColor = color;
            addEventListener(Event.CHANGE,this.onChange);
         }
         else
         {
            selectable = false;
            mouseEnabled = false;
         }
      }
      
      public function setSize(size:int) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.size = size;
         this.applyFormat(format);
         return this;
      }
      
      public function setColor(color:uint) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.color = color;
         this.applyFormat(format);
         return this;
      }
      
      public function setBold(bold:Boolean) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.bold = bold;
         this.applyFormat(format);
         return this;
      }
      
      public function setAlignment(alignment:String) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.align = alignment;
         this.applyFormat(format);
         return this;
      }
      
      public function setText(text:String) : SimpleText
      {
         this.text = text;
         return this;
      }
      
      private function applyFormat(format:TextFormat) : void
      {
         setTextFormat(format);
         defaultTextFormat = format;
      }
      
      private function onChange(event:Event) : void
      {
         this.updateMetrics();
      }
      
      public function updateMetrics() : SimpleText
      {
         var textMetrics:TextLineMetrics = null;
         var textWidth:int = 0;
         var textHeight:int = 0;
         this.actualWidth_ = 0;
         this.actualHeight_ = 0;
         for(var i:int = 0; i < numLines; i++)
         {
            textMetrics = getLineMetrics(i);
            textWidth = textMetrics.width + 4;
            textHeight = textMetrics.height + 4;
            if(textWidth > this.actualWidth_)
            {
               this.actualWidth_ = textWidth;
            }
            this.actualHeight_ = this.actualHeight_ + textHeight;
         }
         width = this.inputWidth_ == 0?Number(this.actualWidth_):Number(this.inputWidth_);
         height = this.inputHeight_ == 0?Number(this.actualHeight_):Number(this.inputHeight_);
         return this;
      }
      
      public function useTextDimensions() : void
      {
         width = this.inputWidth_ == 0?Number(textWidth + 4):Number(this.inputWidth_);
         height = this.inputHeight_ == 0?Number(textHeight + 4):Number(this.inputHeight_);
      }
   }
}
