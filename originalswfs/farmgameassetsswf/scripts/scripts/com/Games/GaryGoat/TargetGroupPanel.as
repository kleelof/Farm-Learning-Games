package com.Games.GaryGoat
{
   import com.Events.GaryGoatEvent;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol113")]
   public class TargetGroupPanel extends MovieClip
   {
      
      public var text_txt:TextField;
      
      public var mouse_over_mc:MovieClip;
      
      private var _selected:Boolean;
      
      private var unselectedColor:uint;
      
      public function TargetGroupPanel()
      {
         super();
         this.unselectedColor = this.text_txt.textColor;
         this.mouse_over_mc.alpha = 0;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.addEventListener(MouseEvent.CLICK,this.onClicked);
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(param1)
         {
            this.text_txt.textColor = 16777215;
         }
         else
         {
            this.text_txt.textColor = this.unselectedColor;
         }
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GaryGoatEvent(GaryGoatEvent.GROUP_SELECTED,this.text_txt.text));
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         TweenMax.to(this.mouse_over_mc,0.2,{"alpha":0});
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         TweenMax.to(this.mouse_over_mc,0.4,{"alpha":1});
      }
   }
}

