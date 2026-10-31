package com.Games.SuzySow
{
   import com.Events.SuzySowEvent;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol229")]
   public class SSTimer extends MovieClip
   {
      
      public var total_time:int;
      
      public var add_time:int;
      
      private var tw:TweenMax;
      
      public var milk_mask:MovieClip;
      
      public function SSTimer()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function addTime(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            param1 = this.add_time;
         }
         var _loc2_:int = this.milk_mask.scaleY * this.total_time + param1;
         if(_loc2_ > this.total_time)
         {
            _loc2_ = this.total_time;
         }
         this.milk_mask.scaleY = _loc2_ / this.total_time;
         this.start(_loc2_);
      }
      
      public function reset() : void
      {
         this.milk_mask.scaleY = 1;
      }
      
      public function start(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            param1 = this.total_time;
         }
         this.milk_mask.scaleY = param1 / this.total_time;
         if(this.tw)
         {
            this.tw.kill();
         }
         this.tw = TweenMax.to(this.milk_mask,param1,{
            "scaleY":0,
            "ease":Linear.easeNone,
            "onComplete":this.onTimeExpired
         });
      }
      
      public function pause() : void
      {
         this.tw.pause();
      }
      
      public function resume() : void
      {
         this.start(this.time_remianing);
      }
      
      public function kill() : void
      {
         this.tw.kill();
      }
      
      private function get time_remianing() : int
      {
         return int(this.milk_mask.scaleY * this.total_time);
      }
      
      private function setTimer(param1:int) : void
      {
         this.milk_mask.scaleY = param1 / this.total_time;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onTimeExpired() : void
      {
         dispatchEvent(new SuzySowEvent(SuzySowEvent.TIME_EXPIRED));
      }
   }
}

