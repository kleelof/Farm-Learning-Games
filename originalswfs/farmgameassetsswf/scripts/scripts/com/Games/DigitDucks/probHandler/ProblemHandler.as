package com.Games.DigitDucks.probHandler
{
   import com.Games.DigitDucks.DDGlobals;
   import com.classes.Config;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ProblemHandler extends MovieClip
   {
      
      private var client:MovieClip;
      
      private var position:Point;
      
      private var problems:Array = new Array();
      
      private var digits:Array = new Array();
      
      private var line_mc:MovieClip;
      
      private var _current_problem:DDProblem;
      
      private var _active:Boolean;
      
      private var _hide:Boolean;
      
      public function ProblemHandler(param1:MovieClip, param2:Point)
      {
         super();
         this.client = param1;
         this.position = param2;
      }
      
      public function next() : void
      {
         if(this.problems.length == 0)
         {
            this.fillProblems();
         }
         this.current_problem = this.problems.pop();
      }
      
      public function revealReplacedDigit() : void
      {
         DDGlobals.target_digit.digit_txt.text = this.current_problem.replaced_digit;
      }
      
      public function get current_problem() : DDProblem
      {
         return this._current_problem;
      }
      
      public function set current_problem(param1:DDProblem) : void
      {
         var _loc4_:DDDigit = null;
         var _loc5_:int = 0;
         var _loc6_:DDDigit = null;
         this._current_problem = param1;
         if(this.digits.length > 0)
         {
            for each(_loc4_ in this.digits)
            {
               _loc4_.remove();
            }
         }
         this.digits = new Array();
         var _loc2_:DDDigit = new DDDigit(" ",new Point(0,0));
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            if(_loc3_ == 1)
            {
               this.digits.push(this.client.addChild(new DDDigit(param1.func,new Point(this.position.x,this.position.y + _loc2_.height * 1))));
            }
            _loc5_ = 0;
            while(_loc5_ < String(param1.lines[_loc3_]).length)
            {
               _loc6_ = new DDDigit(String(param1.lines[_loc3_]).substr(_loc5_,1),new Point(_loc2_.width * _loc5_ + _loc2_.width + this.position.x,_loc2_.height * _loc3_ + this.position.y));
               this.digits.push(this.client.addChild(_loc6_));
               if(_loc6_.digit_type == 0)
               {
                  DDGlobals.target_digit = _loc6_;
               }
               _loc5_++;
            }
            _loc3_++;
         }
         if(!this.line_mc)
         {
            this.line_mc = MovieClip(this.client.addChild(new MovieClip()));
            this.line_mc.x = this.position.x + _loc2_.width;
            this.line_mc.y = this.position.y + _loc2_.height * 2 + 5;
         }
         this.line_mc.graphics.clear();
         this.line_mc.graphics.lineStyle(10,16777215);
         this.line_mc.graphics.moveTo(0,0);
         this.line_mc.graphics.lineTo(_loc2_.width * this.current_problem.longest_line,0);
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:DDDigit = null;
         this._active = param1;
         for each(_loc2_ in this.digits)
         {
            _loc2_.active = param1;
         }
      }
      
      public function get hide() : Boolean
      {
         return this._hide;
      }
      
      public function set hide(param1:Boolean) : void
      {
         var _loc3_:DDDigit = null;
         this._hide = param1;
         var _loc2_:Boolean = true;
         if(param1)
         {
            _loc2_ = false;
         }
         if(this.digits.length > 0)
         {
            for each(_loc3_ in this.digits)
            {
               _loc3_.visible = _loc2_;
            }
         }
      }
      
      private function fillProblems() : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:XML = Config.getXML("DigitDucks");
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_.Problems.problem)
         {
            _loc2_.push(new DDProblem(String(_loc3_.@text)));
         }
         this.problems = new Array();
         _loc4_ = int(_loc2_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            this.problems[_loc5_] = _loc2_.splice(int(Math.random() * (_loc4_ - _loc5_)),1)[0];
            _loc5_++;
         }
      }
   }
}

