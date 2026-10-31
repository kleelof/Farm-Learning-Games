package com.Games.ProfessorChicken
{
   import com.Events.*;
   import com.Games.Game;
   import com.Games.ProfessorChicken.blackBoard.Blackboard;
   import com.Games.ProfessorChicken.classes.*;
   import com.UI.controlsPanel.ControlsPanel;
   import com.classes.Config;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol268")]
   public class ProfessorChicken extends Game
   {
      
      public var game_mc:MovieClip;
      
      public var controls_mc:ControlsPanel;
      
      public var title_mc:MovieClip;
      
      private var question_keeper:PCQuestionKeeper = new PCQuestionKeeper();
      
      private var _correct_answers:int;
      
      private var number_of_questions:int;
      
      private var current_question_ndx:int;
      
      private var score_txt:TextField;
      
      private var prof_mc:MovieClip;
      
      private var blackboard_mc:Blackboard;
      
      public function ProfessorChicken()
      {
         trace("ProfessorChicken: ");
         super();
         this.score_txt = TextField(this.game_mc.getChildByName("score_txt"));
         this.prof_mc = MovieClip(this.game_mc.getChildByName("prof_mc"));
         this.blackboard_mc = Blackboard(this.game_mc.getChildByName("blackboard_mc"));
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      override protected function startGame() : void
      {
         super.startGame();
         var _loc1_:XML = Config.getXML("ProfChix");
         this.number_of_questions = int(_loc1_.Questions.@number_of_questions);
      }
      
      override protected function killGame() : void
      {
         this.blackboard_mc.current_question = null;
      }
      
      private function giveQuestion() : void
      {
         ++this.current_question_ndx;
         this.blackboard_mc.current_question = this.question_keeper.next_question;
         this.prof_mc.gotoAndPlay("happy2inq");
      }
      
      private function newGame() : void
      {
         this.question_keeper.initialize();
         this.correct_answers = 0;
         this.current_question_ndx = 0;
         this.giveQuestion();
      }
      
      public function get correct_answers() : int
      {
         return this._correct_answers;
      }
      
      public function set correct_answers(param1:int) : void
      {
         this._correct_answers = param1;
         this.score_txt.text = "You\'ve answered " + String(param1) + " of " + String(this.number_of_questions) + " questions correctly!";
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(ProfChixEvent.ANSWER_CLICKED,this.onAnswerSelected);
         this.addEventListener(ProfChixEvent.NEXT_QUESTION,this.onNextQuestion);
         this.addEventListener(ProfChixEvent.PLAY_AGAIN,this.onPlayAgain);
         this.addEventListener(ProfChixEvent.START_GAME,this.onPlayAgain);
      }
      
      private function onPlayAgain(param1:ProfChixEvent) : void
      {
         this.newGame();
      }
      
      private function onNextQuestion(param1:ProfChixEvent) : void
      {
         this.giveQuestion();
      }
      
      private function onAnswerSelected(param1:ProfChixEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         this.blackboard_mc.revealCorrectAnswer(Boolean(this.current_question_ndx < this.number_of_questions));
         var _loc2_:Sound = new happy_chicken();
         if(!Boolean(param1.data))
         {
            _loc2_ = new unhappy_chicken();
            this.prof_mc.gotoAndPlay("happy2dissapoint");
         }
         else
         {
            ++this.correct_answers;
            this.prof_mc.gotoAndPlay("happy2smile");
         }
         dispatchEvent(new FGLPEvent(FGLPEvent.PLAY_SOUND_EFFECT,_loc2_));
         if(this.current_question_ndx == this.number_of_questions)
         {
            _loc3_ = this.correct_answers / this.number_of_questions;
            _loc4_ = "Congratulations, you are a Chicken Professor!";
            if(_loc3_ < 0.7)
            {
               _loc4_ = "You have achieved the rank of Professor\'s assistant.";
            }
            if(_loc3_ < 0.5)
            {
               _loc4_ = "Sorry, hatchling, you need to study more.";
            }
            this.blackboard_mc.result_message = "You answered " + String(this.correct_answers) + " out of " + String(this.number_of_questions) + " questions correctly!<br/>" + _loc4_;
         }
      }
   }
}

