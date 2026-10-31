package com.layers
{
   import com.Games.DigitDucks.DigitDucks;
   import com.Games.GaryGoat.GaryGoat;
   import com.Games.MainMenu.MainMenu;
   import com.Games.ProfessorChicken.ProfessorChicken;
   import com.Games.SuzySow.SuzySow;
   import com.greensock.easing.Bounce;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol269")]
   public class Foreground extends Layer
   {
      
      public var g_1:ProfessorChicken;
      
      public var g_2:SuzySow;
      
      public var g_3:MainMenu;
      
      public var g_4:GaryGoat;
      
      public var g_5:DigitDucks;
      
      public function Foreground()
      {
         super(1155,Bounce.easeOut);
      }
   }
}

