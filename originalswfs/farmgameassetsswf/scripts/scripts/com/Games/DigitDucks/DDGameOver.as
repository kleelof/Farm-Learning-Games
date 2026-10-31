package com.Games.DigitDucks
{
   import com.Events.DigitDucksEvent;
   import com.Events.FGLPEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol71")]
   public class DDGameOver extends MovieClip
   {
      
      public var play_again_btn:SimpleButton;
      
      public function DDGameOver()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.play_again_btn.addEventListener(MouseEvent.CLICK,this.onPlayAgainClicked);
      }
      
      private function onPlayAgainClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new DigitDucksEvent(DigitDucksEvent.PLAY_AGAIN));
         this.parent.removeChild(this);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
   }
}

