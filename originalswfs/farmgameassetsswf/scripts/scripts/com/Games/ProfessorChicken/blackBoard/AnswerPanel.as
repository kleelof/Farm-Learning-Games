package com.Games.ProfessorChicken.blackBoard
{
   import com.Events.FGLPEvent;
   import com.Events.ProfChixEvent;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol26")]
   public class AnswerPanel extends MovieClip
   {
      
      public var bg:MovieClip;
      
      public var correct_answer:Boolean;
      
      private var _active:Boolean;
      
      public var txt:TextField;
      
      public function AnswerPanel(param1:String, param2:Boolean)
      {
         super();
         this.correct_answer = param2;
         this.txt.text = param1;
         this.txt.autoSize = "left";
         this.height = this.bg.height = this.txt.height;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function remove(param1:Boolean = false) : void
      {
         this.active = false;
         if(param1)
         {
            this.onFadeOutComplete();
         }
         else
         {
            TweenMax.to(this,0.3,{"alpha":0});
         }
      }
      
      public function reveal() : void
      {
         if(this.correct_answer)
         {
            this.bg.alpha = 1;
         }
         else
         {
            this.bg.alpha = 0;
         }
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         if(param1)
         {
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK,this.onClicked);
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
         else
         {
            this.buttonMode = false;
            this.removeEventListener(MouseEvent.CLICK,this.onClicked);
            this.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.active = true;
         this.bg.alpha = 0;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         TweenMax.to(this.bg,0.3,{"alpha":0});
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         TweenMax.to(this.bg,0.3,{"alpha":1});
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new ProfChixEvent(ProfChixEvent.ANSWER_CLICKED,this.correct_answer));
      }
      
      private function onFadeOutComplete() : void
      {
         this.parent.removeChild(this);
      }
   }
}

