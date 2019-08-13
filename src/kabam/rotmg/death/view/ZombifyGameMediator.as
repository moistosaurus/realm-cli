package kabam.rotmg.death.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import flash.utils.Dictionary;
   import kabam.rotmg.death.control.ZombifySignal;
   import kabam.rotmg.game.signals.SetWorldInteractionSignal;
   import kabam.rotmg.messaging.impl.incoming.Death;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ZombifyGameMediator extends Mediator
   {
       
      
      [Inject]
      public var view:GameSprite;
      
      [Inject]
      public var zombify:ZombifySignal;
      
      [Inject]
      public var setWorldInteraction:SetWorldInteractionSignal;
      
      public function ZombifyGameMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.zombify.add(this.onZombify);
      }
      
      private function onClosed() : void
      {
         this.zombify.remove(this.onZombify);
      }
      
      private function onZombify(death:Death) : void
      {
         this.removePlayer();
         this.setZombieAsViewFocus(death);
         this.setWorldInteraction.dispatch(false);
      }
      
      private function removePlayer() : void
      {
         var player:Player = this.view.map.player_;
         player && this.view.map.removeObj(player.objectId_);
         this.view.map.player_ = null;
      }
      
      private function setZombieAsViewFocus(death:Death) : void
      {
         var objects:Dictionary = this.view.map.goDict_;
         objects && this.view.setFocus(objects[death.zombieId]);
      }
   }
}
