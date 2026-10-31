package com.Games.GaryGoat
{
   import com.Events.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol155")]
   public class Farmer extends MovieClip
   {
      
      private static const DIRECTION_LEFT:String = "left";
      
      private static const DIRECTION_RIGHT:String = "right";
      
      public var words_pool:Array = new Array();
      
      public var score_multiplier:Number = 1;
      
      private var speed:int = 2;
      
      private var left:int = 50;
      
      private var right:int = 990;
      
      private var draw_words_pool:Array = new Array();
      
      private var throw_word_time:int = 2000;
      
      private var throw_increments:int = 10;
      
      private var words_thrown:int = 0;
      
      private var throw_word_time_decrement:int = 50;
      
      private var throwTMR:Timer;
      
      private var is_throwing:Boolean = false;
      
      private var _active:Boolean = false;
      
      private var _direction:String;
      
      private var _is_walking:Boolean = false;
      
      public var ani_mc:MovieClip;
      
      public function Farmer()
      {
         super();
         addFrameScript(0,this.frame1);
         this.direction = DIRECTION_RIGHT;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function shuffleWords() : void
      {
         var _loc1_:Array = this.words_pool.slice(0);
         this.draw_words_pool = new Array();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.draw_words_pool[_loc3_] = _loc1_.splice(int(Math.random() * (_loc2_ - _loc3_)),1)[0];
            _loc3_++;
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
            if(this.draw_words_pool.length == 0)
            {
               this.shuffleWords();
            }
            this.throwTMR.reset();
            this.throwTMR.start();
            this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.is_walking = true;
         }
         else
         {
            this.throwTMR.stop();
            this.is_walking = false;
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
         if(param1 == DIRECTION_LEFT)
         {
            this.gotoAndStop("left");
         }
         else
         {
            this.gotoAndStop("right");
         }
      }
      
      public function get is_walking() : Boolean
      {
         return this._is_walking;
      }
      
      public function set is_walking(param1:Boolean) : void
      {
         this._is_walking = param1;
         if(param1)
         {
            this.ani_mc.gotoAndPlay("walk");
         }
         else
         {
            this.ani_mc.gotoAndStop("idle");
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.throwTMR = new Timer(this.throw_word_time,0);
         this.throwTMR.addEventListener(TimerEvent.TIMER,this.onThrowTMRTIX);
         this.parent.addEventListener(GaryGoatEvent.PAUSE_PLAY,this.onPausePlay);
         this.parent.addEventListener(GaryGoatEvent.RESUME_PALY,this.onResumePlay);
         this.parent.addEventListener(GaryGoatEvent.KILL,this.onKill);
         this.addEventListener("RELEASE_WORD",this.onReleaseWord);
         this.addEventListener("THROW_COMPLETE",this.onThrowComplete);
      }
      
      private function onKill(param1:GaryGoatEvent) : void
      {
         this.active = false;
      }
      
      private function onThrowComplete(param1:Event) : void
      {
         this.is_throwing = false;
         this.ani_mc.gotoAndPlay("walk");
      }
      
      private function onReleaseWord(param1:Event) : void
      {
         var _loc2_:TargetWord = TargetWord(this.draw_words_pool.pop());
         _loc2_.x = this.x;
         _loc2_.y = this.y;
         this.parent.addChild(_loc2_);
         ++this.words_thrown;
         if(this.words_thrown == this.throw_increments)
         {
            this.words_thrown = 0;
            --this.throw_increments;
            if(this.throw_increments < 1)
            {
               this.throw_increments = 1;
            }
            if(this.throwTMR.delay - this.throw_word_time_decrement < 50)
            {
               this.throw_word_time_decrement = 0;
            }
            this.throwTMR.delay -= this.throw_word_time_decrement;
            this.score_multiplier += 0.5;
         }
         this.is_throwing = false;
         this.is_walking = true;
         if(this.draw_words_pool.length == 0)
         {
            this.shuffleWords();
         }
      }
      
      private function onResumePlay(param1:GaryGoatEvent) : void
      {
         this.active = true;
      }
      
      private function onPausePlay(param1:GaryGoatEvent) : void
      {
         this.active = false;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(!this.is_throwing)
         {
            _loc2_ = this.x;
            if(this.direction == DIRECTION_LEFT)
            {
               _loc2_ -= this.speed;
            }
            else
            {
               _loc2_ += this.speed;
            }
            if(_loc2_ < this.left + this.width / 2)
            {
               _loc2_ = this.left + this.width / 2;
               this.direction = DIRECTION_RIGHT;
            }
            if(_loc2_ > this.right - this.width / 2)
            {
               _loc2_ = this.right - this.width / 2;
               this.direction = DIRECTION_LEFT;
            }
            this.x = _loc2_;
         }
      }
      
      private function onThrowTMRTIX(param1:TimerEvent = null) : void
      {
         this.is_throwing = true;
         this.is_walking = false;
         this.ani_mc.gotoAndPlay("throw");
         dispatchEvent(new FGLPEvent(FGLPEvent.PLAY_SOUND_EFFECT,new Throw()));
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

