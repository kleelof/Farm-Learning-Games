package com.Games.MainMenu
{
   import com.Events.FGLPEvent;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MainMenuButton extends MovieClip
   {
      
      public function MainMenuButton()
      {
         super();
         this.buttonMode = true;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(MouseEvent.CLICK,this.onClicked);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onClicked(param1:Event) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.GOTO_GAME,this.name.substr(2)));
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         TweenMax.to(this,0.3,{
            "scaleX":1,
            "scaleY":1
         });
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         TweenMax.to(this,0.3,{
            "scaleX":1.2,
            "scaleY":1.2
         });
      }
   }
}

