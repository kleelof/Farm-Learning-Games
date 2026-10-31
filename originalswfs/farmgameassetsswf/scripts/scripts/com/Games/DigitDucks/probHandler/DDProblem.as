package com.Games.DigitDucks.probHandler
{
   public class DDProblem
   {
      
      public var func:String;
      
      public var lines:Array;
      
      public var longest_line:int;
      
      public var replaced_digit:String;
      
      public function DDProblem(param1:String)
      {
         var _loc2_:Array = null;
         super();
         while(param1.indexOf(" ") > -1)
         {
            param1 = param1.replace(" ","");
         }
         if(param1.indexOf("+") > -1)
         {
            this.lines = param1.split("+");
            this.lines.push(String(int(this.lines[0]) + int(this.lines[1])));
            this.func = "+";
            this.replaceDigit();
            this.formatLines();
         }
         else if(param1.indexOf("*") > -1)
         {
            this.lines = param1.split("*");
            this.lines.push(String(int(this.lines[0]) * int(this.lines[1])));
            this.func = "*";
            this.replaceDigit();
            this.formatLines();
         }
         else if(param1.indexOf("-") > -1)
         {
            this.lines = param1.split("-");
            this.lines.push(String(int(this.lines[0]) - int(this.lines[1])));
            this.func = "-";
            this.replaceDigit();
            this.formatLines();
         }
         else
         {
            this.lines = param1.split("/");
            this.lines.push(int(String(int(this.lines[0]) / int(this.lines[1]))));
            this.func = "/";
            this.replaceDigit();
            this.formatLines();
         }
      }
      
      private function replaceDigit() : void
      {
         var _loc1_:int = Math.floor(Math.random() * 2);
         var _loc2_:int = Math.floor(Math.random() * String(this.lines[_loc1_]).length);
         this.replaced_digit = String(this.lines[_loc1_]).substr(_loc2_,1);
         this.lines[_loc1_] = String(this.lines[_loc1_]).split(this.replaced_digit).join("?");
         trace("---------------",this.replaced_digit,_loc2_,"-------");
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            trace(this.lines[_loc3_]);
            _loc3_++;
         }
      }
      
      private function formatLines() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         this.longest_line = 0;
         for each(_loc1_ in this.lines)
         {
            if(_loc1_.length > this.longest_line)
            {
               this.longest_line = _loc1_.length;
            }
         }
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            while(String(this.lines[_loc2_]).length < this.longest_line)
            {
               this.lines[_loc2_] = " " + this.lines[_loc2_];
            }
            _loc2_++;
         }
      }
   }
}

