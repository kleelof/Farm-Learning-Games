package com.UI
{
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Instructions extends MovieClip
   {
      
      public function Instructions()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      protected function fadeOut() : void
      {
         TweenMax.to(this,0.5,{
            "alpha":0,
            "onComplete":this.onFadeoutComplete
         });
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.alpha = 1;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onFadeoutComplete() : void
      {
         this.parent.removeChild(this);
      }
   }
}

