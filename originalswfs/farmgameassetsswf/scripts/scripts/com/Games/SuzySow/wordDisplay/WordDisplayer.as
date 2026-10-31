package com.Games.SuzySow.wordDisplay
{
   import com.Events.FGLPEvent;
   import com.Games.SuzySow.tileHolder.Tile;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol15")]
   public class WordDisplayer extends MovieClip
   {
      
      private var tiles_holder:Sprite;
      
      private var letter_NDX:int;
      
      private var _word:String;
      
      private var _active:Boolean;
      
      public var ok_btn:SimpleButton;
      
      public function WordDisplayer(param1:String)
      {
         super();
         this.tiles_holder = Sprite(this.addChild(new Sprite()));
         this.word = param1;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function kill() : void
      {
         this.ok_btn.removeEventListener(MouseEvent.CLICK,this.onButtonClicked);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get word() : String
      {
         return this._word;
      }
      
      public function set word(param1:String) : void
      {
         var _loc3_:Tile = null;
         this._word = param1;
         this.letter_NDX = 0;
         while(this.tiles_holder.numChildren > 0)
         {
            this.tiles_holder.removeChildAt(0);
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = Tile(this.tiles_holder.addChild(new Tile(56,param1.substr(_loc2_,1))));
            _loc3_.x = (this.tiles_holder.numChildren - 1) * (_loc3_.width + 5);
            _loc2_++;
         }
         this.tiles_holder.x = (this.width - this.tiles_holder.width) / 2;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.x = (this.parent.width - this.width) / 2;
         this.y = (this.parent.height - this.height) / 2;
         this.ok_btn.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
      }
      
      private function onButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new FGLPEvent(FGLPEvent.CLICK_SOUND));
         switch(param1.target)
         {
            case this.ok_btn:
               dispatchEvent(new Event(Event.COMPLETE));
               this.kill();
         }
      }
   }
}

