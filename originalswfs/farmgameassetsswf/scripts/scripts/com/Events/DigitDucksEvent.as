package com.Events
{
   import flash.events.Event;
   
   public class DigitDucksEvent extends Event
   {
      
      public static const DUCK_ADDED_TO_PEN:String = "duckAddedToPen";
      
      public static const KILL_DUCKS:String = "killDucks";
      
      public static const DUCK_DROPPED_ON_DIGIT:String = "duckDroppedOnDigit";
      
      public static const PEN_FULL:String = "penFull";
      
      public static const PLAY_AGAIN:String = "DDPlayAgain";
      
      public var data:Object;
      
      public function DigitDucksEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new DigitDucksEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("DigitDucksEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

