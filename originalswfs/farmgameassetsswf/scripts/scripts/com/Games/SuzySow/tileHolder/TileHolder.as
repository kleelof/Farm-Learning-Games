package com.Games.SuzySow.tileHolder
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol224")]
   public class TileHolder extends MovieClip
   {
      
      public var hide_difficulty:String;
      
      public var tiles_for_word:Array = new Array();
      
      public var grid_size:int = 8;
      
      private var grid:Array;
      
      private var display_size:int = 560;
      
      private var _active:Boolean = false;
      
      private var _word:String;
      
      public function TileHolder()
      {
         super();
      }
      
      public function reset() : void
      {
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._active = param1;
         if(this.grid)
         {
            _loc2_ = 0;
            while(_loc2_ < this.grid_size)
            {
               _loc3_ = 0;
               while(_loc3_ < this.grid_size)
               {
                  Tile(this.grid[_loc2_][_loc3_]).active = param1;
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         if(param1)
         {
         }
      }
      
      public function set word(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         param1 = param1.toUpperCase();
         this._word = param1;
         trace(this);
         while(this.numChildren > 1)
         {
            this.removeChildAt(1);
         }
         if(this.word != "")
         {
            this.grid = new Array();
            _loc2_ = 0;
            while(_loc2_ < this.grid_size)
            {
               this.grid.push(new Array());
               _loc2_++;
            }
            _loc3_ = "EEEEEEEEEEEEAAAAAAAAAIIIIIIIIIOOOOOOOONNNNNNRRRRRRTTTTTTLLLLSSSSUUUUDDDDGGGGBBCCMMPPFFHHVVWWYYKJXQZ";
            _loc4_ = 0;
            while(_loc4_ <= int(this.hide_difficulty))
            {
               _loc3_ += param1;
               _loc4_++;
            }
            _loc5_ = 0;
            while(_loc5_ < this.grid_size)
            {
               _loc6_ = 0;
               while(_loc6_ < this.grid_size)
               {
                  this.grid[_loc5_][_loc6_] = Tile(this.addChild(new Tile(int(this.display_size / this.grid_size),_loc3_.substr(Math.floor(Math.random() * (_loc3_.length - 1)),1),_loc5_,_loc6_,this.grid_size)));
                  _loc6_++;
               }
               _loc5_++;
            }
            if(param1.length > 0)
            {
               switch(this.hide_difficulty)
               {
                  case "1":
                     this.build_traditional(new Array("NN","NE","EE","SE","SS"));
                     break;
                  case "2":
                     this.build_traditional(new Array("NN","NE","EE","SE","SS","SW","WW","NW"));
                     break;
                  case "3":
                     this.seed_tiles();
                     this.setNextTile();
               }
            }
         }
      }
      
      public function get word() : String
      {
         return this._word;
      }
      
      public function set hide_letters(param1:Boolean) : void
      {
         var _loc2_:Tile = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.grid)
         {
            _loc3_ = 0;
            while(_loc3_ < this.grid_size)
            {
               _loc4_ = 0;
               while(_loc4_ < this.grid_size)
               {
                  Tile(this.grid[_loc3_][_loc4_]).hide_letter = param1;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
      }
      
      private function build_traditional(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:Tile = null;
         this.tiles_for_word = new Array();
         var _loc2_:String = String(param1[Math.floor(Math.random() * param1.length)]);
         switch(_loc2_)
         {
            case "NN":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - 1)));
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length - 1)) + this.word.length);
               break;
            case "NE":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length)));
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length - 1)) + this.word.length);
               break;
            case "EE":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length)));
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - 1)));
               break;
            case "SE":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length)));
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length)));
               break;
            case "SS":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - 1)));
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length)));
               break;
            case "SW":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length - 1)) + this.word.length);
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length)));
               break;
            case "WW":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length - 1)) + this.word.length);
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - 1)));
               break;
            case "NW":
               _loc3_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length - 1)) + this.word.length);
               _loc4_ = int(Math.floor(Math.random() * (this.grid_size - this.word.length - 1)) + this.word.length);
         }
         var _loc6_:int = 0;
         while(_loc6_ < this.word.length)
         {
            _loc5_ = Tile(this.grid[_loc3_][_loc4_]);
            _loc5_.used_by_word = true;
            _loc5_.letter_txt.text = this.word.substr(_loc6_,1);
            this.tiles_for_word.push(_loc5_);
            switch(_loc2_)
            {
               case "NN":
                  _loc4_--;
                  break;
               case "NE":
                  _loc4_--;
                  _loc3_++;
                  break;
               case "EE":
                  _loc3_++;
                  break;
               case "SE":
                  _loc3_++;
                  _loc4_++;
                  break;
               case "SS":
                  _loc4_++;
                  break;
               case "SW":
                  _loc3_--;
                  _loc4_++;
                  break;
               case "WW":
                  _loc3_--;
                  break;
               case "NW":
                  _loc3_--;
                  _loc4_--;
            }
            _loc6_++;
         }
      }
      
      private function seed_tiles() : void
      {
         var _loc1_:Point = new Point(Math.floor(Math.random() * (this.grid_size - 1)),Math.floor(Math.random() * (this.grid_size - 1)));
         var _loc2_:Tile = Tile(this.grid[_loc1_.x][_loc1_.y]);
         _loc2_.used_by_word = true;
         this.tiles_for_word.push(_loc2_);
      }
      
      private function setNextTile() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc4_:Tile = null;
         var _loc5_:int = 0;
         var _loc1_:Tile = Tile(this.tiles_for_word[this.tiles_for_word.length - 1]);
         if(_loc1_.tested_directions.length == 0)
         {
            this.tiles_for_word.pop();
            if(this.tiles_for_word.length == 0)
            {
               this.seed_tiles();
            }
            this.setNextTile();
         }
         else
         {
            _loc2_ = Math.floor(Math.random() * _loc1_.tested_directions.length);
            _loc3_ = Point(_loc1_.tested_directions.slice(_loc2_,_loc2_ + 1).shift());
            while(Tile(this.grid[_loc3_.x + _loc1_.column][_loc3_.y + _loc1_.row]).used_by_word)
            {
               _loc2_ = Math.floor(Math.random() * (_loc1_.tested_directions.length - 1));
               _loc3_ = Point(_loc1_.tested_directions.slice(_loc2_,_loc2_ + 1).shift());
            }
            _loc4_ = Tile(this.grid[_loc3_.x + _loc1_.column][_loc3_.y + _loc1_.row]);
            _loc4_.used_by_word = true;
            this.tiles_for_word.push(_loc4_);
            if(this.tiles_for_word.length == this.word.length)
            {
               _loc5_ = 0;
               while(_loc5_ < this.word.length)
               {
                  Tile(this.tiles_for_word[_loc5_]).letter_txt.text = this.word.substr(_loc5_,1);
                  _loc5_++;
               }
            }
            else
            {
               this.setNextTile();
            }
         }
      }
   }
}

