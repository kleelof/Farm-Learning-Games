package com.UI.controlsPanel
{
   import com.Events.UIEvent;
   import com.classes.MusicPlayer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol102")]
   public class MusicButton extends ControlsPanelButton
   {
      
      public function MusicButton()
      {
         addFrameScript(0,this.frame1,6,this.frame7);
         super();
         this.active_event = UIEvent.MUTE_MUSIC;
         this.inactive_event = UIEvent.UNMUTE_MUSIC;
         this.active = !MusicPlayer.is_playing;
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

