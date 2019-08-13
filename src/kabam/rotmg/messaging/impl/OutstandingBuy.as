package kabam.rotmg.messaging.impl
{
   class OutstandingBuy
   {
       
      
      private var id_:String;
      
      private var price_:int;
      
      private var currency_:int;
      
      private var converted_:Boolean;
      
      function OutstandingBuy(id:String, price:int, currency:int, converted:Boolean)
      {
         super();
         this.id_ = id;
         this.price_ = price;
         this.currency_ = currency;
         this.converted_ = converted;
      }
   }
}
