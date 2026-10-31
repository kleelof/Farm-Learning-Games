package com.Games.GaryGoat
{
   import com.Events.GaryGoatEvent;
   import com.greensock.TweenMax;
   import com.greensock.easing.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol29")]
   public class TargetWord extends MovieClip
   {
      
      public var target_group:String;
      
      private var bottom:int = 550;
      
      private var speed:int = 3;
      
      private var resume_after_flyaway:Boolean = false;
      
      private var _active:Boolean = false;
      
      public var text_txt:TextField;
      
      public function TargetWord(param1:XML, param2:String)
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         this.target_group = param2;
         this.text_txt.autoSize = "left";
         this.text_txt.text = String(param1.@word).toLowerCase();
         this.text_txt.x = 1 - this.text_txt.width / 2;
         this.text_txt.y = 1;
         this.graphics.beginFill(13338145,0.8);
         this.graphics.drawRoundRect(1 - this.text_txt.width / 2,0,this.text_txt.width + 2,this.text_txt.height,10);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function flyAway(param1:int, param2:int, param3:Boolean = false) : void
      {
         this.resume_after_flyaway = param3;
         TweenMax.to(this,0.5,{
            "x":param1,
            "y":param2,
            "ease":Strong.easeInOut,
            "onComplete":this.onFlyAwayComplete
         });
      }
      
      public function remove() : *
      {
         this.onRemoveMe();
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
            this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         else
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.parent.addEventListener(GaryGoatEvent.PAUSE_PLAY,this.onPausePlay);
         this.parent.addEventListener(GaryGoatEvent.RESUME_PALY,this.onResumePlay);
         this.parent.addEventListener(GaryGoatEvent.CLEAR_ALL,this.onClearAll);
         this.parent.addEventListener(GaryGoatEvent.KILL,this.onRemoveMe);
         this.active = true;
      }
      
      private function onClearAll(param1:GaryGoatEvent) : void
      {
         this.remove();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
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
         this.y += this.speed;
         if(this.y >= this.bottom)
         {
            this.active = false;
            dispatchEvent(new GaryGoatEvent(GaryGoatEvent.WORD_HIT_GROUND,this));
         }
      }
      
      private function onFlyAwayComplete() : void
      {
         if(this.resume_after_flyaway)
         {
            this.filters = new Array(new GlowFilter(16711680,1,10));
            TweenMax.to(this,2,{
               "x":this.x,
               "onComplete":this.onHoldComplete
            });
         }
         else
         {
            this.onRemoveMe();
         }
      }
      
      private function onHoldComplete() : void
      {
         dispatchEvent(new GaryGoatEvent(GaryGoatEvent.BAD_WORD_CLEARED));
         this.onRemoveMe();
      }
      
      private function onRemoveMe(param1:Event = null) : void
      {
         this.parent.removeEventListener(GaryGoatEvent.PAUSE_PLAY,this.onPausePlay);
         this.parent.removeEventListener(GaryGoatEvent.RESUME_PALY,this.onResumePlay);
         this.parent.removeEventListener(GaryGoatEvent.CLEAR_ALL,this.onClearAll);
         this.parent.removeChild(this);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

