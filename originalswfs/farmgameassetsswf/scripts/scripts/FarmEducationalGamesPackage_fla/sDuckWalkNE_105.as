package FarmEducationalGamesPackage_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol52")]
   public dynamic class sDuckWalkNE_105 extends MovieClip
   {
      
      public function sDuckWalkNE_105()
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

