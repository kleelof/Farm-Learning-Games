package com.Games.GaryGoat.instructions
{
   import com.Events.FGLPEvent;
   import com.Events.GaryGoatEvent;
   import com.UI.Instructions;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol140")]
   public class GGInstructions extends Instructions
   {
      
      public var next_btn:SimpleButton;
      
      public function GGInstructions()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.next_btn.addEventListener(MouseEvent.CLICK,this.onNextClicked);
      }
      
      private function onNextClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new GaryGoatEvent(GaryGoatEvent.INSTRUCTIONS_COMPLETE));
         this.fadeOut();
      }
   }
}

