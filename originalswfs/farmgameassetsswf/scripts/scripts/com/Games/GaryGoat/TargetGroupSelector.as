package com.Games.GaryGoat
{
   import com.Events.*;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol119")]
   public class TargetGroupSelector extends MovieClip
   {
      
      public var group_1:TargetGroupPanel;
      
      public var group_2:TargetGroupPanel;
      
      public var group_3:TargetGroupPanel;
      
      public var target_groups:Array;
      
      public var target_group:String;
      
      private var hide_y:int;
      
      private var show_y:int = 200;
      
      private var _selected_group_panel:TargetGroupPanel;
      
      public var start_btn:SimpleButton;
      
      public function TargetGroupSelector()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function init() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= this.target_groups.length)
         {
            TargetGroupPanel(this.getChildByName("group_" + String(_loc1_))).text_txt.text = String(this.target_groups[_loc1_ - 1]);
            _loc1_++;
         }
         this.selected_group_panel = TargetGroupPanel(this.getChildByName("group_1"));
         this.addEventListener(GaryGoatEvent.GROUP_SELECTED,this.onGroupSelected);
         this.start_btn.addEventListener(MouseEvent.CLICK,this.onStartButtonClicked);
      }
      
      public function show() : void
      {
         this.hide_y = y;
         TweenMax.to(this,1,{"y":this.show_y});
      }
      
      public function hide() : void
      {
         if(this.y < this.hide_y)
         {
            TweenMax.to(this,0.5,{
               "y":this.hide_y,
               "onComplete":this.onHidden
            });
         }
      }
      
      public function get selected_group_panel() : TargetGroupPanel
      {
         return this._selected_group_panel;
      }
      
      public function set selected_group_panel(param1:TargetGroupPanel) : void
      {
         if(this._selected_group_panel)
         {
            this._selected_group_panel.selected = false;
         }
         this._selected_group_panel = param1;
         this._selected_group_panel.selected = true;
         this.target_group = this._selected_group_panel.text_txt.text;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.hide_y = this.y;
         this.start_btn.addEventListener(MouseEvent.CLICK,this.onStartButtonClicked);
      }
      
      private function onGroupSelected(param1:GaryGoatEvent) : void
      {
         this.selected_group_panel = TargetGroupPanel(param1.target);
         this.selected_group_panel.selected = true;
      }
      
      private function onStartButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         this.hide();
      }
      
      private function onHidden() : void
      {
         dispatchEvent(new GaryGoatEvent(GaryGoatEvent.START_PLAY));
      }
   }
}

