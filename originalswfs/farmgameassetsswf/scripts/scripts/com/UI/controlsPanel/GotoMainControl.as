package com.UI.controlsPanel
{
   import com.Events.UIEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol107")]
   public class GotoMainControl extends ControlsPanelButton
   {
      
      public function GotoMainControl()
      {
         addFrameScript(0,this.frame1,6,this.frame7);
         super();
         this.active_event = UIEvent.GO_HOME_CLICKED;
         this.inactive_event = null;
         this.active = true;
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

