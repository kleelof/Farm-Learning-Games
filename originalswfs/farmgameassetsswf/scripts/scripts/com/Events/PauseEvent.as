package com.Events
{
   import flash.events.Event;
   
   public class PauseEvent extends Event
   {
      
      public static const PAUSE:String = "Pause";
      
      public static const END_PAUSE:String = "endPause";
      
      public function PauseEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new PauseEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("PauseEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

