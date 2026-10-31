package com.Games.SuzySow
{
   import com.Events.FGLPEvent;
   import com.Events.SuzySowEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol216")]
   public class SSGameOver extends MovieClip
   {
      
      public var play_again_btn:SimpleButton;
      
      public function SSGameOver()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.play_again_btn.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
      }
      
      private function onButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new SuzySowEvent(SuzySowEvent.PLAY_GAME));
         this.parent.removeChild(this);
      }
   }
}

