package com.Games.SuzySow
{
   import com.Events.FGLPEvent;
   import com.Events.SuzySowEvent;
   import com.UI.Instructions;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol221")]
   public class SSInstructions extends Instructions
   {
      
      public var play_btn:SimpleButton;
      
      public function SSInstructions()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.play_btn.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
      }
      
      private function onButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new SuzySowEvent(SuzySowEvent.PLAY_GAME));
         this.fadeOut();
      }
   }
}

