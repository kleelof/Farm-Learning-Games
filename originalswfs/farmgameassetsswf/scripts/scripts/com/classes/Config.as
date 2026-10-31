package com.classes
{
   public class Config
   {
      
      public static var X:XML;
      
      public function Config()
      {
         super();
      }
      
      public static function getXML(param1:String) : XML
      {
         return XML(X[param1]);
      }
   }
}

