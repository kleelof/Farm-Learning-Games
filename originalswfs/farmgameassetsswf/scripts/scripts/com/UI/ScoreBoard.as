package com.UI
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ScoreBoard extends MovieClip
   {
      
      private var _score:int;
      
      private var score_txt:TextField;
      
      public function ScoreBoard()
      {
         super();
         this.score_txt = TextField(this.getChildByName("score_txt"));
      }
      
      public function reset() : void
      {
         this.score = 0;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function set score(param1:int) : void
      {
         this._score = param1;
         this.score_txt.text = String(param1);
      }
   }
}

