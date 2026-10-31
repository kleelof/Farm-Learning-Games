package com.Games.MainMenu
{
   import com.Games.Game;
   import com.UI.controlsPanel.ControlsPanel;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol210")]
   public class MainMenu extends Game
   {
      
      public var game_mc:MovieClip;
      
      public var controls_mc:ControlsPanel;
      
      public var b_1:prof_chicken_button;
      
      public var b_2:suzy_sow_button;
      
      public var b_4:gary_goat_button;
      
      public var b_5:digit_ducks_button;
      
      internal var _test:String;
      
      public function MainMenu()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      override protected function startGame() : void
      {
         super.startGame();
      }
      
      override protected function killGame() : void
      {
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.fade_between_transitions = false;
         this.controls_mode = ControlsPanel.MODE_NONE;
      }
   }
}

