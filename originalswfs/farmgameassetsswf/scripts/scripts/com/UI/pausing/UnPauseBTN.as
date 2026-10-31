package com.UI.pausing
{
   import com.Events.PauseEvent;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class UnPauseBTN extends SimpleButton
   {
      
      public function UnPauseBTN()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(MouseEvent.CLICK,this.onClicked);
         this.x = (this.parent.width - this.width) / 2;
         this.y = (this.parent.height - this.height) / 2;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new PauseEvent(PauseEvent.END_PAUSE));
      }
   }
}

