package kabam.rotmg.account.steam.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.ui.ClickableText;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import org.osflash.signals.Signal;
   
   public class SteamAccountDetailDialog extends Sprite
   {
       
      
      public var done:Signal;
      
      public var register:Signal;
      
      public var link:Signal;
      
      private var loginText_:SimpleText;
      
      private var usernameText_:SimpleText;
      
      private var webLoginText_:SimpleText;
      
      private var emailText_:SimpleText;
      
      private var register_:ClickableText;
      
      private var link_:ClickableText;
      
      public function SteamAccountDetailDialog()
      {
         super();
         this.done = new Signal();
         this.register = new Signal();
         this.link = new Signal();
      }
      
      public function setInfo(steamUserName:String, rotmgUserName:String, areLinked:Boolean) : void
      {
         var frame:Frame = null;
         frame = new Frame("Current account","","Continue");
         addChild(frame);
         this.loginText_ = new SimpleText(18,11776947,false,0,0);
         this.loginText_.setBold(true);
         this.loginText_.text = "Steamworks user:";
         this.loginText_.useTextDimensions();
         this.loginText_.filters = [new DropShadowFilter(0,0,0)];
         this.loginText_.y = frame.h_ - 60;
         this.loginText_.x = 17;
         frame.addChild(this.loginText_);
         this.usernameText_ = new SimpleText(16,11776947,false,238,30);
         this.usernameText_.text = steamUserName;
         this.usernameText_.useTextDimensions();
         this.usernameText_.y = frame.h_ - 30;
         this.usernameText_.x = 17;
         frame.addChild(this.usernameText_);
         frame.h_ = frame.h_ + 88;
         if(areLinked)
         {
            frame.h_ = frame.h_ - 20;
            this.webLoginText_ = new SimpleText(18,11776947,false,0,0);
            this.webLoginText_.setBold(true);
            this.webLoginText_.text = "Linked with the web account:";
            this.webLoginText_.useTextDimensions();
            this.webLoginText_.filters = [new DropShadowFilter(0,0,0)];
            this.webLoginText_.y = frame.h_ - 60;
            this.webLoginText_.x = 17;
            frame.addChild(this.webLoginText_);
            this.emailText_ = new SimpleText(16,11776947,false,238,30);
            this.emailText_.text = rotmgUserName;
            this.emailText_.useTextDimensions();
            this.emailText_.y = frame.h_ - 30;
            this.emailText_.x = 17;
            frame.addChild(this.emailText_);
            frame.h_ = frame.h_ + 88;
         }
         else
         {
            this.register_ = new ClickableText(12,false,"Register this account to play in a web browser");
            this.register_.addEventListener(MouseEvent.CLICK,this.onRegister);
            frame.addNavigationText(this.register_);
            this.link_ = new ClickableText(12,false,"Replace this account with an existing web account");
            this.link_.addEventListener(MouseEvent.CLICK,this.onLink);
            frame.addNavigationText(this.link_);
         }
         frame.rightButton_.addEventListener(MouseEvent.CLICK,this.onContinue);
      }
      
      private function onContinue(event:MouseEvent) : void
      {
         this.done.dispatch();
      }
      
      public function onRegister(event:MouseEvent) : void
      {
         this.register.dispatch();
      }
      
      public function onLink(event:MouseEvent) : void
      {
         this.link.dispatch();
      }
   }
}
