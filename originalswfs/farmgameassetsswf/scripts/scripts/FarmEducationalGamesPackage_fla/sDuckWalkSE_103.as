package FarmEducationalGamesPackage_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol49")]
   public dynamic class sDuckWalkSE_103 extends MovieClip
   {
      
      public function sDuckWalkSE_103()
      {
         super();
         addFrameScript(0,this.frame1,39,this.frame40);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame40() : *
      {
         gotoAndPlay("walk");
      }
   }
}

