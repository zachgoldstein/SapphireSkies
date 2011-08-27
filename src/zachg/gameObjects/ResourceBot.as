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
	public class ResourceBot extends Bot
	{
		public function ResourceBot(creationCallback:Function)
		{
			objectCreatedCallback = creationCallback;
			movementComponent = new MovementComponent(botCollision,this);
			gunComponent = new GunComponent(objectCreatedCallback,bulletCollision,this);
			healthComponent = new HealthComponent();
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;
		}
		
		override public function createBot(movementTarget:FlxPoint, Level:Number = 0, aiItem:AiItem = null):void
		{
			//set properties specific to type (note that some are also set in Factory, but will be more general properties
			movementComponent.PhysicalSprite.maxVelocity = new FlxPoint(100,100); 
			movementComponent.targetStopRange = 0;			
			
			//set graphic stuff
			//movementComponent.PhysicalSprite.loadGraphic(Resources.ResourceBot,true,true,57,40);
			
			//add to group
			addComponent(movementComponent);
			add(healthComponent.graphicHolder);
			
			update();
		}
		
		override public function update():void
		{
			super.update();
			//assorted other stuff
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;
			healthComponent.update();
		}

		override public function botCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{

		}

		override public function botOverlapsBuilding(building:BuildingGroup):void
		{
		}

		
		override public function bulletCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
		}
		
		public override function destroyObject():void
		{
			super.destroyObject();
			//FlxG.log(this
		}
		
	}
}