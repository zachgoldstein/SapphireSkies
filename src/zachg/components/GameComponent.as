package zachg.components
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	import zachg.GroupGameObject;
	import zachg.SimplifiedGameObject;
	import zachg.gameObjects.CallbackSprite;

	public class GameComponent extends SimplifiedGameObject
	{
		public var PhysicalSprite:CallbackSprite;
		public var hullSprite:CallbackSprite;
		public var callbackFunction:Function;
		public var rootObject:FlxObject;
		
		public function GameComponent(CallbackFunction:Function=null)
		{
			callbackFunction = CallbackFunction;
			super();
		}
		
		public function update():void
		{
			
		}
	}
}