package com.Games.DigitDucks
{
   import com.Events.DigitDucksEvent;
   import com.Events.FGLPEvent;
   import com.Events.PauseEvent;
   import com.Games.DigitDucks.duckPen.DuckPen;
   import com.Games.DigitDucks.probHandler.ProblemHandler;
   import com.Games.Game;
   import com.UI.controlsPanel.ControlsPanel;
   import com.UI.pausing.UnPauseBTN;
   import com.classes.Config;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol109")]
   public class DigitDucks extends Game
   {
      
      public var game_mc:MovieClip;
      
      public var controls_mc:ControlsPanel;
      
      public var title_mc:MovieClip;
      
      private var PH:ProblemHandler;
      
      private var DP:DuckPen;
      
      private var pause_after_drop_TMR:Timer = new Timer(3000,1);
      
      private var _score:int;
      
      private var duck_count_mc:DDDuckCount;
      
      private var score_txt:TextField;
      
      private var game_over_mc:DDGameOver;
      
      private var instructions_mc:DDInstructions;
      
      private var pause_btn:SimpleButton;
      
      private var unpause_btn:UnPauseBTN = new DDUnPauseBTN();
      
      public function DigitDucks()
      {
         super();
         this.duck_count_mc = DDDuckCount(this.game_mc.getChildByName("duck_count_mc"));
         this.score_txt = TextField(this.game_mc.getChildByName("score_txt"));
         this.game_over_mc = DDGameOver(this.game_mc.getChildByName("game_over_mc"));
         this.instructions_mc = DDInstructions(this.game_mc.getChildByName("instructions_mc"));
         this.pause_btn = SimpleButton(this.game_mc.getChildByName("pause_btn"));
         this.controls_mode = ControlsPanel.MODE_LEFT;
         this.show_game_over = false;
      }
      
      override protected function startGame() : void
      {
         super.startGame();
         if(!this.PH)
         {
            this.PH = new ProblemHandler(this.game_mc,new Point(20,20));
         }
         if(!this.DP)
         {
            this.DP = new DuckPen(this.game_mc,new Rectangle(395,105,625,425));
         }
         if(this.duck_count_mc.max_ducks == 0)
         {
            this.duck_count_mc.max_ducks = int(Config.getXML("DigitDucks").@max_ducks);
         }
         this.show_game_over = false;
         this.addEventListener(DigitDucksEvent.DUCK_DROPPED_ON_DIGIT,this.onDuckDroppedOnDigit);
         this.addEventListener(DigitDucksEvent.DUCK_ADDED_TO_PEN,this.onDuckAddedToPen);
         this.addEventListener(DigitDucksEvent.PEN_FULL,this.onPenFull);
         this.pause_after_drop_TMR.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPauseAfterDropTMRComplete);
         this.addEventListener(DigitDucksEvent.PLAY_AGAIN,this.onPlayAgain);
         this.score = 0;
         this.game_mc.addChild(this.instructions_mc);
         this.pause_btn.enabled = false;
      }
      
      override protected function killGame() : void
      {
      }
      
      public function set active(param1:Boolean) : void
      {
         this.pause_btn.enabled = param1;
         if(param1)
         {
            this.pause_btn.addEventListener(MouseEvent.CLICK,this.onPauseClicked);
         }
         else
         {
            this.pause_btn.removeEventListener(MouseEvent.CLICK,this.onPauseClicked);
         }
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function set score(param1:int) : void
      {
         this._score = param1;
         this.score_txt.text = String(param1);
      }
      
      private function set show_game_over(param1:Boolean) : void
      {
         if(param1)
         {
            this.game_mc.addChild(this.game_over_mc);
         }
         else if(this.game_over_mc.parent)
         {
            this.game_over_mc.parent.removeChild(this.game_over_mc);
         }
      }
      
      private function newGame() : void
      {
         this.score = 0;
         this.duck_count_mc.count = 0;
         this.DP.start();
         this.active = true;
         this.giveProblem();
      }
      
      private function giveProblem() : void
      {
         this.PH.next();
         this.PH.active = true;
      }
      
      private function gameOver() : void
      {
         this.PH.active = this.DP.active = false;
         this.show_game_over = true;
         this.active = false;
      }
      
      private function onDuckDroppedOnDigit(param1:DigitDucksEvent) : void
      {
         var _loc2_:DDDuck = DDDuck(param1.target);
         if(_loc2_.digit == this.PH.current_problem.replaced_digit)
         {
            _loc2_.kill();
            this.active = false;
            dispatchEvent(new FGLPEvent(FGLPEvent.PLAY_SOUND_EFFECT,new correctDuck()));
            ++this.score;
            this.DP.active = false;
            this.PH.revealReplacedDigit();
            --this.duck_count_mc.count;
            this.pause_after_drop_TMR.reset();
            this.pause_after_drop_TMR.start();
         }
         else
         {
            DDGlobals.target_digit.hightlight = false;
            _loc2_.returnToPen();
         }
      }
      
      private function onPauseClicked(param1:MouseEvent) : void
      {
         this.addPause(this.unpause_btn);
         this.DP.active = false;
         this.DP.hide = true;
         this.active = false;
         this.PH.hide = true;
         this.addEventListener(PauseEvent.END_PAUSE,this.onUnpauseClicked);
      }
      
      private function onUnpauseClicked(param1:PauseEvent) : void
      {
         this.endPause();
         this.DP.active = true;
         this.DP.hide = false;
         this.active = true;
         this.PH.hide = false;
      }
      
      private function onDuckAddedToPen(param1:DigitDucksEvent) : void
      {
         ++this.duck_count_mc.count;
      }
      
      private function onPenFull(param1:DigitDucksEvent) : void
      {
         this.gameOver();
      }
      
      private function onPauseAfterDropTMRComplete(param1:TimerEvent) : void
      {
         this.DP.active = true;
         this.giveProblem();
         this.active = true;
      }
      
      private function onPlayAgain(param1:DigitDucksEvent) : void
      {
         this.newGame();
      }
   }
}

