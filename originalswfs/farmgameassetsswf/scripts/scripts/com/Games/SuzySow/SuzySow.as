package com.Games.SuzySow
{
   import com.Events.*;
   import com.Games.Game;
   import com.Games.SuzySow.tileHolder.*;
   import com.Games.SuzySow.wordDisplay.WordDisplayer;
   import com.UI.controlsPanel.ControlsPanel;
   import com.UI.pausing.UnPauseBTN;
   import com.classes.Config;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol242")]
   public class SuzySow extends Game
   {
      
      public var game_mc:MovieClip;
      
      public var controls_mc:ControlsPanel;
      
      public var title_mc:MovieClip;
      
      private var word_pool:Array = new Array();
      
      private var selected_tiles:Array;
      
      private var pause_after_word_complete_TMR:Timer = new Timer(1000,1);
      
      private var word_being_built:String;
      
      private var _current_word:String;
      
      private var tile_holder_mc:TileHolder;
      
      private var show_word_btn:SimpleButton;
      
      private var timer_mc:SSTimer;
      
      private var word_displayer:WordDisplayer;
      
      private var score_mc:SSScore;
      
      private var instructions_mc:SSInstructions;
      
      private var game_over_mc:SSGameOver;
      
      private var pause_btn:SimpleButton;
      
      private var unpause_btn:UnPauseBTN = new SSUnPauseBTN();
      
      public function SuzySow()
      {
         super();
         this.tile_holder_mc = TileHolder(this.game_mc.getChildByName("tile_holder_mc"));
         this.show_word_btn = SimpleButton(this.game_mc.getChildByName("show_word_btn"));
         this.timer_mc = SSTimer(this.game_mc.getChildByName("timer_mc"));
         this.score_mc = SSScore(this.game_mc.getChildByName("score_mc"));
         this.instructions_mc = SSInstructions(this.game_mc.getChildByName("instructions_mc"));
         this.game_over_mc = SSGameOver(this.game_mc.getChildByName("game_over_mc"));
         this.pause_btn = SimpleButton(this.game_mc.getChildByName("pause_btn"));
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      override protected function startGame() : void
      {
         super.startGame();
         var _loc1_:XML = Config.getXML("SuzySow");
         this.timer_mc.total_time = int(_loc1_.@start_time);
         this.timer_mc.add_time = int(_loc1_.@add_time);
         this.tile_holder_mc.hide_difficulty = String(_loc1_.@hide_difficulty);
         this.tile_holder_mc.grid_size = int(_loc1_.@grid_size);
         this.game_mc.addChild(this.instructions_mc);
         this.show_game_over = false;
         this.active = false;
      }
      
      override protected function killGame() : void
      {
         trace("SSKILLGAME");
         this.show_game_over = false;
         this.tile_holder_mc.word = "";
         this.timer_mc.kill();
         if(this.word_displayer)
         {
            this.word_displayer.kill();
         }
      }
      
      public function get current_word() : String
      {
         return this._current_word;
      }
      
      public function set current_word(param1:String) : void
      {
         this._current_word = param1;
         this.word_being_built = "";
      }
      
      private function set active(param1:Boolean) : void
      {
         trace("SSActive: ",param1);
         this.tile_holder_mc.active = param1;
         this.show_word_btn.enabled = param1;
         this.pause_btn.enabled = param1;
         if(param1 == true)
         {
            this.pause_btn.addEventListener(MouseEvent.CLICK,this.onPause);
         }
         else
         {
            if(Boolean(this.word_displayer) && Boolean(this.word_displayer.parent))
            {
               this.word_displayer.kill();
               this.word_displayer.removeEventListener(Event.COMPLETE,this.onWordDiplayerCompleteNotNewWord);
               this.word_displayer.removeEventListener(Event.COMPLETE,this.onWordDisplayerCompelte);
            }
            this.pause_btn.removeEventListener(MouseEvent.CLICK,this.onPause);
         }
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
      
      private function killSelectedTiles() : void
      {
         var _loc1_:Tile = null;
         for each(_loc1_ in this.selected_tiles)
         {
            _loc1_.active = true;
         }
         this.selected_tiles = new Array();
         this.word_being_built = "";
      }
      
      private function playGame() : void
      {
         this.timer_mc.start();
         this.score_mc.score = 0;
         this.giveWord();
      }
      
      private function gameOver() : void
      {
         this.active = false;
         this.show_game_over = true;
      }
      
      private function giveWord() : void
      {
         var _loc1_:Array = null;
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.word_pool.length == 0)
         {
            _loc1_ = new Array();
            _loc2_ = Config.getXML("SuzySow");
            for each(_loc3_ in _loc2_.Words.target)
            {
               if(String(_loc3_.@word).length <= this.tile_holder_mc.grid_size - 2)
               {
                  _loc1_.push(String(_loc3_.@word).toUpperCase());
               }
            }
            this.word_pool = new Array();
            _loc4_ = int(_loc1_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.word_pool[_loc5_] = _loc1_.splice(int(Math.random() * (_loc4_ - _loc5_)),1)[0];
               _loc5_++;
            }
         }
         this.selected_tiles = new Array();
         this.current_word = this.word_pool.pop();
         this.timer_mc.pause();
         this.showCurrentWord();
      }
      
      private function showCurrentWord(param1:Boolean = true) : void
      {
         this.active = false;
         this.timer_mc.pause();
         this.tile_holder_mc.hide_letters = true;
         this.killSelectedTiles();
         this.word_displayer = WordDisplayer(this.addChild(new WordDisplayer(this.current_word)));
         if(param1)
         {
            this.word_displayer.addEventListener(Event.COMPLETE,this.onWordDisplayerCompelte);
         }
         else
         {
            this.word_displayer.addEventListener(Event.COMPLETE,this.onWordDiplayerCompleteNotNewWord);
         }
      }
      
      private function add_letter_to_word_being_built(param1:Tile) : Boolean
      {
         if(this.tile_holder_mc.hide_difficulty == "3")
         {
            if(this.current_word.substr(this.word_being_built.length,1) != param1.letter)
            {
               param1 = null;
            }
         }
         else if(param1 != this.tile_holder_mc.tiles_for_word[this.selected_tiles.length])
         {
            param1 = null;
         }
         if(param1)
         {
            this.word_being_built += param1.letter;
            param1.highlighted = true;
            this.selected_tiles.push(param1);
            if(this.word_being_built.length == this.current_word.length)
            {
               this.wordCompleted();
            }
            return true;
         }
         return false;
      }
      
      private function wordCompleted() : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.PLAY_SOUND_EFFECT,new WordCompleted()));
         this.timer_mc.addTime();
         this.score_mc.score += this.current_word.length * 2;
         this.timer_mc.pause();
         this.tile_holder_mc.active = false;
         this.pause_after_word_complete_TMR.reset();
         this.pause_after_word_complete_TMR.start();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.show_game_over = false;
         this.addEventListener(SuzySowEvent.TILE_CLICKED,this.onTileClicked);
         this.show_word_btn.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
         this.addEventListener(SuzySowEvent.TIME_EXPIRED,this.onTimeExpired);
         this.pause_after_word_complete_TMR.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPauseAfterWordComplete);
         this.addEventListener(SuzySowEvent.PLAY_GAME,this.onPlayGame);
         this.addEventListener(PauseEvent.END_PAUSE,this.onEndPause);
      }
      
      private function onEndPause(param1:PauseEvent) : void
      {
         this.endPause();
         this.active = true;
         this.timer_mc.resume();
         this.tile_holder_mc.hide_letters = false;
      }
      
      private function onPause(param1:Event) : void
      {
         trace("SS:onPause: ");
         this.addPause(this.unpause_btn);
         this.active = false;
         this.timer_mc.pause();
         this.tile_holder_mc.hide_letters = true;
      }
      
      private function onPlayGame(param1:SuzySowEvent) : void
      {
         this.playGame();
      }
      
      private function onPauseAfterWordComplete(param1:TimerEvent) : void
      {
         this.giveWord();
      }
      
      private function onButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         switch(param1.target)
         {
            case this.show_word_btn:
               this.showCurrentWord(false);
         }
      }
      
      private function onTileClicked(param1:SuzySowEvent) : void
      {
         var _loc3_:Tile = null;
         var _loc2_:Tile = Tile(param1.target);
         if(this.tile_holder_mc.hide_difficulty == "3")
         {
            if(this.selected_tiles.length > 0)
            {
               _loc3_ = Tile(this.selected_tiles[this.selected_tiles.length - 1]);
               if(!(Math.abs(_loc3_.row - _loc2_.row) == 1 && Math.abs(_loc3_.column - _loc2_.column) == 0 || Math.abs(_loc3_.row - _loc2_.row) == 0 && Math.abs(_loc3_.column - _loc2_.column) == 1))
               {
                  _loc2_ = null;
               }
            }
            if(_loc2_)
            {
               if(!this.add_letter_to_word_being_built(_loc2_))
               {
                  this.killSelectedTiles();
                  this.add_letter_to_word_being_built(_loc2_);
               }
            }
            else
            {
               this.killSelectedTiles();
            }
         }
         else if(!this.add_letter_to_word_being_built(_loc2_))
         {
            this.killSelectedTiles();
            this.add_letter_to_word_being_built(_loc2_);
         }
      }
      
      private function onWordDisplayerCompelte(param1:Event) : void
      {
         WordDisplayer(param1.target).removeEventListener(Event.COMPLETE,this.onWordDisplayerCompelte);
         WordDisplayer(param1.target).removeEventListener(Event.COMPLETE,this.onWordDiplayerCompleteNotNewWord);
         this.timer_mc.resume();
         this.active = true;
         this.tile_holder_mc.hide_letters = false;
         this.tile_holder_mc.word = this.current_word;
         this.tile_holder_mc.active = this.show_word_btn.enabled = true;
         this.word_displayer = null;
      }
      
      private function onWordDiplayerCompleteNotNewWord(param1:Event) : void
      {
         WordDisplayer(param1.target).removeEventListener(Event.COMPLETE,this.onWordDiplayerCompleteNotNewWord);
         WordDisplayer(param1.target).removeEventListener(Event.COMPLETE,this.onWordDisplayerCompelte);
         this.timer_mc.resume();
         this.active = true;
         this.tile_holder_mc.hide_letters = false;
         this.tile_holder_mc.active = this.show_word_btn.enabled = true;
         this.word_displayer = null;
      }
      
      private function onTimeExpired(param1:SuzySowEvent) : void
      {
         this.gameOver();
      }
   }
}

