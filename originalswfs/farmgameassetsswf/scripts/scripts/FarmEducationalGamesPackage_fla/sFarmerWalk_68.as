package FarmEducationalGamesPackage_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol154")]
   public dynamic class sFarmerWalk_68 extends MovieClip
   {
      
      public function sFarmerWalk_68()
      {
         super();
         addFrameScript(0,this.frame1,36,this.frame37,49,this.frame50,61,this.frame62);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame37() : *
      {
         gotoAndPlay("walk");
      }
      
      internal function frame50() : *
      {
         dispatchEvent(new Event("RELEASE_WORD",true));
      }
      
      internal function frame62() : *
      {
         dispatchEvent(new Event("THROW_COMPLETE",true));
         stop();
      }
   }
}

