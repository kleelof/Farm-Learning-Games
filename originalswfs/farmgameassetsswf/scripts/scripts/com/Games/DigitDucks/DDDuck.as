package com.Games.DigitDucks
{
   import com.Events.DigitDucksEvent;
   import com.Events.FGLPEvent;
   import com.Games.DigitDucks.duckPen.DuckPen;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol53")]
   public class DDDuck extends MovieClip
   {
      
      private static const NW:String = "walkNW";
      
      private static const NE:String = "walkNE";
      
      private static const SW:String = "walkSW";
      
      private static const SE:String = "walkSE";
      
      public var duck_mc:MovieClip;
      
      public var digit:String;
      
      private var area:Rectangle;
      
      private var pen:DuckPen;
      
      private var drop_y:int;
      
      private var drop_speed:int = 5;
      
      private var walk_speed:int = 1;
      
      private var walk_tmr:Timer = new Timer(50,0);
      
      private var _current_direction:String;
      
      private var _active:Boolean;
      
      public var digit_txt:TextField;
      
      public function DDDuck(param1:String, param2:Rectangle, param3:DuckPen)
      {
         super();
         addFrameScript(0,this.frame1);
         this.digit = this.digit_txt.text = param1;
         this.area = param2.clone();
         this.pen = param3;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function returnToPen() : void
      {
         if(this.x < this.area.x || this.y < this.area.y || this.x > this.area.x + this.area.width || this.y > this.area.y + this.area.height)
         {
            TweenMax.to(this,0.3,{
               "x":Math.floor(Math.random() * this.area.width) + this.area.x,
               "y":Math.floor(Math.random() * this.area.height) + this.area.y,
               "ease":Linear.easeNone,
               "onComplete":this.randomlyStartWalking
            });
         }
         else
         {
            this.randomlyStartWalking();
         }
      }
      
      public function kill() : void
      {
         this.active = false;
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameDrop);
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         this.pen.removeEventListener(DigitDucksEvent.KILL_DUCKS,this.onKillDucks);
         this.walk_tmr.removeEventListener(TimerEvent.TIMER,this.onEnterFrameWalk);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get current_direction() : String
      {
         return this._current_direction;
      }
      
      public function set current_direction(param1:String) : void
      {
         this._current_direction = param1;
         this.gotoAndStop(param1);
         this.duck_mc.gotoAndPlay("walk");
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
            if(this.duck_mc)
            {
               this.duck_mc.gotoAndPlay("walk");
               this.walk_tmr.start();
            }
            this.buttonMode = true;
            this.addEventListener(MouseEvent.MOUSE_DOWN,this.onGrabbed);
         }
         else
         {
            if(this.duck_mc)
            {
               this.duck_mc.gotoAndPlay("idle");
               this.walk_tmr.stop();
            }
            this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onGrabbed);
         }
      }
      
      private function randomlyStartWalking() : void
      {
         this.current_direction = new Array(NW,NE,SW,SE)[Math.floor(Math.random() * 4)];
         this.active = true;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.area.width -= this.width;
         this.area.height -= this.height;
         this.gotoAndStop("grabbed");
         this.x = Math.floor(Math.random() * this.area.width) + this.area.x;
         this.drop_y = Math.floor(Math.random() * this.area.height) + this.area.y;
         var _loc2_:MovieClip = MovieClip(this.addChild(new MovieClip()));
         _loc2_.graphics.beginFill(0,0);
         _loc2_.graphics.drawRect(0,0,this.width,this.height);
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameDrop);
         this.pen.addEventListener(DigitDucksEvent.KILL_DUCKS,this.onKillDucks);
         this.walk_tmr.addEventListener(TimerEvent.TIMER,this.onEnterFrameWalk);
         this.active = true;
      }
      
      private function onSetActive(param1:DigitDucksEvent) : void
      {
         param1.stopImmediatePropagation();
         this.active = Boolean(param1.data);
      }
      
      private function onKillDucks(param1:DigitDucksEvent) : void
      {
         param1.stopImmediatePropagation();
         this.kill();
      }
      
      private function onEnterFrameDrop(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.active)
         {
            _loc2_ = this.y + this.drop_speed;
            if(_loc2_ > this.drop_y)
            {
               _loc2_ = this.drop_y;
               this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameDrop);
               this.randomlyStartWalking();
               dispatchEvent(new DigitDucksEvent(DigitDucksEvent.DUCK_ADDED_TO_PEN));
            }
            this.y = _loc2_;
         }
      }
      
      private function onEnterFrameWalk(param1:Event) : void
      {
         var _loc4_:Array = null;
         var _loc2_:int = this.x;
         var _loc3_:int = this.y;
         switch(this.current_direction)
         {
            case NW:
               _loc2_ -= this.walk_speed;
               _loc3_ -= this.walk_speed;
               break;
            case NE:
               _loc2_ += this.walk_speed;
               _loc3_ -= this.walk_speed;
               break;
            case SW:
               _loc2_ -= this.walk_speed;
               _loc3_ += this.walk_speed;
               break;
            case SE:
               _loc2_ += this.walk_speed;
               _loc3_ += this.walk_speed;
         }
         if(_loc2_ > this.area.x + this.area.width)
         {
            _loc4_ = new Array(NW,SW);
         }
         if(_loc2_ < this.area.x)
         {
            _loc4_ = new Array(NE,SE);
         }
         if(_loc3_ > this.area.y + this.area.height)
         {
            _loc4_ = new Array(NW,NE);
         }
         if(_loc3_ < this.area.y)
         {
            _loc4_ = new Array(SW,SE);
         }
         if(_loc4_)
         {
            this.current_direction = _loc4_[Math.floor(Math.random() * _loc4_.length)];
         }
         else
         {
            this.x = _loc2_;
            this.y = _loc3_;
         }
      }
      
      private function onReleased(param1:MouseEvent) : void
      {
         this.stopDrag();
         this.removeEventListener(MouseEvent.MOUSE_UP,this.onReleased);
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragged);
         if(this.hitTestObject(DDGlobals.target_digit))
         {
            dispatchEvent(new DigitDucksEvent(DigitDucksEvent.DUCK_DROPPED_ON_DIGIT));
         }
         else
         {
            this.returnToPen();
         }
      }
      
      private function onGrabbed(param1:MouseEvent) : void
      {
         this.active = false;
         this.gotoAndStop("grab");
         dispatchEvent(new FGLPEvent(FGLPEvent.PLAY_SOUND_EFFECT,new grabDuck()));
         this.parent.addChild(this);
         this.startDrag(false,new Rectangle(0,0,this.parent.width,this.parent.height));
         this.addEventListener(MouseEvent.MOUSE_UP,this.onReleased);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragged);
      }
      
      private function onDragged(param1:MouseEvent) : void
      {
         if(this.hitTestObject(DDGlobals.target_digit))
         {
            DDGlobals.target_digit.hightlight = true;
         }
         else
         {
            DDGlobals.target_digit.hightlight = false;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

