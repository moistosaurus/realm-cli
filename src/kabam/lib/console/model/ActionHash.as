package kabam.lib.console.model
{
   import org.osflash.signals.Signal;
   
   final class ActionHash
   {
       
      
      private var signalMap:Object;
      
      private var descriptionMap:Object;
      
      function ActionHash()
      {
         super();
         this.signalMap = {};
         this.descriptionMap = {};
      }
      
      public function register(name:String, description:String, signal:Signal) : void
      {
         this.signalMap[name] = signal;
         this.descriptionMap[name] = description;
      }
      
      public function getNames() : Vector.<String>
      {
         var name:* = null;
         var names:Vector.<String> = new Vector.<String>(0);
         for(name in this.signalMap)
         {
            names.push(name + " - " + this.descriptionMap[name]);
         }
         return names;
      }
      
      public function execute(input:String) : void
      {
         var data:Array = input.split(" ");
         if(data.length == 0)
         {
            return;
         }
         var name:String = data.shift();
         var signal:Signal = this.signalMap[name];
         if(!signal)
         {
            return;
         }
         data = data.join(" ").split(",");
         signal.dispatch.apply(this,data);
      }
      
      public function has(action:String) : Boolean
      {
         var data:Array = action.split(" ");
         return data.length > 0 && this.signalMap[data[0]] != null;
      }
   }
}
