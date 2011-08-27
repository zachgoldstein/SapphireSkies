package zachg.gameObjects
{
	import com.PlayState;
	import com.Resources;
	
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import zachg.AcquiredItem;
	import zachg.GroupGameObject;
	import zachg.PlayerStats;
	import zachg.components.ShopExtendedInfoComponent;
	import zachg.growthItems.GrowthItem;
	import zachg.growthItems.playerItem.PlayerItem;

	/**
	 *	The shop generates resources by converting the minerals the player has mined.
	 * 	It also functions as a research lab of sorts and generates new weapons/upgrades 
	 * 	for the player to equip.
	 *   
	 * @author zachgoldstein
	 * 
	 */
	public class Shop extends BuildingGroup
	{

		private var objectCreatedCallback:Function;

		private var botCreationQueue:Vector.<Bot> = new Vector.<Bot>();
		public var botCreationDelay:int = 75;
		public var lastBotCreationCounter:int = 0;
		
		public var upgradeResearchQueue:Vector.<GrowthItem> = new Vector.<GrowthItem>();
		public var availableGrowthItems:Vector.<GrowthItem> = new Vector.<GrowthItem>();
		
		public var buildingTargets:Vector.<FlxObject> = new Vector.<FlxObject>();
		
		private var createdBots:Vector.<Bot> = new Vector.<Bot>();
		
		public var shopDetailedInfo:ShopExtendedInfoComponent
		
		public var currentResearch:PlayerItem;
		public var currentResearchQueue:Vector.<PlayerItem> = new Vector.<PlayerItem>();
		public var researchSpeed:Number = 1;
		
		public function Shop(X:Number, Y:Number,
									passedWidth:Number,passedHeight:Number,
									scaleX:Number,scaleY:Number,
									boundsX:Number, boundsY:Number,
									boundsWidth:Number, boundsHeight:Number,
									imageName:String, IsEnemy:Boolean, callback:Function
		):void 
		{
			super();
			x = X;
			y = Y;
			isEnemy = IsEnemy;
			objectCreatedCallback = callback;
			if(isEnemy == true){
				availableResources = 400;
			} else {
				availableResources = 0;
			}
			//setup the main hull sprite (it controls movement, collisions and health)
			MainHullSprite = new CallbackSprite(0,0,hullCollision,this);
			shopDetailedInfo = new ShopExtendedInfoComponent(null,this);
			shopDetailedInfo.showComponent = false;
			MainHullSprite.fixed = true;
			MainHullSprite.loadGraphic(Resources[imageName], true, true, passedWidth, passedHeight );
			add(MainHullSprite);
			healthComponent.healthBar.width = MainHullSprite.width;
			levelComponent.experienceBar.width = MainHullSprite.width;
			
			currentResearchQueue = PlayerStats.getResearchItemList();
			
			add(shopDetailedInfo.graphicHolder);
			
			//create a couple dummy objects for the queues..
			for (var i:int = 0 ; i < 20 ; i++  ){
				addBotToQueue();
			}			

			for (var j:int = 0 ; j < 10 ; j++  ){
				//currentResearchQueue.push( new ShotGun() );
			}			
			
		}
		
		override public function update():void
		{
			super.update();
			healthComponent.update();
			levelComponent.update();
			
			if( lastBotCreationCounter > botCreationDelay
				&& botCreationQueue.length > 0) {
				if( botCreationQueue[0].resourceValue < availableResources){
					availableResources -= botCreationQueue[0].resourceValue;
					createBot();
					lastBotCreationCounter = 0; 
					levelComponent.currentExperience += 50;
				}
			}
			if(availableResources > 0){
				lastBotCreationCounter++;
			}
			
			if(isEnemy == false && availableResources > 0){
				if(currentResearch == null && currentResearchQueue.length > 0){
					currentResearch = currentResearchQueue.shift();
				}
				if(currentResearch != null){
					if(currentResearch.researchProgress > currentResearch.requiredResearch){
						currentResearch.isFullyResearched = true;
					} 
					if(currentResearch.isFullyResearched != true){
						currentResearch.researchProgress += researchSpeed;
					}
				}
			}
			
			if(shopDetailedInfo.showComponent == true){
				var playerSprite:FlxSprite = (FlxG.state as PlayState).player.MainHullSprite;
				
				if( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x ||
					(playerSprite.x + playerSprite.width/2) > (MainHullSprite.x + MainHullSprite.width) ||
					(playerSprite.y + playerSprite.height/2) < MainHullSprite.y ||
					(playerSprite.y + playerSprite.height/2) > (MainHullSprite.y + MainHullSprite.height) ||
					(	( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x || (playerSprite.x + playerSprite.width/2) > MainHullSprite.x + MainHullSprite.width) &&
						( (playerSprite.y + playerSprite.height/2) < MainHullSprite.y || (playerSprite.y + playerSprite.height/2) > MainHullSprite.y + MainHullSprite.height))
				){
					shopDetailedInfo.showComponent = false;
				}
			}
			
			shopDetailedInfo.x = x;
			shopDetailedInfo.y = y - shopDetailedInfo.spriteCanvas.height;
			
			shopDetailedInfo.update();

		}
		
		private function addBotToQueue(randomized:Boolean = false):void
		{
			if(randomized == false){
				var bot:ResourceBot = new ResourceBot(objectCreatedCallback);
				bot.movementComponent.moveSpeed = 20;
				botCreationQueue.push(bot);
			}
		}		
		
		private function createBot():void
		{
			var bot:ResourceBot = botCreationQueue.shift();
			bot.x = x;
			bot.y = y;
			bot.isEnemy = isEnemy;
			bot.createBot(buildingTargets[createdBots.length%buildingTargets.length]);
			bot.movementComponent.moveObjectTarget = buildingTargets[createdBots.length%buildingTargets.length];			
			bot.gunComponent.targetObject = buildingTargets[createdBots.length%buildingTargets.length];//(FlxG.state as PlayState).player.MainHullSprite;
			
			createdBots.push(bot);
			objectCreatedCallback(bot,null,null,null);
		}
				
		public function hullCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
			
		}

		/**
		 * Find closest factory or population center to send resources to
		 * @param buildingGroup
		 * 
		 */
/*		override public function findTarget(buildingGroup:FlxGroup):void
		{
			var currentClosestFactory:Factory;
			var currentClosestPopulationCenter:PopulationCenter;
			var shortestDistanceToPopulationCenter:Number = 99999;
			var shortestDistanceToFactory:Number = 99999;
			var distance:Number;
			var currentBuildingDistanceCheck:BuildingGroup;
			for (var j:int = 0 ; j < buildingGroup.members.length ; j++){
				currentBuildingDistanceCheck = buildingGroup.members[j];
				if(	isEnemy == currentBuildingDistanceCheck.isEnemy &&
					( (currentBuildingDistanceCheck is PopulationCenter) || (currentBuildingDistanceCheck is Factory) ) ){
					distance = Math.sqrt( 	(currentBuildingDistanceCheck.x - x)*(currentBuildingDistanceCheck.x - x) +
						(currentBuildingDistanceCheck.y - y)*(currentBuildingDistanceCheck.y - y) );
					
					if(shortestDistanceToPopulationCenter > distance && (currentBuildingDistanceCheck is PopulationCenter) ){
						shortestDistanceToPopulationCenter = distance
						currentClosestPopulationCenter = buildingGroup.members[j]; 
					}
					if(shortestDistanceToFactory > distance && (currentBuildingDistanceCheck is Factory) ){
						shortestDistanceToFactory = distance
						currentClosestFactory = buildingGroup.members[j]; 
					}
				}
			}
			buildingTargets.push(currentClosestPopulationCenter,currentClosestFactory);
		}*/
		
		public function sellMineral(acquiredItem:AcquiredItem):void
		{
			availableResources += acquiredItem;
			levelComponent.currentExperience += 100;
		}
		
		override public function showInfo():void{
			shopDetailedInfo.showComponent = true;
		}
		
		override public function botOverlapsBuilding(bot:Bot):void
		{

		}		
			
	}
}