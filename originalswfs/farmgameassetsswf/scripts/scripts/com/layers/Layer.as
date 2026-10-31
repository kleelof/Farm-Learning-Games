package com.layers
{
   import com.Events.LayerEvent;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Layer extends MovieClip
   {
      
      protected var page_width:int;
      
      private var current_page:int = 1;
      
      private var easing:Object;
      
      public function Layer(param1:int, param2:Object)
      {
         super();
         this.page_width = param1;
         this.easing = param2;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function set page(param1:int) : void
      {
         trace("page: ",param1);
         param1--;
         var _loc2_:Number = param1 - this.current_page;
         if(this.current_page > param1)
         {
            _loc2_ = this.current_page - param1;
         }
         TweenMax.to(this,2 * _loc2_,{
            "x":0 - param1 * this.page_width,
            "ease":this.easing,
            "onComplete":this.onLayerInPlace
         });
         this.current_page = param1;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.parent.addEventListener(LayerEvent.GOTO_PAGE,this.onGotoPage);
      }
      
      private function onGotoPage(param1:LayerEvent) : void
      {
         this.page = int(param1.data);
      }
      
      private function onLayerInPlace() : void
      {
         dispatchEvent(new LayerEvent(LayerEvent.LAYER_IN_PLACE));
      }
   }
}

