package com.Events
{
   import flash.events.Event;
   
   public class UIEvent extends Event
   {
      
      public static const GO_HOME_CLICKED:String = "goHomeclicked";
      
      public static const MUTE_MUSIC:String = "muteMusic";
      
      public static const UNMUTE_MUSIC:String = "unMuteMusic";
      
      public static const TOGGLE_SCREEEN:String = "toggleScreen";
      
      public var data:Object;
      
      public function UIEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new UIEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("UIEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

