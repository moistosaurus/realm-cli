package kabam.rotmg.protip.model
{
   public class EmbeddedProTipModel implements IProTipModel
   {
      
      public static var protipsXML:Class = EmbeddedProTipModel_protipsXML;
       
      
      private var tips:Vector.<String>;
      
      private var indices:Vector.<int>;
      
      private var index:int;
      
      private var count:int;
      
      public function EmbeddedProTipModel()
      {
         super();
         this.index = 0;
         this.makeTipsVector();
         this.count = this.tips.length;
         this.makeRandomizedIndexVector();
      }
      
      public function getTip() : String
      {
         var i:int = this.indices[this.index++ % this.count];
         return this.tips[i];
      }
      
      private function makeTipsVector() : void
      {
         var tip:XML = null;
         var xml:XML = XML(new protipsXML());
         this.tips = new Vector.<String>(0);
         for each(tip in xml.Protip)
         {
            this.tips.push(tip.toString());
         }
         this.count = this.tips.length;
      }
      
      private function makeRandomizedIndexVector() : void
      {
         var list:Vector.<int> = new Vector.<int>(0);
         for(var i:int = 0; i < this.count; i++)
         {
            list.push(i);
         }
         this.indices = new Vector.<int>(0);
         while(i > 0)
         {
            this.indices.push(list.splice(Math.floor(Math.random() * i--),1)[0]);
         }
         this.indices.fixed = true;
      }
   }
}
