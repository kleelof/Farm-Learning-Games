package com.Games.ProfessorChicken.classes
{
   import com.classes.Config;
   
   public class PCQuestionKeeper
   {
      
      private var questions:Array;
      
      public function PCQuestionKeeper()
      {
         super();
      }
      
      public function initialize() : void
      {
         var _loc1_:XML = null;
         var _loc2_:XML = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!this.questions || this.questions.length == 0)
         {
            this.questions = new Array();
            _loc1_ = Config.getXML("ProfChix");
            for each(_loc2_ in _loc1_.Questions.question)
            {
               this.questions.push(new PCQuestion(_loc2_));
            }
            if(String(_loc1_.Questions.@randomize).toUpperCase() != "FALSE")
            {
               _loc3_ = this.questions.slice(0);
               this.questions = new Array();
               _loc4_ = int(_loc3_.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  this.questions[_loc5_] = _loc3_.splice(int(Math.random() * (_loc4_ - _loc5_)),1)[0];
                  _loc5_++;
               }
            }
         }
      }
      
      public function get next_question() : PCQuestion
      {
         if(this.questions.length == 0)
         {
            this.initialize();
         }
         return this.questions.shift();
      }
   }
}

