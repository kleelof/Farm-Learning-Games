package com.Events
{
   import flash.events.Event;
   
   public class ProfChixEvent extends Event
   {
      
      public static const START_GAME:String = "startGame";
      
      public static const ANSWER_CLICKED:String = "answerClicked";
      
      public static const NEXT_QUESTION:String = "nextQuestion";
      
      public static const PLAY_AGAIN:String = "playAgain";
      
      public var data:Object;
      
      public function ProfChixEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new ProfChixEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("ProfChixEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

