package kabam.rotmg.news.view
{
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import kabam.rotmg.news.controller.OpenSkinSignal;
   import kabam.rotmg.news.model.NewsCellLinkType;
   import kabam.rotmg.news.model.NewsCellVO;
   import kabam.rotmg.packages.control.OpenPackageSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class NewsCellMediator extends Mediator
   {
       
      
      [Inject]
      public var view:NewsCell;
      
      [Inject]
      public var openPackageSignal:OpenPackageSignal;
      
      [Inject]
      public var openSkinSignal:OpenSkinSignal;
      
      public function NewsCellMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.clickSignal.add(this.onNewsClicked);
      }
      
      override public function destroy() : void
      {
         this.view.clickSignal.remove(this.onNewsClicked);
      }
      
      private function onNewsClicked(vo:NewsCellVO) : void
      {
         var request:URLRequest = null;
         switch(vo.linkType)
         {
            case NewsCellLinkType.OPENS_LINK:
               request = new URLRequest(vo.linkDetail);
               navigateToURL(request,"_blank");
               break;
            case NewsCellLinkType.OPENS_PACKAGE:
               this.openPackageSignal.dispatch(int(vo.linkDetail));
               break;
            case NewsCellLinkType.OPENS_SKIN:
               this.openSkinSignal.dispatch(vo.linkDetail);
         }
      }
   }
}
