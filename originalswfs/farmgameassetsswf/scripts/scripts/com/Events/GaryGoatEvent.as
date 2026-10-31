package com.Events
{
   import flash.events.Event;
   
   public class GaryGoatEvent extends Event
   {
      
      public static const GROUP_SELECTED:String = "groupSelected";
      
      public static const START_PLAY:String = "startPlay";
      
      public static const INSTRUCTIONS_COMPLETE:String = "instructionsComplete";
      
      public static const EAT_WORD:String = "eatWord";
      
      public static const WORD_HIT_GROUND:String = "wordHitGround";
      
      public static const PAUSE_PLAY:String = "pausePlay";
      
      public static const RESUME_PALY:String = "resumePlay";
      
      public static const BAD_WORD_CLEARED:String = "badWordCleared";
      
      public static const GAME_OVER:String = "gameOver";
      
      public static const PLAY_AGAIN:String = "PlayAgain";
      
      public static const CLEAR_ALL:String = "clearAll";
      
      public static const KILL:String = "GGKill";
      
      public var data:Object;
      
      public function GaryGoatEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new GaryGoatEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("GaryGoatEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

