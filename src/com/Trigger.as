package com 
{
	import org.flixel.FlxSprite;
	
	public class Trigger extends FlxSprite
	{
		public var target:String = "";
		public var targetObject:Object = null;
		
		public function Trigger( X:Number, Y:Number, Width:uint, Height:uint ) 
		{
			super(X, Y);
			createGraphic(Width, Height);
			visible = false;
		}
		
	}

}