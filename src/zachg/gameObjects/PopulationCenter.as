package zachg.gameObjects
{
	import com.PlayState;
	import com.Resources;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	import zachg.GroupGameObject;
	import zachg.components.PopulationCenterExtendedInfoComponent;

	public class PopulationCenter extends BuildingGroup
	{

		private var objectCreatedCallback:Function;

		public var availablePeople:Number = 0;		
		
		public var populationDelayCounter:Number = 5;
		public var populationToAdd:Number = 1;
		public var populationGrowthCost:Number = 1;
		public var lastPopulationAddCounter:int = 0;
		
		private var botCreationQueue:Vector.<Bot> = new Vector.<Bot>();
		public var botCreationDelay:int = 75;
		public var lastBotCreationCounter:int = 0;
		
		private var createdBots:Vector.<Bot> = new Vector.<Bot>();
		
		private var popCenterDetailedInfo:PopulationCenterExtendedInfoComponent;		
		
		public function PopulationCenter(X:Number, Y:Number,
									passedWidth:Number,passedHeight:Number,
									scaleX:Number,scaleY:Number,
									boundsX:Number, boundsY:Number,
									boundsWidth:Number, boundsHeight:Number,
									imageName:String, IsEnemy:Boolean, callback:Function
		):void 
		{
			super();
			x=X; y=Y;
			isEnemy = IsEnemy;
			objectCreatedCallback = callback;
			availableResources = 0;
			//setup the main hull sprite (it controls movement, collisions and health)
			MainHullSprite = new CallbackSprite(0,0,hullCollision,this);
			popCenterDetailedInfo = new PopulationCenterExtendedInfoComponent(null,this);
			popCenterDetailedInfo.showComponent = false;
			MainHullSprite.fixed = true;
			MainHullSprite.loadGraphic(Resources[imageName], true, true, passedWidth, passedHeight );
			add(MainHullSprite);
			healthComponent.healthBar.width = MainHullSprite.width;
			levelComponent.experienceBar.width = MainHullSprite.width;
			
			add(popCenterDetailedInfo.graphicHolder);
			
			
			//create a couple dummy objects for the bot queue..
			for (var i:int = 0 ; i < 100 ; i++  ){
				addBotToQueue();
			}			
		}
		
		override public function update():void
		{
			super.update();
			healthComponent.update();
			levelComponent.update();
			
			if(	lastBotCreationCounter > botCreationDelay && 
				botCreationQueue.length > 0 ) {
				if(availablePeople > 0 ){
					availablePeople--;
					createBot();
					lastBotCreationCounter = 0; 
					levelComponent.currentExperience += 50;
				}
			}
			if( botCreationQueue.length > 0 && availablePeople > 0){
				lastBotCreationCounter++;
			}
			
			if(lastPopulationAddCounter > populationDelayCounter && availableResources > populationGrowthCost){
				generatePopulation();
				availableResources -= populationGrowthCost;
				lastPopulationAddCounter = 0;
			}
			lastPopulationAddCounter++;
			
			if(popCenterDetailedInfo.showComponent == true){
				var playerSprite:FlxSprite = (FlxG.state as PlayState).player.MainHullSprite;
				
				if( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x ||
					(playerSprite.x + playerSprite.width/2) > (MainHullSprite.x + MainHullSprite.width) ||
					(playerSprite.y + playerSprite.height/2) < MainHullSprite.y ||
					(playerSprite.y + playerSprite.height/2) > (MainHullSprite.y + MainHullSprite.height) ||
					(	( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x || (playerSprite.x + playerSprite.width/2) > MainHullSprite.x + MainHullSprite.width) &&
						( (playerSprite.y + playerSprite.height/2) < MainHullSprite.y || (playerSprite.y + playerSprite.height/2) > MainHullSprite.y + MainHullSprite.height))
 				){
					popCenterDetailedInfo.showComponent = false;
				}
			}			
			
			popCenterDetailedInfo.x = x;
			popCenterDetailedInfo.y = y - popCenterDetailedInfo.spriteCanvas.height;
			
			popCenterDetailedInfo.update();			
			
		}
		
		private function addBotToQueue(randomized:Boolean = false):void
		{
			if(randomized == false){
				var bot:CivilianBot = new CivilianBot(objectCreatedCallback);
				bot.movementComponent.moveSpeed = 10;
				botCreationQueue.push(bot);
			}
		}
		
		private function createBot():void
		{
			var bot:CivilianBot = botCreationQueue.shift();
			bot.x = x;
			bot.y = y;
			bot.isEnemy = isEnemy;
			bot.createBot(buildingTarget);
			bot.movementComponent.moveObjectTarget = buildingTarget;
			
			createdBots.push(bot);
			objectCreatedCallback(bot,null,null,null);
		}
		
		private function generatePopulation():void
		{
			availablePeople += populationToAdd;
			levelComponent.currentExperience += 10;
		}
		
		public function hullCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
			
		}
		
		/**
		 * Find closest friendly Factory 
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
				if(isEnemy == currentBuildingDistanceCheck.isEnemy && currentBuildingDistanceCheck is Factory){
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
				if (bot is ResourceBot) {
					availableResources += bot.resourceValue;
					bot.destroyObject();
				}
			}
		}
		
		override public function showInfo():void{
			popCenterDetailedInfo.showComponent = true;
		}
		
	}
}