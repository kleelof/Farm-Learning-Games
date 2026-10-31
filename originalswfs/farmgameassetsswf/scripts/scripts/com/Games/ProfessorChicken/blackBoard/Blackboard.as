package com.Games.ProfessorChicken.blackBoard
{
   import com.Events.FGLPEvent;
   import com.Events.ProfChixEvent;
   import com.Games.ProfessorChicken.classes.PCQuestion;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol253")]
   public class Blackboard extends MovieClip
   {
      
      private var _current_question:PCQuestion;
      
      private var answer_panels:Array;
      
      private var _active:Boolean;
      
      public var question_txt:TextField;
      
      public var next_question_btn:SimpleButton;
      
      public var play_again_btn:SimpleButton;
      
      public var result_txt:TextField;
      
      public function Blackboard()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function revealCorrectAnswer(param1:Boolean = true) : void
      {
         var _loc2_:AnswerPanel = null;
         this.active = false;
         for each(_loc2_ in this.answer_panels)
         {
            if(!_loc2_.correct_answer)
            {
               _loc2_.remove();
            }
            else
            {
               TweenMax.to(_loc2_,0.5,{"y":this.question_txt.y + this.question_txt.height + 5});
            }
         }
         if(param1)
         {
            this.addChild(this.next_question_btn);
         }
         else
         {
            this.addChild(this.play_again_btn);
         }
      }
      
      public function get current_question() : PCQuestion
      {
         return this._current_question;
      }
      
      public function set current_question(param1:PCQuestion) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:AnswerPanel = null;
         this._current_question = param1;
         this.clearTexts();
         if(param1 != null)
         {
            this.question_txt.text = param1.question_text;
            this.answer_panels = new Array();
            _loc2_ = this.question_txt.y + this.question_txt.height + 5;
            for each(_loc3_ in param1.answers)
            {
               _loc4_ = AnswerPanel(this.addChild(new AnswerPanel(_loc3_,Boolean(_loc3_ == param1.correct_answer))));
               this.answer_panels.push(_loc4_);
               _loc4_.y = _loc2_ + 5;
               _loc2_ += _loc4_.height;
            }
         }
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:AnswerPanel = null;
         this._active = param1;
         if(this.answer_panels)
         {
            for each(_loc2_ in this.answer_panels)
            {
               _loc2_.active = param1;
            }
         }
      }
      
      public function set result_message(param1:String) : void
      {
         this.addChild(this.result_txt);
         this.result_txt.htmlText = param1;
      }
      
      private function clearTexts() : void
      {
         var _loc1_:AnswerPanel = null;
         this.question_txt.text = "";
         for each(_loc1_ in this.answer_panels)
         {
            _loc1_.remove();
         }
         if(this.next_question_btn.parent)
         {
            this.next_question_btn.parent.removeChild(this.next_question_btn);
         }
         if(this.play_again_btn.parent)
         {
            this.play_again_btn.parent.removeChild(this.play_again_btn);
         }
         if(this.result_txt.parent)
         {
            this.removeChild(this.result_txt);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.next_question_btn.parent.removeChild(this.next_question_btn);
         this.play_again_btn.parent.removeChild(this.play_again_btn);
         this.removeChild(this.result_txt);
         this.clearTexts();
         this.next_question_btn.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
         this.play_again_btn.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
      }
      
      private function onButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         switch(param1.target)
         {
            case this.next_question_btn:
               dispatchEvent(new ProfChixEvent(ProfChixEvent.NEXT_QUESTION));
               break;
            case this.play_again_btn:
               dispatchEvent(new ProfChixEvent(ProfChixEvent.PLAY_AGAIN));
         }
      }
   }
}

