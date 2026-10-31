package com.Games
{
   import com.Events.FGLPEvent;
   import com.UI.Instructions;
   import com.UI.controlsPanel.ControlsPanel;
   import com.UI.pausing.UnPauseBTN;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Game extends MovieClip
   {
      
      public static const MODE_IDLE:String = "idle";
      
      public static const MODE_PLAYING:String = "playing";
      
      public static const MODE_START:String = "start";
      
      public var game_number:int;
      
      private var controls_mc:ControlsPanel;
      
      private var title_mc:MovieClip;
      
      private var game_mc:MovieClip;
      
      private var instructions_mc:Instructions;
      
      private var click_screen_mc:MovieClip;
      
      private var _mode:String;
      
      private var _show_controls:Boolean = false;
      
      private var _fade_between_transitions:Boolean = true;
      
      public function Game()
      {
         super();
         trace("Game: ");
         this.game_number = int(this.name.substr(2,1));
         this.controls_mc = ControlsPanel(this.getChildByName("controls_mc"));
         this.title_mc = MovieClip(this.getChildByName("title_mc"));
         this.game_mc = MovieClip(this.getChildByName("game_mc"));
         if(this.game_mc)
         {
            this.game_mc.alpha = 0;
            this.instructions_mc = Instructions(this.game_mc.getChildByName("instructions_mc"));
         }
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      protected function startGame() : void
      {
         this._show_controls = true;
         this.show_instructions = true;
      }
      
      protected function killGame() : void
      {
      }
      
      protected function addPause(param1:UnPauseBTN) : void
      {
         if(!this.click_screen_mc)
         {
            this.click_screen_mc = new MovieClip();
            this.click_screen_mc.graphics.beginFill(0,0);
            this.click_screen_mc.graphics.drawRect(0,0,this.game_mc.width,this.game_mc.height);
            this.click_screen_mc.addChild(param1);
         }
         this.addChild(this.click_screen_mc);
      }
      
      protected function endPause() : void
      {
         if(Boolean(this.click_screen_mc) && Boolean(this.click_screen_mc.parent))
         {
            this.click_screen_mc.parent.removeChild(this.click_screen_mc);
         }
      }
      
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function set mode(param1:String) : void
      {
         this._mode = param1;
         switch(param1)
         {
            case MODE_START:
               this.show_controls = false;
               this.show_game_mc = false;
               break;
            case MODE_IDLE:
               this.killGame();
               this.show_controls = false;
               this.show_game_mc = false;
               break;
            case MODE_PLAYING:
               this.show_controls = true;
               this.show_game_mc = true;
         }
      }
      
      public function set show_instructions(param1:Boolean) : void
      {
         if(this.instructions_mc)
         {
            if(param1)
            {
               this.game_mc.addChild(this.instructions_mc);
            }
            else
            {
               this.game_mc.removeChild(this.instructions_mc);
            }
         }
         trace("Done");
      }
      
      private function set show_game_mc(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.fade_between_transitions)
            {
               this.game_mc.alpha = 0;
               TweenMax.to(this.game_mc,0.5,{
                  "alpha":1,
                  "onComplete":this.onFadeComplete
               });
               TweenMax.to(this.title_mc,0.5,{"alpha":0});
            }
         }
         else if(this.fade_between_transitions)
         {
            this.game_mc.alpha = 1;
            TweenMax.to(this.game_mc,0.5,{
               "alpha":0,
               "onComplete":this.onFadeComplete
            });
            if(this.title_mc)
            {
               TweenMax.to(this.title_mc,0.5,{"alpha":1});
            }
         }
         else
         {
            dispatchEvent(new FGLPEvent(FGLPEvent.GAME_HIDDEN));
         }
      }
      
      public function get fade_between_transitions() : Boolean
      {
         return this._fade_between_transitions;
      }
      
      public function set fade_between_transitions(param1:Boolean) : void
      {
         this._fade_between_transitions = param1;
      }
      
      public function set controls_mode(param1:String) : void
      {
         this.controls_mc.mode = param1;
      }
      
      public function get show_controls() : Boolean
      {
         return this._show_controls;
      }
      
      public function set show_controls(param1:Boolean) : void
      {
         this._show_controls = param1;
         if(param1)
         {
            this.addChild(this.controls_mc);
         }
         else if(this.controls_mc.parent)
         {
            this.removeChild(this.controls_mc);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.show_instructions = false;
         this.mode = MODE_START;
      }
      
      private function onFadeComplete() : *
      {
         if(this.game_mc.alpha == 0)
         {
            dispatchEvent(new FGLPEvent(FGLPEvent.GAME_HIDDEN));
         }
         else
         {
            this.startGame();
         }
      }
   }
}

