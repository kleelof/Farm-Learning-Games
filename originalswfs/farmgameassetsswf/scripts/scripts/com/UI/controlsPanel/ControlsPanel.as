package com.UI.controlsPanel
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol108")]
   public class ControlsPanel extends MovieClip
   {
      
      public static const MODE_LEFT:String = "left";
      
      public static const MODE_RIGHT:String = "right";
      
      public static const MODE_NONE:String = "none";
      
      public var goto_main_mc:ControlsPanelButton;
      
      public var full_screen_btn:ControlsPanelButton;
      
      public var sound_mc:ControlsPanelButton;
      
      public function ControlsPanel()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function set mode(param1:String) : void
      {
         switch(param1)
         {
            case MODE_LEFT:
               this.gotoAndStop("left");
               break;
            case MODE_NONE:
               this.gotoAndStop("none");
               break;
            case MODE_RIGHT:
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

