package FarmEducationalGamesPackage_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol168")]
   public dynamic class sGaryGoatWalk_64 extends MovieClip
   {
      
      public var head_mc:MovieClip;
      
      public function sGaryGoatWalk_64()
      {
         super();
         addFrameScript(0,this.frame1,36,this.frame37);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame37() : *
      {
         gotoAndPlay("walk");
      }
   }
}

