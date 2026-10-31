package com.Games.GaryGoat
{
   import com.Events.GaryGoatEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol169")]
   public class Gary extends MovieClip
   {
      
      public var ani_mc:MovieClip;
      
      private var head_mc:MovieClip;
      
      private var _active:Boolean = false;
      
      private var _direction:String;
      
      private var _is_walking:Boolean = false;
      
      private var speed:int = 5;
      
      private var left:int = 50;
      
      private var right:int = 990;
      
      private var DIRECTION_LEFT:String = "left";
      
      private var DIRECTION_RIGHT:String = "right";
      
      public function Gary()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function eat() : void
      {
         this.head_mc.gotoAndPlay("eat");
      }
      
      public function refuseWord() : void
      {
         this.head_mc.gotoAndPlay("refuse");
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
            this.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onClick);
         }
         else
         {
            this.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.is_walking = false;
            this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClick);
         }
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(param1 != this._direction)
         {
            this._direction = param1;
            this.gotoAndStop(param1);
         }
      }
      
      public function get is_walking() : Boolean
      {
         return this._is_walking;
      }
      
      public function set is_walking(param1:Boolean) : void
      {
         if(param1 != this._is_walking)
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
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         trace("Gary.onAddedToStage: ");
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.head_mc = MovieClip(this.ani_mc.head_mc);
         this.parent.addEventListener(GaryGoatEvent.PAUSE_PLAY,this.onPausePlay);
         this.parent.addEventListener(GaryGoatEvent.RESUME_PALY,this.onResumePlay);
         this.parent.addEventListener(GaryGoatEvent.KILL,this.onKill);
      }
      
      private function onKill(param1:GaryGoatEvent) : void
      {
         this.active = false;
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
         var _loc2_:int = this.x;
         if(this.parent.mouseX < this.x - 10)
         {
            this.direction = this.DIRECTION_LEFT;
            _loc2_ = this.x - this.speed;
         }
         else if(this.parent.mouseX > this.x + 10)
         {
            this.direction = this.DIRECTION_RIGHT;
            _loc2_ = this.x + this.speed;
         }
         if(_loc2_ < this.left + this.width / 2)
         {
            _loc2_ = this.left + this.width / 2;
         }
         if(_loc2_ > this.right - this.width / 2)
         {
            _loc2_ = this.right - this.width / 2;
         }
         if(this.x != _loc2_ && this.active)
         {
            this.x = _loc2_;
            this.is_walking = true;
         }
         else
         {
            this.is_walking = false;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         while(_loc2_ < this.parent.numChildren)
         {
            _loc3_ = this.parent.getChildAt(_loc2_);
            if(getQualifiedClassName(_loc3_).indexOf("TargetWord") > -1)
            {
               if(_loc3_.hitTestObject(this))
               {
                  this._is_walking = false;
                  dispatchEvent(new GaryGoatEvent(GaryGoatEvent.EAT_WORD,_loc3_));
                  _loc2_ = this.parent.numChildren - 1;
               }
            }
            _loc2_++;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
      }
   }
}

