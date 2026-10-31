package com.Games.GaryGoat
{
   import com.Events.*;
   import com.Games.Game;
   import com.Games.GaryGoat.instructions.*;
   import com.UI.controlsPanel.ControlsPanel;
   import com.UI.pausing.UnPauseBTN;
   import com.classes.Config;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol181")]
   public class GaryGoat extends Game
   {
      
      public var game_mc:MovieClip;
      
      public var controls_mc:ControlsPanel;
      
      public var title_mc:MovieClip;
      
      public var game_over_mc:GGGameOver;
      
      private var words:Array;
      
      private var _active:Boolean = false;
      
      public var TargetGroupSelector_mc:TargetGroupSelector;
      
      private var gary_mc:Gary;
      
      private var farmer_mc:Farmer;
      
      private var score_mc:GGScoreBoard;
      
      private var target_group_txt:TextField;
      
      private var dead_goats_mc:DeadGoats;
      
      private var pause_btn:SimpleButton;
      
      private var unpause_btn:UnPauseBTN = new GGUnPauseBTN();
      
      public var instructions_mc:GGInstructions;
      
      public function GaryGoat()
      {
         trace("GaryGoat");
         super();
         this.controls_mode = ControlsPanel.MODE_LEFT;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.gary_mc = this.game_mc.gary_mc;
         this.farmer_mc = this.game_mc.farmer_mc;
         this.score_mc = this.game_mc.score_mc;
         this.target_group_txt = this.game_mc.target_group_txt;
         this.dead_goats_mc = this.game_mc.dead_goats_mc;
         this.pause_btn = this.game_mc.pause_btn;
         this.show_game_over = false;
      }
      
      override protected function startGame() : void
      {
         super.startGame();
         if(!this.TargetGroupSelector_mc.target_groups)
         {
            this.processXML();
         }
         this.game_mc.dispatchEvent(new GaryGoatEvent(GaryGoatEvent.CLEAR_ALL));
         this.pause_btn.enabled = false;
         this.show_game_over = false;
      }
      
      override protected function killGame() : void
      {
         this.TargetGroupSelector_mc.hide();
         this.active = false;
         this.show_game_over = false;
         this.game_mc.dispatchEvent(new GaryGoatEvent(GaryGoatEvent.KILL));
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         this.pause_btn.enabled = param1;
         var _loc2_:String = GaryGoatEvent.PAUSE_PLAY;
         if(param1)
         {
            _loc2_ = GaryGoatEvent.RESUME_PALY;
         }
         this.game_mc.dispatchEvent(new GaryGoatEvent(_loc2_,null,true));
         if(param1)
         {
            this.pause_btn.addEventListener(MouseEvent.CLICK,this.onPauseClicked);
         }
         else
         {
            this.pause_btn.removeEventListener(MouseEvent.CLICK,this.onPauseClicked);
         }
      }
      
      private function set show_game_over(param1:Boolean) : void
      {
         if(param1)
         {
            this.addChild(this.game_over_mc);
         }
         else if(this.game_over_mc.parent)
         {
            this.game_over_mc.parent.removeChild(this.game_over_mc);
         }
      }
      
      private function processXML() : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc1_:XML = Config.getXML("GaryGoat");
         this.TargetGroupSelector_mc.target_groups = new Array();
         this.words = new Array();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_.TargetGroup)
         {
            this.TargetGroupSelector_mc.target_groups.push(String(_loc3_.@title));
            for each(_loc4_ in _loc3_.target)
            {
               this.farmer_mc.words_pool.push(new TargetWord(_loc4_,String(_loc3_.@title)));
            }
         }
         this.TargetGroupSelector_mc.init();
      }
      
      private function newGame() : void
      {
         this.dead_goats_mc.count = 0;
         this.score_mc.score = 0;
         this.active = true;
      }
      
      private function killGary(param1:TargetWord) : void
      {
         ++this.dead_goats_mc.count;
         param1.flyAway(this.dead_goats_mc.x + (this.dead_goats_mc.width - param1.width) / 2,this.dead_goats_mc.y + this.dead_goats_mc.height,Boolean(this.dead_goats_mc.count != 3));
         this.active = false;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(GaryGoatEvent.INSTRUCTIONS_COMPLETE,this.onInstructionsComplete);
         this.addEventListener(GaryGoatEvent.EAT_WORD,this.onEatWord);
         this.addEventListener(GaryGoatEvent.WORD_HIT_GROUND,this.onWordHitGround);
         this.addEventListener(GaryGoatEvent.GAME_OVER,this.onGameOver);
         this.addEventListener(GaryGoatEvent.START_PLAY,this.onStartPlay);
         this.addEventListener(GaryGoatEvent.PLAY_AGAIN,this.onPlayAgain);
         this.addEventListener(PauseEvent.END_PAUSE,this.onEndPause);
         this.addEventListener(GaryGoatEvent.BAD_WORD_CLEARED,this.onBadWordCleared);
      }
      
      private function onBadWordCleared(param1:GaryGoatEvent) : void
      {
         this.active = true;
      }
      
      private function onEndPause(param1:Event) : void
      {
         this.endPause();
         this.active = true;
      }
      
      private function onPauseClicked(param1:MouseEvent) : void
      {
         this.active = false;
         this.addPause(this.unpause_btn);
      }
      
      private function onInstructionsComplete(param1:GaryGoatEvent) : void
      {
         this.TargetGroupSelector_mc.show();
      }
      
      private function onStartPlay(param1:GaryGoatEvent = null) : void
      {
         this.target_group_txt.text = this.TargetGroupSelector_mc.target_group;
         this.newGame();
      }
      
      private function onEatWord(param1:GaryGoatEvent) : void
      {
         var _loc2_:TargetWord = TargetWord(param1.data);
         if(_loc2_.target_group == this.TargetGroupSelector_mc.target_group)
         {
            this.gary_mc.eat();
            _loc2_.flyAway(this.score_mc.x,this.score_mc.y);
            this.score_mc.score += 1 * int(this.farmer_mc.score_multiplier);
         }
         else
         {
            this.gary_mc.refuseWord();
            this.killGary(_loc2_);
         }
      }
      
      private function onWordHitGround(param1:GaryGoatEvent) : void
      {
         var _loc2_:TargetWord = TargetWord(param1.data);
         if(_loc2_.target_group == this.TargetGroupSelector_mc.target_group)
         {
            this.killGary(_loc2_);
         }
         else
         {
            _loc2_.remove();
         }
      }
      
      private function onGameOver(param1:GaryGoatEvent) : void
      {
         this.active = false;
         this.show_game_over = true;
      }
      
      private function onPlayAgain(param1:GaryGoatEvent) : void
      {
         this.startGame();
      }
   }
}

