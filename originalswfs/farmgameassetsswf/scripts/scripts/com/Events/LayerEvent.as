package com.Events
{
   import flash.events.Event;
   
   public class LayerEvent extends Event
   {
      
      public static const GOTO_PAGE:String = "gotoPage";
      
      public static const LAYER_IN_PLACE:String = "layerInPlace";
      
      public var data:Object;
      
      public function LayerEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new LayerEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("LayerEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

