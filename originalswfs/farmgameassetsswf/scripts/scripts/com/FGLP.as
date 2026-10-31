package com
{
   import com.Events.FGLPEvent;
   import com.Events.LayerEvent;
   import com.Events.UIEvent;
   import com.Games.Game;
   import com.classes.*;
   import com.layers.Layer;
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   [SWF(width="1155", height="650", backgroundColor="#cccccc", frameRate="60")]
   public class FGLP extends MovieClip
   {
      
      public var foreground_layer:Layer;
      
      private var _current_game:Game;
      
      public function FGLP()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function get current_game() : Game
      {
         return this._current_game;
      }
      
      public function set current_game(param1:Game) : void
      {
         var _loc2_:Game = this._current_game;
         this._current_game = param1;
         if(_loc2_)
         {
            _loc2_.mode = Game.MODE_IDLE;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         stage.scaleMode = StageScaleMode.SHOW_ALL;
         MusicPlayer.play_music = true;
         this.addEventListener(FGLPEvent.GOTO_GAME,this.onGotoGame);
         this.addEventListener(FGLPEvent.GAME_HIDDEN,this.onGameHidden);
         this.foreground_layer.addEventListener(LayerEvent.LAYER_IN_PLACE,this.onForegroundInPosition);
         this.addEventListener(UIEvent.MUTE_MUSIC,this.onStopSound);
         this.addEventListener(UIEvent.UNMUTE_MUSIC,this.onStartSound);
         this.addEventListener(FGLPEvent.PLAY_SOUND_EFFECT,this.onPlaySoundEffect);
         this.addEventListener(UIEvent.TOGGLE_SCREEEN,this.onToggleScreen);
         this.addEventListener(UIEvent.GO_HOME_CLICKED,this.onGoHomeClicked);
         this.addEventListener(FGLPEvent.CLICK_SOUND,this.onClick);
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.onConfigLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onConfigLoadError);
         _loc2_.load(new URLRequest("config.xml"));
      }
      
      private function onGoHomeClicked(param1:UIEvent) : void
      {
         this.current_game = Game(this.foreground_layer.getChildByName("g_3"));
      }
      
      private function onToggleScreen(param1:UIEvent) : void
      {
         if(stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
         else
         {
            stage.displayState = StageDisplayState.FULL_SCREEN;
         }
      }
      
      private function onConfigLoadError(param1:IOErrorEvent) : void
      {
      }
      
      private function onConfigLoaded(param1:Event) : void
      {
         Config.X = XML(param1.target.data);
         this.current_game = Game(this.foreground_layer.getChildByName("g_3"));
         dispatchEvent(new LayerEvent(LayerEvent.GOTO_PAGE,3));
      }
      
      private function onGotoGame(param1:FGLPEvent) : void
      {
         this.current_game = Game(this.foreground_layer.getChildByName("g_" + String(param1.data)));
      }
      
      private function onGameHidden(param1:FGLPEvent) : void
      {
         if(this.current_game != null)
         {
            trace("Go");
            dispatchEvent(new LayerEvent(LayerEvent.GOTO_PAGE,this.current_game.name.substr(2)));
         }
      }
      
      private function onForegroundInPosition(param1:LayerEvent) : void
      {
         this.current_game.mode = Game.MODE_PLAYING;
      }
      
      private function onHoldTMRCompelte(param1:TimerEvent) : void
      {
         Timer(param1.target).removeEventListener(TimerEvent.TIMER_COMPLETE,this.onHoldTMRCompelte);
         this.current_game.mode = Game.MODE_PLAYING;
      }
      
      private function onStopSound(param1:UIEvent) : void
      {
         MusicPlayer.play_music = false;
      }
      
      private function onStartSound(param1:UIEvent) : void
      {
         MusicPlayer.play_music = true;
      }
      
      private function onPlaySoundEffect(param1:FGLPEvent) : void
      {
         MusicPlayer.playSoundEffect(Sound(param1.data));
      }
      
      private function onClick(param1:FGLPEvent) : void
      {
         MusicPlayer.playSoundEffect(new Click());
      }
   }
}

