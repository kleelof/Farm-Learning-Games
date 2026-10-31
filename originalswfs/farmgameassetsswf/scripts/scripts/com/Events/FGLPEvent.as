package com.Events
{
   import flash.events.Event;
   
   public class FGLPEvent extends Event
   {
      
      public static const GOTO_GAME:String = "gotoGame";
      
      public static const GAME_HIDDEN:String = "gameHidden";
      
      public static const PLAY_SOUND_EFFECT:String = "playSOundEffect";
      
      public static const CLICK_SOUND:String = "clickSound";
      
      public var data:Object;
      
      public function FGLPEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new FGLPEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("FGLPEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

