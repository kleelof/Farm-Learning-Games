package com.Games.GaryGoat
{
   import com.Events.GaryGoatEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol145")]
   public class DeadGoats extends MovieClip
   {
      
      private var _count:int = 0;
      
      private var messages:Array = new Array("Well","Queasy","Sick","");
      
      public var text_txt:TextField;
      
      public function DeadGoats()
      {
         super();
         this.count = 0;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
         this.gotoAndStop("f_" + String(param1));
         this.text_txt.text = String(this.messages[param1]);
         if(param1 == 3)
         {
            dispatchEvent(new GaryGoatEvent(GaryGoatEvent.GAME_OVER));
         }
      }
   }
}

