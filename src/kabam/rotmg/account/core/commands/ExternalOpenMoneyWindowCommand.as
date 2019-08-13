package kabam.rotmg.account.core.commands
{
   import flash.external.ExternalInterface;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.model.JSInitializedModel;
   import kabam.rotmg.account.core.model.MoneyConfig;
   import kabam.rotmg.account.core.view.MoneyFrame;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class ExternalOpenMoneyWindowCommand
   {
       
      
      [Inject]
      public var moneyWindowModel:JSInitializedModel;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var moneyConfig:MoneyConfig;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var logger:ILogger;
      
      public function ExternalOpenMoneyWindowCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         try
         {
            if(!this.moneyWindowModel.isInitialized)
            {
               ExternalInterface.call(this.moneyConfig.jsInitializeFunction(),this.account.getMoneyUserId(),this.account.getMoneyAccessToken());
               this.moneyWindowModel.isInitialized = true;
            }
            this.logger.debug("Attempting External Payments");
            ExternalInterface.call("rotmg.KabamPayment.displayPaymentWall");
         }
         catch(e:Error)
         {
            logger.debug("Attempting Internal Payments");
            openDialog.dispatch(new MoneyFrame());
         }
      }
   }
}
