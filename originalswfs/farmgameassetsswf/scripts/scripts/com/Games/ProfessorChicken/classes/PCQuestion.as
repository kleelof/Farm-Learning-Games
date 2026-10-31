package com.Games.ProfessorChicken.classes
{
   public class PCQuestion
   {
      
      public var question_text:String;
      
      public var answers:Array = new Array();
      
      public var correct_answer:String;
      
      public function PCQuestion(param1:XML)
      {
         var _loc2_:XML = null;
         super();
         this.question_text = String(param1.question_text);
         for each(_loc2_ in param1.answer)
         {
            this.answers.push(String(_loc2_));
            if(String(_loc2_.@c).toUpperCase() == "TRUE")
            {
               this.correct_answer = String(_loc2_);
            }
         }
      }
   }
}

