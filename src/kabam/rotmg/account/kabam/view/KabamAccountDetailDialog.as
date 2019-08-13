package kabam.rotmg.account.kabam.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import org.osflash.signals.Signal;
   
   public class KabamAccountDetailDialog extends Sprite
   {
       
      
      public var done:Signal;
      
      private var loginText_:SimpleText;
      
      private var usernameText_:SimpleText;
      
      public function KabamAccountDetailDialog()
      {
         super();
         this.done = new Signal();
      }
      
      public function setInfo(userName:String) : void
      {
         var frame:Frame = new Frame("Current account","","Continue");
         addChild(frame);
         this.loginText_ = new SimpleText(18,11776947,false,0,0);
         this.loginText_.setBold(true);
         this.loginText_.text = "Currently logged on Kabam.com as:";
         this.loginText_.useTextDimensions();
         this.loginText_.filters = [new DropShadowFilter(0,0,0)];
         this.loginText_.y = frame.h_ - 60;
         this.loginText_.x = 17;
         frame.addChild(this.loginText_);
         this.usernameText_ = new SimpleText(16,11776947,false,238,30);
         this.usernameText_.text = userName;
         this.usernameText_.useTextDimensions();
         this.usernameText_.y = frame.h_ - 30;
         this.usernameText_.x = 17;
         frame.addChild(this.usernameText_);
         frame.h_ = frame.h_ + 88;
         frame.w_ = frame.w_ + 60;
         frame.rightButton_.addEventListener(MouseEvent.CLICK,this.onContinue);
      }
      
      private function onContinue(event:MouseEvent) : void
      {
         this.done.dispatch();
      }
   }
}
