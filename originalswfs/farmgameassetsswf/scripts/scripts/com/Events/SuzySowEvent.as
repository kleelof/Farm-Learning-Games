package com.Events
{
   import flash.events.Event;
   
   public class SuzySowEvent extends Event
   {
      
      public static const TILE_CLICKED:String = "tileClicked";
      
      public static const TIME_EXPIRED:String = "timeExpired";
      
      public static const PLAY_GAME:String = "playgame";
      
      public var data:Object;
      
      public function SuzySowEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new SuzySowEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("SuzySowEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

