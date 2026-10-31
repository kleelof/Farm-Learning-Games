package com.Games.DigitDucks.duckPen
{
   import com.Games.DigitDucks.DDDuck;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class DuckPen extends MovieClip
   {
      
      private var client:MovieClip;
      
      private var area:Rectangle;
      
      private var add_duck_TMR:Timer = new Timer(2000,1);
      
      private var ducks:Array = new Array();
      
      private var _active:Boolean;
      
      private var _hide:Boolean;
      
      public function DuckPen(param1:MovieClip, param2:Rectangle)
      {
         super();
         this.client = param1;
         this.area = param2;
         this.add_duck_TMR.addEventListener(TimerEvent.TIMER_COMPLETE,this.onAddDuckTMRComplete);
      }
      
      public function start() : void
      {
         var _loc1_:DDDuck = null;
         for each(_loc1_ in this.ducks)
         {
            _loc1_.kill();
         }
         this.ducks = new Array();
         this.dropDuck();
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:DDDuck = null;
         this._active = param1;
         for each(_loc2_ in this.ducks)
         {
            _loc2_.active = param1;
         }
         if(param1)
         {
            this.add_duck_TMR.reset();
            this.add_duck_TMR.start();
         }
         else
         {
            this.add_duck_TMR.stop();
         }
      }
      
      public function get hide() : Boolean
      {
         return this._hide;
      }
      
      public function set hide(param1:Boolean) : void
      {
         var _loc3_:DDDuck = null;
         this._hide = param1;
         var _loc2_:Boolean = true;
         if(param1)
         {
            _loc2_ = false;
         }
         for each(_loc3_ in this.ducks)
         {
            _loc3_.visible = _loc2_;
         }
      }
      
      private function dropDuck() : void
      {
         this.add_duck_TMR.reset();
         this.add_duck_TMR.start();
         this.ducks.push(this.client.addChild(new DDDuck(String(Math.floor(Math.random() * 9)),this.area,this)));
      }
      
      private function onAddDuckTMRComplete(param1:TimerEvent) : void
      {
         this.dropDuck();
      }
   }
}

