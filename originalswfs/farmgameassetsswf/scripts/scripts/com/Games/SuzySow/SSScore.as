package com.Games.SuzySow
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol231")]
   public class SSScore extends MovieClip
   {
      
      private var _score:int;
      
      public var text_txt:TextField;
      
      public function SSScore()
      {
         super();
         this.score = 0;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function set score(param1:int) : void
      {
         this._score = param1;
         this.text_txt.text = String(param1);
      }
   }
}

