package com.company.ui
{
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class SimpleLinkText extends TextField
   {
       
      
      public var inputWidth_:int;
      
      public var inputHeight_:int;
      
      public var actualWidth_:int;
      
      public var actualHeight_:int;
      
      public function SimpleLinkText(textSize:int, color:uint, widthParam:int = 0, heightParam:int = 0, font:String = "Tahoma")
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
            width = heightParam;
         }
         var format:TextFormat = new TextFormat();
         if(font != null && font != "")
         {
            embedFonts = true;
            format.font = font;
         }
         format.size = textSize;
         format.color = color;
         defaultTextFormat = format;
         selectable = false;
         mouseEnabled = true;
      }
      
      public function setSizeColor(textSize:int, color:uint) : void
      {
         var format:TextFormat = defaultTextFormat;
         format.size = textSize;
         format.color = color;
         setTextFormat(format);
         defaultTextFormat = format;
      }
      
      public function setColor(color:uint) : void
      {
         var format:TextFormat = defaultTextFormat;
         format.color = color;
         setTextFormat(format);
         defaultTextFormat = format;
      }
      
      public function setBold(bold:Boolean) : void
      {
         var format:TextFormat = defaultTextFormat;
         format.bold = bold;
         setTextFormat(format);
         defaultTextFormat = format;
      }
      
      private function onChange(event:Event) : void
      {
         this.updateMetrics();
      }
      
      public function updateMetrics() : void
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
      }
      
      public function useTextDimensions() : void
      {
         width = this.inputWidth_ == 0?Number(textWidth + 4):Number(this.inputWidth_);
         height = this.inputHeight_ == 0?Number(textHeight + 4):Number(this.inputHeight_);
      }
   }
}
