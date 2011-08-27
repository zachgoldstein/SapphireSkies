package zachg.gameObjects
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	import zachg.GroupGameObject;
	import zachg.components.GunComponent;
	import zachg.components.HealthComponent;
	import zachg.components.MovementComponent;
	import zachg.growthItems.aiItem.AiItem;

	/**
	 * NOTE: Does not automatically create everything in the constructor, it waits
	 * and creates later because it could stick around in a queue for a while doing nothing.
	 *  
	 * @author zachgoldstein
	 * 
	 */	
	public class Bot extends GroupGameObject
	{
		
		public var botName:String = "Generic Bot";
		
		public var movementComponent:MovementComponent;
		public var gunComponent:GunComponent;
		
		public var detectionArea:CallbackSprite = new CallbackSprite();
		public var detectionRange:Number = 400;
		public var botCreationDelay:int = 75;
		
		public var resourceValue:Number = 10;
		
		protected var objectCreatedCallback:Function;
		
		public function Bot(creationCallback:Function = null)
		{
			super();
			isEnemy = false;
			if(creationCallback != null){
				objectCreatedCallback = creationCallback;
				movementComponent = new MovementComponent(botCollision,this);
				gunComponent = new GunComponent(objectCreatedCallback,bulletCollision,this);
				healthComponent = new HealthComponent();
			}
		}

		public function createBot(movementTarget:FlxPoint, Level:Number = 0, aiItem:AiItem = null):void
		{			
			//add to group
			addComponent(movementComponent);
			addComponent(gunComponent);
			
		}
		
		override public function update():void
		{
			super.update();
			x = movementComponent.PhysicalSprite.x;
			y = movementComponent.PhysicalSprite.y;
			width = movementComponent.PhysicalSprite.width;
			height = movementComponent.PhysicalSprite.height;
			
			movementComponent.update();
			if(gunComponent != null){
				gunComponent.update();
				gunComponent.PhysicalSprite.x = movementComponent.PhysicalSprite.x;
				gunComponent.PhysicalSprite.y = movementComponent.PhysicalSprite.y;
			}

			healthComponent.x = x;
			healthComponent.y = y - healthComponent.spriteCanvas.height;
			if(healthComponent.currentHealth < 0){
				destroyObject();
			}
		}
		
		public function detectBotsInRange():void
		{
			FlxU.overlap(detectionArea,(FlxG.state as PlayState).hostileBots,botInRange);
		}
		
		private function botInRange(bot1:CallbackSprite,bot2:CallbackSprite):void
		{
			
		}


		public function botCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
		}

		public function bulletCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
		}
		
		public function botOverlapsBuilding(building:BuildingGroup):void
		{
			
		}
		
	}
}