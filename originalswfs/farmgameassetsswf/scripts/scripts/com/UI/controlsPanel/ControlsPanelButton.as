package com.UI.controlsPanel
{
   import com.Events.UIEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ControlsPanelButton extends MovieClip
   {
      
      public var active_event:String;
      
      public var inactive_event:String;
      
      private var _active:Boolean = true;
      
      public function ControlsPanelButton()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         if(param1)
         {
            this.gotoAndPlay("active");
            this.buttonMode = Boolean(this.active_event != null);
         }
         else
         {
            this.gotoAndPlay("inactive");
            this.buttonMode = Boolean(this.inactive_event != null);
         }
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         var _loc2_:MovieClip = MovieClip(this.addChild(new MovieClip()));
         _loc2_.graphics.beginFill(0,0);
         _loc2_.graphics.drawRect(0,0,this.width,this.height);
         this.addEventListener(MouseEvent.CLICK,this.onClicked);
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = this.active_event;
         if(this.active == false)
         {
            _loc2_ = this.inactive_event;
         }
         if(_loc2_ != null)
         {
            dispatchEvent(new UIEvent(_loc2_));
         }
         this.active = !this.active;
      }
   }
}

