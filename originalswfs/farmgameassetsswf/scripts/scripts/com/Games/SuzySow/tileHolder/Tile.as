package com.Games.SuzySow.tileHolder
{
   import com.Events.FGLPEvent;
   import com.Events.SuzySowEvent;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol18")]
   public class Tile extends MovieClip
   {
      
      public var column:int;
      
      public var row:int;
      
      public var used_by_word:Boolean = false;
      
      public var tested_directions:Array;
      
      private var th_parent:TileHolder;
      
      public var letter_txt:TextField;
      
      private var start_position:Point;
      
      private var _active:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var was_highlighted:Boolean = false;
      
      private var tile_size:int = 65;
      
      public function Tile(param1:int, param2:String, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.tile_size = param1 - 4;
         this.width = this.height = this.tile_size;
         this.letter_txt.x = (this.tile_size - this.letter_txt.width) / 2;
         this.letter_txt.text = param2;
         if(param5 > 0)
         {
            this.row = param4;
            this.column = param3;
            this.tested_directions = new Array();
            if(this.column > 0)
            {
               this.tested_directions.push(new Point(-1,0));
            }
            if(this.column < param5 - 1)
            {
               this.tested_directions.push(new Point(1,0));
            }
            if(this.row > 0)
            {
               this.tested_directions.push(new Point(0,-1));
            }
            if(this.row < param5 - 1)
            {
               this.tested_directions.push(new Point(0,1));
            }
            this.x = (this.tile_size + 4) * param3 + 0;
            this.y = (this.tile_size + 4) * param4 + 0;
         }
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
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
            this.buttonMode = true;
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            this.addEventListener(MouseEvent.CLICK,this.onClicked);
            this.highlighted = false;
         }
         else
         {
            this.buttonMode = false;
            this.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            this.removeEventListener(MouseEvent.CLICK,this.onClicked);
            this.onMouseOut();
         }
      }
      
      public function get letter() : String
      {
         return this.letter_txt.text;
      }
      
      public function set letter(param1:String) : void
      {
         this.letter_txt.text = param1;
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
         if(param1)
         {
            this.active = false;
            this.onMouseOut();
            TweenMax.to(this.letter_txt,0.3,{"textColor":65280});
         }
         else
         {
            TweenMax.to(this.letter_txt,0.3,{"textColor":16777215});
         }
      }
      
      public function set hide_letter(param1:Boolean) : void
      {
         if(param1)
         {
            this.letter_txt.visible = false;
            this.highlighted = false;
         }
         else
         {
            this.letter_txt.visible = true;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         var _loc2_:MovieClip = MovieClip(this.addChild(new MovieClip()));
         _loc2_.graphics.beginFill(16711680,0);
         _loc2_.graphics.drawRoundRect(0,0,this.width,this.height,20);
         this.start_position = new Point(this.x,this.y);
         this.active = false;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.active = false;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         TweenMax.to(this,0.5,{
            "x":this.start_position.x - 5,
            "y":this.start_position.y - 5,
            "dropShadowFilter":{
               "distance":5,
               "blurX":5,
               "blurY":5,
               "angle":45,
               "strength":1
            }
         });
      }
      
      private function onMouseOut(param1:MouseEvent = null) : void
      {
         TweenMax.to(this,0.5,{
            "x":this.start_position.x,
            "y":this.start_position.y,
            "dropShadowFilter":{"distance":0}
         });
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         dispatchEvent(new SuzySowEvent(SuzySowEvent.TILE_CLICKED));
      }
   }
}

