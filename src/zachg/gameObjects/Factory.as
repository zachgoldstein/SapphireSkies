package zachg.gameObjects
{
	import com.PlayState;
	import com.Resources;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import zachg.GroupGameObject;
	import zachg.components.FactoryExtendedInfoComponent;
	import zachg.components.HealthComponent;

	public class Factory extends BuildingGroup
	{

		private var objectCreatedCallback:Function;
		
		public var availablePeople:Number = 0;
		
		public var botCreationQueue:Vector.<Bot> = new Vector.<Bot>();
		public var lastBotCreationCounter:int = 0;
		
		private var createdBots:Vector.<Bot> = new Vector.<Bot>();
		
		private var factoryDetailedInfo:FactoryExtendedInfoComponent
		
		public function Factory(X:Number, Y:Number,
									passedWidth:Number,passedHeight:Number,
									scaleX:Number,scaleY:Number,
									boundsX:Number, boundsY:Number,
									boundsWidth:Number, boundsHeight:Number,
									imageName:String, IsEnemy:Boolean,
									creationCallback:Function
		):void 
		{
			super();
			x = X;
			y = Y;
			isEnemy = IsEnemy;
			objectCreatedCallback = creationCallback;
			//testing
			availableResources = 0;
			//setup the main hull sprite (it controls movement, collisions and health)
			MainHullSprite = new CallbackSprite(0,0,hullCollision,this);
			factoryDetailedInfo = new FactoryExtendedInfoComponent(null,this);
			factoryDetailedInfo.showComponent = false;
			MainHullSprite.fixed = true;
			MainHullSprite.loadGraphic(Resources[imageName], true, true, passedWidth, passedHeight );
			add(MainHullSprite);
			healthComponent.healthBar.width = MainHullSprite.width;
			levelComponent.experienceBar.width = MainHullSprite.width;
			
			add(factoryDetailedInfo.graphicHolder);
			
			//create a couple dummy objects for the bot queue..
			for (var i:int = 0 ; i < 20 ; i++  ){
				addBotToQueue();
			}
		}
		
		override public function update():void
		{
			super.update();
			healthComponent.update();
			levelComponent.update();
			if(	lastBotCreationCounter > botCreationQueue[0].botCreationDelay && 
				botCreationQueue.length > 0 &&
				availablePeople > 0 ) {
				if( botCreationQueue[0].resourceValue < availableResources && availablePeople > 0){
					availablePeople--;
					availableResources -= botCreationQueue[0].resourceValue;
					createBot();
					lastBotCreationCounter = 0; 
					levelComponent.currentExperience += 50;
				}
			}
			if( botCreationQueue.length > 0 && botCreationQueue[0].resourceValue < availableResources && availablePeople > 0){
				lastBotCreationCounter++;
			}
			
			if(factoryDetailedInfo.showComponent == true){
				var playerSprite:FlxSprite = (FlxG.state as PlayState).player.MainHullSprite;
				
				if( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x ||
					(playerSprite.x + playerSprite.width/2) > (MainHullSprite.x + MainHullSprite.width) ||
					(playerSprite.y + playerSprite.height/2) < MainHullSprite.y ||
					(playerSprite.y + playerSprite.height/2) > (MainHullSprite.y + MainHullSprite.height) ||
					(	( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x || (playerSprite.x + playerSprite.width/2) > MainHullSprite.x + MainHullSprite.width) &&
						( (playerSprite.y + playerSprite.height/2) < MainHullSprite.y || (playerSprite.y + playerSprite.height/2) > MainHullSprite.y + MainHullSprite.height))
				){
					factoryDetailedInfo.showComponent = false;
				}
			}			
			
			factoryDetailedInfo.x = x;
			factoryDetailedInfo.y = y - factoryDetailedInfo.spriteCanvas.height;
			
			factoryDetailedInfo.update();			
		}
		
		private function addBotToQueue(randomized:Boolean = false):void
		{
			if(randomized == false){
				var bot:HostileBot = new HostileBot(objectCreatedCallback);
				bot.movementComponent.moveSpeed = 100;
				botCreationQueue.push(bot);
			}
		}
		
		private function createBot():void
		{
			var bot:HostileBot = botCreationQueue.shift();
			bot.x = x;
			bot.y = y;
			bot.isEnemy = isEnemy;
			bot.createBot(buildingTarget);
			bot.movementComponent.moveObjectTarget = buildingTarget;			
			bot.gunComponent.targetObject = buildingTarget;//(FlxG.state as PlayState).player.MainHullSprite;
			
			
			createdBots.push(bot);
			objectCreatedCallback(bot,null,null,null);
		}
		
		public function hullCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
		}
		
		/**
		 * Find closest enemy building 
		 * @param buildingGroup
		 * 
		 */
/*		override public function findTarget(buildingGroup:FlxGroup):void
		{
			var currentTarget:BuildingGroup;
			var shortestDistance:Number = 99999;
			var distance:Number;
			var currentBuildingDistanceCheck:BuildingGroup;
			for (var j:int = 0 ; j < buildingGroup.members.length ; j++){
				currentBuildingDistanceCheck = buildingGroup.members[j];
				if(isEnemy != currentBuildingDistanceCheck.isEnemy){
					distance = Math.sqrt( 	(currentBuildingDistanceCheck.x - x)*(currentBuildingDistanceCheck.x - x) +
						(currentBuildingDistanceCheck.y - y)*(currentBuildingDistanceCheck.y - y) );
					if(shortestDistance > distance){
						shortestDistance = distance
						currentTarget = buildingGroup.members[j]; 
					}
				}
			}
			buildingTarget = currentTarget;
		}*/
		
		override public function botOverlapsBuilding(bot:Bot):void
		{
			if( (bot.movementComponent.moveObjectTarget.uid == uid) && 
				isEnemy == bot.isEnemy ){
				if(bot is CivilianBot){
					availablePeople++;
					bot.destroyObject();
				} else if (bot is ResourceBot) {
					availableResources += bot.resourceValue;
					bot.destroyObject();
				}
			}
		}
		
		override public function showInfo():void{
			factoryDetailedInfo.showComponent = true;
		}
		
	}
}