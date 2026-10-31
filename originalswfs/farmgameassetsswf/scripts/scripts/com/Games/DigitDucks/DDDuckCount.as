package com.Games.DigitDucks
{
   import com.Events.DigitDucksEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol73")]
   public class DDDuckCount extends MovieClip
   {
      
      public var max_ducks:int = 0;
      
      private var _count:int;
      
      public var text_txt:TextField;
      
      public function DDDuckCount()
      {
         super();
         this.count = -1;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
         if(param1 < 0)
         {
            this.text_txt.text = "";
         }
         else if(param1 == 1)
         {
            this.text_txt.text = "There is 1 of " + String(this.max_ducks) + " ducks in the pen!";
         }
         else
         {
            this.text_txt.text = "There are " + String(param1) + " of " + String(this.max_ducks) + " ducks in the pen!";
         }
         if(param1 == this.max_ducks)
         {
            dispatchEvent(new DigitDucksEvent(DigitDucksEvent.PEN_FULL));
         }
      }
   }
}

