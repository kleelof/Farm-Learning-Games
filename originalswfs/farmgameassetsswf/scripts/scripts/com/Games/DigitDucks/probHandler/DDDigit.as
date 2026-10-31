package com.Games.DigitDucks.probHandler
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol60")]
   public class DDDigit extends MovieClip
   {
      
      public var functions_mc:MovieClip;
      
      private var _digit_type:int;
      
      private var _active:Boolean;
      
      public var digit_txt:TextField;
      
      public function DDDigit(param1:String, param2:Point)
      {
         var _loc3_:String = null;
         super();
         addFrameScript(0,this.frame1);
         trace("DDDigit:" + param1 + ":");
         this.x = param2.x;
         this.y = param2.y;
         this.digit_txt.text = param1;
         this.digit_type = 1;
         if(param1 == "?")
         {
            this.digit_type = 0;
         }
         else if("+*/-".indexOf(param1) > -1)
         {
            this.digit_type = 2;
            this.gotoAndStop("function");
            switch(param1)
            {
               case "+":
                  _loc3_ = "add";
                  break;
               case "-":
                  _loc3_ = "sub";
                  break;
               case "*":
                  _loc3_ = "mul";
                  break;
               case "/":
                  _loc3_ = "div";
            }
            this.functions_mc.gotoAndStop(_loc3_);
         }
      }
      
      public function remove() : void
      {
         this.parent.removeChild(this);
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         if(this.digit_type == 0)
         {
            if(param1)
            {
            }
         }
      }
      
      public function set hightlight(param1:Boolean) : void
      {
         if(param1)
         {
            this.digit_txt.textColor = 16711680;
            this.graphics.beginFill(65280,0.4);
            this.graphics.drawRoundRect(0,0,this.width,this.height,10);
         }
         else
         {
            this.digit_txt.textColor = 65280;
            this.graphics.clear();
         }
      }
      
      public function get digit_type() : int
      {
         return this._digit_type;
      }
      
      public function set digit_type(param1:int) : void
      {
         this._digit_type = param1;
         switch(param1)
         {
            case 0:
               this.buttonMode = true;
               this.digit_txt.textColor = 65280;
               break;
            case 1:
               break;
            case 2:
               this.digit_txt.textColor = 16711680;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

