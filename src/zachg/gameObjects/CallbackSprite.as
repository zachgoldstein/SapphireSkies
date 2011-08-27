package zachg.gameObjects
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class CallbackSprite extends FlxSprite
	{
		private var callbackFunction:Function;
		public var rootObject:FlxObject;
		
		public function CallbackSprite(X:Number=0, Y:Number=0, CallbackFunction:Function=null, RootObject:FlxObject=null, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			callbackFunction = CallbackFunction;
			rootObject = RootObject;
		}
		
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void { 
			super.hitBottom(Contact,Velocity);
			bulletCollision(Contact,Velocity,"bottom");
		}
		override public function hitTop(Contact:FlxObject, Velocity:Number):void { 
			super.hitTop(Contact,Velocity);
			bulletCollision(Contact,Velocity,"top") 
		};
		override public function hitRight(Contact:FlxObject, Velocity:Number):void { 
			super.hitRight(Contact,Velocity);
			bulletCollision(Contact,Velocity,"right") 
		};
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void { 
			super.hitLeft(Contact,Velocity);
			bulletCollision(Contact,Velocity,"left")
		};		
		
		public function bulletCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			if(callbackFunction != null) { callbackFunction(Contact,Velocity,collisionSide) };
			
		}
	}
}