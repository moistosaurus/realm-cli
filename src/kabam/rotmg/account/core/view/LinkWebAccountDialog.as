package kabam.rotmg.account.core.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import com.company.ui.SimpleText;
   import com.company.util.EmailValidator;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.StyleSheet;
   import kabam.rotmg.account.web.model.AccountData;
   import org.osflash.signals.Signal;
   
   public class LinkWebAccountDialog extends Frame
   {
      
      private static const CSS_TEXT:String = ".in { margin-left:10px; text-indent: -10px; }";
      
      private static const WARNING_TEXT:String = "<font color=\"#FF0000\"><b>WARNING:</b></font> " + "You will " + "<font color=\"#FF0000\"><b>LOSE ALL PROGRESS, GOLD, ETC.</b></font> " + "in your current Kongregate account.  This process " + "<font color=\"#FF0000\"><b>CAN NOT BE REVERSED</b></font>.  " + "Think carefully before hitting Replace.";
       
      
      public var cancel:Signal;
      
      public var link:Signal;
      
      private var warningText:SimpleText;
      
      private var emailInput:TextInputField;
      
      private var passwordInput:TextInputField;
      
      public function LinkWebAccountDialog()
      {
         this.cancel = new Signal();
         this.link = new Signal(AccountData);
         super("Replace with an existing web account","Cancel","Replace");
         h_ = h_ + 4;
         var sheet:StyleSheet = new StyleSheet();
         sheet.parseCSS(CSS_TEXT);
         this.warningText = new SimpleText(14,16549442,false,w_ - 32,0);
         this.warningText.styleSheet = sheet;
         this.warningText.wordWrap = true;
         this.warningText.htmlText = "<span class=\'in\'>" + WARNING_TEXT + "</span>";
         this.warningText.useTextDimensions();
         this.warningText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.warningText.x = 17;
         this.warningText.y = h_ - 66;
         addChild(this.warningText);
         h_ = h_ + 88;
         this.emailInput = new TextInputField("Email",false,"");
         addTextInputField(this.emailInput);
         this.passwordInput = new TextInputField("Password",true,"");
         addTextInputField(this.passwordInput);
         leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onLink);
      }
      
      private function onCancel(event:MouseEvent) : void
      {
         this.cancel.dispatch();
      }
      
      private function onLink(event:MouseEvent) : void
      {
         var data:AccountData = null;
         if(this.isEmailValid() && this.isPasswordValid())
         {
            data = new AccountData();
            data.username = this.emailInput.text();
            data.password = this.passwordInput.text();
            this.link.dispatch(data);
         }
      }
      
      private function isEmailValid() : Boolean
      {
         var isValid:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
         if(!isValid)
         {
            this.emailInput.setError("Not a valid email address");
         }
         return isValid;
      }
      
      private function isPasswordValid() : Boolean
      {
         var isValid:Boolean = this.passwordInput.text().length >= 5;
         if(!isValid)
         {
            this.passwordInput.setError("Password too short");
         }
         return isValid;
      }
      
      public function setError(error:String) : void
      {
         this.passwordInput.setError(error);
      }
   }
}
