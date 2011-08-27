package zachg.gameObjects
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
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
	public class HostileBot extends Bot
	{

		public function HostileBot(creationCallback:Function = null)
		{
			objectCreatedCallback = creationCallback;
			movementComponent = new MovementComponent(botCollision,this);
			gunComponent = new GunComponent(objectCreatedCallback,bulletCollision,this);
			healthComponent = new HealthComponent();
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;
			
			botName = "Hostile Ground Bot";
		}
		
		override public function createBot(movementTarget:FlxPoint, Level:Number = 0, aiItem:AiItem = null):void
		{
			//set properties specific to type (note that some are also set in Factory, but will be more general properties)
			movementComponent.PhysicalSprite.maxVelocity = new FlxPoint(100,100);
			
			gunComponent.PhysicalSprite.loadGraphic(Resources.Gun,false,false,2,5);
			gunComponent.PhysicalSprite.origin = new FlxPoint(0,gunComponent.PhysicalSprite.height/2);
			//gunComponent.PhysicalSprite.visible = false;
			gunComponent.bulletClass = BulletGroup;
			gunComponent.isAiControlled = true;
			gunComponent.isEnemy = isEnemy;			
			
			//set graphic stuff
			//movementComponent.PhysicalSprite.loadGraphic(Resources.Infantry,true,true,25,28);
			movementComponent.PhysicalSprite.addAnimation("walk",[1,2,3,4,5,6],10,true);
			movementComponent.PhysicalSprite.addAnimation("shoot",[0],10,true);
			movementComponent.PhysicalSprite.play("walk");
			
			//assorted other stuff
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;	
			healthComponent.drawVisual();
			//setup the detection box if we're using overlaps for detecting enemies in range
//			detectionArea = new CallbackSprite(x,y,null,this);
//			detectionArea.createGraphic(detectionRange,detectionRange);
//			objectCreatedCallback(detectionArea,null,null,null);
//			detectionArea.visible = false;
//			add(detectionArea);
			
			//add to group
			addComponent(movementComponent);
			addComponent(gunComponent);
			add(healthComponent.graphicHolder);
			
			update();
		}
		
		override public function update():void
		{
			super.update();
			
			//TODO: this is very very intensive, rework how the components get updates so that they don't have to do it every frame.
			movementComponent.update();
			gunComponent.update();
			healthComponent.update();
			gunComponent.PhysicalSprite.x = movementComponent.PhysicalSprite.x;
			gunComponent.PhysicalSprite.y = movementComponent.PhysicalSprite.y;
//			detectionArea.x = movementComponent.PhysicalSprite.x - detectionArea.width/2;
//			detectionArea.y = movementComponent.PhysicalSprite.y - detectionArea.height/2;
			detectBotsInRange();
			
			//TODO: rethink this logic, it's messy as fuck
			if(movementComponent.moveLocationTarget == null && movementComponent.moveObjectTarget == null){
			} else if( movementComponent.moveObjectTarget != null){
				if(movementComponent.moveObjectTarget.exists == false){
					movementComponent.moveObjectTarget = findNextClosestBuilding((FlxG.state as PlayState).buildings);
				}
				detectBuildingsInRange();
			}
				
			
		}
		
		private function findNextClosestBuilding(group:FlxGroup):FlxObject
		{
			var closestObject:FlxObject;
			
			var distance:Number;
			var currentBotDistanceCheck:GroupGameObject;
			var shortestDistance:Number = 99999;
			
			for ( var i:int = 0 ; i < group.members.length; i++){
				currentBotDistanceCheck = group.members[i];
				if(isEnemy != currentBotDistanceCheck.isEnemy){
					distance = Math.sqrt( 	(currentBotDistanceCheck.x - x)*(currentBotDistanceCheck.x - x) +
						(currentBotDistanceCheck.y - y)*(currentBotDistanceCheck.y - y) );
					if(shortestDistance > distance){
						closestObject = currentBotDistanceCheck;
						shortestDistance = distance;
					}
				}
			}
			
			return closestObject
		}
		
		private var objectsInRange:Array = new Array();
		override public function detectBotsInRange():void
		{
			//Find objects in range using overlap...
			//FlxU.overlap(detectionArea,(FlxG.state as PlayState).hostileBots,botInRange);
			
			//Find objects in range using pure distance
			objectsInRange = findObjectsInRange((FlxG.state as PlayState).hostileBots,true);
			if(objectsInRange.length > 1){
				movementComponent.stopMoving();
				movementComponent.PhysicalSprite.play("walk");
			}
		}
		
		public function detectBuildingsInRange():void
		{
			var buildingsInRange:Array = findObjectsInRange((FlxG.state as PlayState).buildings,true);
			if(buildingsInRange.length > 1){
				movementComponent.stopMoving();
				movementComponent.PhysicalSprite.play("walk");
			}			
		}
		
		
		/**
		 * Returns all the enemy bots within range, also sets the target to the closest one. 
		 * @param group
		 * @return 
		 * 
		 */
		private function findObjectsInRange(group:FlxGroup,setTarget:Boolean = false):Array{
			var objectsInRange:Array = new Array();
			
			var distance:Number;
			var currentBotDistanceCheck:GroupGameObject;
			var shortestDistance:Number = 99999;

			for ( var i:int = 0 ; i < group.members.length; i++){
				currentBotDistanceCheck = group.members[i];
				if(isEnemy != currentBotDistanceCheck.isEnemy && currentBotDistanceCheck.dead == false){
					distance = Math.sqrt( 	(currentBotDistanceCheck.x - x)*(currentBotDistanceCheck.x - x) +
						(currentBotDistanceCheck.y - y)*(currentBotDistanceCheck.y - y) );
					if(detectionRange > distance){
						objectsInRange.push( currentBotDistanceCheck);
						if(shortestDistance > distance){
							if(setTarget == true){
								gunComponent.targetObject = currentBotDistanceCheck;
							}
							shortestDistance = distance;
						}
					}
				}
			}
			return objectsInRange
		}
		
		private function botInRange(bot1:CallbackSprite,bot2:CallbackSprite):void
		{
			if(	(bot1.uid == detectionArea.uid && bot2.uid == movementComponent.PhysicalSprite.uid) ||
				(bot2.uid == detectionArea.uid && bot1.uid == movementComponent.PhysicalSprite.uid) ){
			} else {
				
				
			}
		}


		override public function botCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
		}

		override public function bulletCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
		}
		
		override public function botOverlapsBuilding(building:BuildingGroup):void
		{
			
		}
		
	}
}