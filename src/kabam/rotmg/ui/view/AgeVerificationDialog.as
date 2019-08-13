package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.ui.components.DateField;
   import org.osflash.signals.Signal;
   
   public class AgeVerificationDialog extends Dialog
   {
      
      private static const WIDTH:int = 300;
       
      
      private const BIRTH_DATE_BELOW_MINIMUM_ERROR:String = "You must be at least 13 years of age";
      
      private const BIRTH_DATE_INVALID_ERROR:String = "Birthdate is not a valid date.";
      
      private var ageVerificationField:DateField;
      
      private var text:String;
      
      private var errorLabel:SimpleText;
      
      private var errorMessage:String = "";
      
      private const MINIMUM_AGE:uint = 13;
      
      public const response:Signal = new Signal(Boolean);
      
      public function AgeVerificationDialog()
      {
         this.text = "The <font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">Terms of Use</a></font> and " + "<font color=\"#7777EE\"><a href=\"" + Parameters.PRIVACY_POLICY_URL + "\" target=\"_blank\">Privacy Policy</a></font><br>have been updated. Please provide the<br>information below, and then read and agree to the update.";
         super(this.text,"Terms and Privacy Update","No way","I agree");
         addEventListener(Dialog.BUTTON1_EVENT,this.onCancel);
         addEventListener(Dialog.BUTTON2_EVENT,this.onVerify);
      }
      
      private function initAgeVerificationField() : void
      {
         this.ageVerificationField = new DateField();
         this.ageVerificationField.setTitle("Birthday");
      }
      
      override protected function initText(text:String) : void
      {
         textText_ = new SimpleText(14,11776947,false,WIDTH - 40,0);
         textText_.x = 20;
         textText_.multiline = true;
         textText_.wordWrap = true;
         textText_.htmlText = text;
         textText_.autoSize = TextFieldAutoSize.LEFT;
         textText_.mouseEnabled = true;
         textText_.updateMetrics();
         textText_.filters = [new DropShadowFilter(0,0,0,1,6,6,1)];
      }
      
      override protected function draw() : void
      {
         this.initAgeVerificationField();
         this.errorLabel = new SimpleText(12,16549442,false,0,0);
         this.errorLabel.htmlText = " <br> ";
         this.errorLabel.multiline = true;
         this.errorLabel.updateMetrics();
         this.errorLabel.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         rect_ = new Shape();
         titleText_.y = 2;
         textText_.y = titleText_.y + titleText_.actualHeight_ + 8;
         this.ageVerificationField.y = textText_.y + textText_.height + 8;
         this.ageVerificationField.x = 20;
         this.errorLabel.y = this.ageVerificationField.y + this.ageVerificationField.height + 8;
         this.errorLabel.x = 20;
         box_.addChild(titleText_);
         box_.addChild(textText_);
         box_.addChild(this.ageVerificationField);
         box_.addChild(this.errorLabel);
         var by:int = box_.height + 16;
         button1_.x = WIDTH / 4 - button1_.width / 2;
         button2_.x = 3 * WIDTH / 4 - button2_.width / 2;
         button1_.y = by;
         button2_.y = by;
         box_.addChild(button1_);
         box_.addChild(button2_);
         GraphicsUtil.clearPath(path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,box_.height + 10,4,[1,1,1,1],path_);
         rect_.graphics.drawGraphicsData(graphicsData_);
         box_.addChildAt(rect_,0);
         box_.filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
         addChild(box_);
      }
      
      private function onCancel(event:Event) : void
      {
         this.response.dispatch(false);
      }
      
      private function onVerify(event:Event) : void
      {
         var isError:Boolean = false;
         var playerAge:uint = this.getPlayerAge();
         var dateIsNotNumeric:Boolean = isNaN(this.getBirthDate());
         if(!this.ageVerificationField.isValidDate())
         {
            this.errorMessage = this.BIRTH_DATE_INVALID_ERROR;
            isError = true;
         }
         else if(playerAge < this.MINIMUM_AGE && !isError)
         {
            this.errorMessage = this.BIRTH_DATE_BELOW_MINIMUM_ERROR;
            isError = true;
         }
         else
         {
            this.errorMessage = "";
            isError = false;
            this.response.dispatch(true);
         }
         this.errorLabel.htmlText = this.errorMessage;
         this.errorLabel.updateMetrics();
         this.ageVerificationField.setErrorHighlight(isError);
      }
      
      private function getPlayerAge() : uint
      {
         var dob:Date = new Date(this.getBirthDate());
         var now:Date = new Date();
         var age:uint = Number(now.fullYear) - Number(dob.fullYear);
         if(dob.month > now.month || dob.month == now.month && dob.date > now.date)
         {
            age--;
         }
         return age;
      }
      
      private function getBirthDate() : Number
      {
         return Date.parse(this.ageVerificationField.getDate());
      }
   }
}
