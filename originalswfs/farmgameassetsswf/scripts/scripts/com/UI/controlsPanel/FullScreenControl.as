package com.UI.controlsPanel
{
   import com.Events.UIEvent;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol98")]
   public class FullScreenControl extends ControlsPanelButton
   {
      
      public function FullScreenControl()
      {
         addFrameScript(0,this.frame1,6,this.frame7);
         super();
         this.active_event = this.inactive_event = UIEvent.TOGGLE_SCREEEN;
         this.active = true;
      }
      
      override protected function onAddedToStage(param1:Event) : void
      {
         trace("FSADDED");
         super.onAddedToStage(param1);
         this.stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      private function onResize(param1:Event) : void
      {
         trace("RZE: ",this.stage.displayState);
         if(this.stage.displayState == StageDisplayState.NORMAL)
         {
            this.active = true;
         }
         else
         {
            this.active = false;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         stop();
      }
   }
}

