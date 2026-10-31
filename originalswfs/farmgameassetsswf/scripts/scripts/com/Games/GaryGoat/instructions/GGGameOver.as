package com.Games.GaryGoat.instructions
{
   import com.Events.FGLPEvent;
   import com.Events.GaryGoatEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol125")]
   public class GGGameOver extends MovieClip
   {
      
      public var play_again_btn:SimpleButton;
      
      public function GGGameOver()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.play_again_btn.addEventListener(MouseEvent.CLICK,this.onPlayAgainClicked);
      }
      
      private function onPlayAgainClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new GaryGoatEvent(GaryGoatEvent.PLAY_AGAIN));
      }
   }
}

