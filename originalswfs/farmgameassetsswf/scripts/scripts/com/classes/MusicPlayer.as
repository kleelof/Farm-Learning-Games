package com.classes
{
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class MusicPlayer
   {
      
      private static var music_mc:SoundChannel;
      
      public static var is_playing:Boolean = false;
      
      private static var music:Sound = new FarmThemeLoop();
      
      public function MusicPlayer()
      {
         super();
      }
      
      public static function playSoundEffect(param1:Sound) : void
      {
         if(is_playing)
         {
            param1.play();
         }
      }
      
      public static function set play_music(param1:Boolean) : void
      {
         is_playing = param1;
         if(param1)
         {
            music_mc = music.play(0,0);
            music_mc.soundTransform = new SoundTransform(1);
            music_mc.addEventListener(Event.SOUND_COMPLETE,onLoopMusic);
         }
         else if(music_mc)
         {
            music_mc.stop();
         }
      }
      
      private static function onLoopMusic(param1:Event) : void
      {
         play_music = true;
      }
   }
}

