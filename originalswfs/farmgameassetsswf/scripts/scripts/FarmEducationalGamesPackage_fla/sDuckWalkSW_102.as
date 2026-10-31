package FarmEducationalGamesPackage_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol48")]
   public dynamic class sDuckWalkSW_102 extends MovieClip
   {
      
      public function sDuckWalkSW_102()
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

