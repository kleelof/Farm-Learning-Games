package com.Games.ProfessorChicken
{
   import com.Events.FGLPEvent;
   import com.Events.ProfChixEvent;
   import com.UI.Instructions;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol246")]
   public class PCInstructions extends Instructions
   {
      
      public var play_btn:SimpleButton;
      
      public function PCInstructions()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.play_btn.addEventListener(MouseEvent.CLICK,this.onClicked);
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new ProfChixEvent(ProfChixEvent.START_GAME));
         this.fadeOut();
      }
   }
}

