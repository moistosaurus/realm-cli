package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class ScepterComparison extends SlotComparison
   {
       
      
      public function ScepterComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var result:XMLList = null;
         var otherResult:XMLList = null;
         var damage:int = 0;
         var otherDamage:int = 0;
         var textColor:String = null;
         var targets:int = 0;
         var otherTargets:int = 0;
         var condition:String = null;
         var duration:Number = NaN;
         var compositeStr:String = null;
         var htmlStr:String = null;
         result = itemXML.Activate.(text() == ActivationType.LIGHTNING);
         otherResult = curItemXML.Activate.(text() == ActivationType.LIGHTNING);
         comparisonText = "";
         if(result.length() == 1 && otherResult.length() == 1)
         {
            damage = int(result[0].@totalDamage);
            otherDamage = int(otherResult[0].@totalDamage);
            textColor = getTextColor(damage - otherDamage);
            targets = int(result[0].@maxTargets);
            otherTargets = int(otherResult[0].@maxTargets);
            comparisonText = comparisonText + ("Lightning: " + wrapInColoredFont(damage + " to " + targets + " targets\n",getTextColor(damage - otherDamage)));
            processedTags[result[0].toXMLString()] = true;
         }
         if(itemXML.Activate.@condEffect)
         {
            condition = itemXML.Activate.@condEffect;
            duration = itemXML.Activate.@condDuration;
            compositeStr = " " + condition + " for " + duration + " secs\n";
            htmlStr = "Shot Effect:\n" + wrapInColoredFont(compositeStr,NO_DIFF_COLOR);
            comparisonText = comparisonText + htmlStr;
         }
      }
   }
}
