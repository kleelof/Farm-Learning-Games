package com.Games.DigitDucks
{
   import com.Events.DigitDucksEvent;
   import com.Events.FGLPEvent;
   import com.UI.Instructions;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol65")]
   public class DDInstructions extends Instructions
   {
      
      public var play_btn:SimpleButton;
      
      public function DDInstructions()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.play_btn.addEventListener(MouseEvent.CLICK,this.onPlayClicked);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onPlayClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new DigitDucksEvent(DigitDucksEvent.PLAY_AGAIN));
         this.fadeOut();
      }
   }
}

