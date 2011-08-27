package zachg.gameObjects
{
	import com.PlayState;
	import com.Resources;
	import com.cartogrammar.drawing.DashedLine;
	
	import flash.display.Shape;
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import zachg.AcquiredItem;
	import zachg.GroupGameObject;
	import zachg.PlayerStats;
	import zachg.components.LevelInfoComponent;
	import zachg.components.ShopExtendedInfoComponent;
	import zachg.growthItems.GrowthItem;
	import zachg.growthItems.aiItem.AiItem;
	import zachg.growthItems.aiItem.Stage1EnemyShip;
	import zachg.growthItems.aiItem.Stage1FriendlyShip;
	import zachg.growthItems.buildingItem.BuildingItem;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.ui.dialogues.*;
	import zachg.util.EffectController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;
	import zachg.util.VillageInfoGenerator;

	/**
	 *	The shop generates resources by converting the minerals the player has mined.
	 * 	It also functions as a research lab of sorts and generates new weapons/upgrades 
	 * 	for the player to equip.
	 *   
	 * @author zachgoldstein
	 * 
	 */
	public class Village extends BuildingGroup
	{

		private var objectCreatedCallback:Function;

		public var botCreationQueue:Vector.<Bot> = new Vector.<Bot>();
		public var botCreationDelay:int = 50;
		public var lastBotCreationCounter:int = 0;
		
		public var maxAliveUnits:Number = 4;
		
		public var availableGrowthItems:Vector.<BuildingItem> = new Vector.<BuildingItem>();
		
		public var buildingTargetUIIndicators:Vector.<VillageUnitTarget> = new Vector.<VillageUnitTarget>();
		
		private var createdBots:Vector.<Bot> = new Vector.<Bot>();
		
		public var villageInfoDialogue:VillageInfoDialogue;
		
		public var botShotBonus:Number = 0;
		
		public var villageResourceGrowth:Number = 0.05;
		public var shipResourceCost:Number = 99999;
		
		public var villagePopulation:Number = 9999999;
		public var villageMaxPopulation:Number = 9999999;
		public var villageName:String = "";
		
		public var aiItem:AiItem;
				
		public var dialogueGroup:FlxGroup = new FlxGroup();
		
		public var productionRate:Number = 100;
		
		public var initialVillageLevelSet:Boolean = true;
		
		//When a village is destoyed, the targets of other villages need to get reset. 
		//In order for them to know which of their targets to remove, we need to lookup again this id
		public var id:String = "";
				
		public function Village(X:Number, Y:Number,
									passedWidth:Number,
									passedHeight:Number,
									scaleX:Number,
									scaleY:Number,
									boundsX:Number,
									boundsY:Number,
									boundsWidth:Number,
									boundsHeight:Number,
									imageName:String,
									IsEnemy:Boolean,
									_aiItem:AiItem,
									VillageResourceGrowth:Number,
									VillageResources:Number,
									VillageLevel:Number,
									GameUIGroup:FlxGroup,
									VillageName:String,
									callback:Function
		):void 
		{
			aiItem = _aiItem;
			
			isEnemy = IsEnemy;
			if(isEnemy == true){
				id = "e"+(FlxG.state as PlayState).enemyBuildings.members.length;
			} else {
				id = "f"+(FlxG.state as PlayState).friendlyBuildings.members.length;
			}
			
			GameUIGroup.add(dialogueGroup);
			
			levelComponent = new LevelInfoComponent(levelUp,this);
			healthComponent.rootObject = this;
			add(healthComponent.graphicHolder);
			add(levelComponent.graphicHolder);
			
			//villageResourceGrowth = VillageResourceGrowth;
			villageResourceGrowth = aiItem.villageResourceGrowth[levelComponent.currentLevel];
			shipResourceCost = aiItem.levelShipResourceCost[levelComponent.currentLevel];
			availableResources = VillageResources;
			
			villagePopulation = VillageInfoGenerator.generatePopulation(levelComponent.currentLevel+1);
			levelComponent.defaultPopulation = villagePopulation;
			levelComponent.maxLevel = LevelData.LevelCreationData[PlayerStats.currentLevelId][9];
			villageMaxPopulation = villagePopulation + levelComponent.maxTotalExperience;
			
			if(VillageName != ""){
				villageName = VillageName;
			} else {
				villageName = VillageInfoGenerator.generateName( isEnemy)
			}
			
			x = X;
			y = Y;			
			
			objectCreatedCallback = callback;
			
			
			//TEMP
			if(isEnemy == true){
				//villageResourceGrowth = 0.1;
				//availableResources = 0;
				
			} else {
				//villageResourceGrowth = 0.05;
				//availableResources = 0;

				//Temp
				//availableResources = 100;
				//lastBotCreationCounter = 999;
			}
			
			//tweak for per-level 
			var levelFromStageStart:Number = PlayerStats.currentLevelId%3;
			healthComponent.maxHealth = aiItem.villageHealth[levelFromStageStart];
			healthComponent.currentHealth = healthComponent.maxHealth;
/*			for(var i:int = 0 ; i < levelFromStageStart ; i++){
				healthComponent.maxHealth *= 1.4
			}
			if(isEnemy == false){
				healthComponent.maxHealth *= 0.75;
			}
*/			healthComponent.currentHealth = healthComponent.maxHealth;
			
/*			for (var i:int = 0 ; i < PlayerStats.growthItems.length ; i++){
				if( PlayerStats.growthItems[i].isPurchased == true && PlayerStats.growthItems[i] is BuildingItem){
					loadPropertyMapping( (PlayerStats.growthItems[i] as BuildingItem).propertyMapping );
				}
			}	*/		
			
			//setup the main hull sprite (it controls movement, collisions and health)
			MainHullSprite = new CallbackSprite(0,0,hullCollision,this);
			MainHullSprite.fixed = true;
			if(imageName != null){
				MainHullSprite.loadGraphic(Resources[imageName], true, true, passedWidth, passedHeight );
			} else {
				MainHullSprite.loadGraphic(
					aiItem.villageGraphics[VillageLevel],
					aiItem.villageGraphicParams[VillageLevel][0],
					aiItem.villageGraphicParams[VillageLevel][1],
					aiItem.villageGraphicParams[VillageLevel][2],
					aiItem.villageGraphicParams[VillageLevel][3] 
				);
			}
			add(MainHullSprite);
			
			levelComponent.currentLevel = VillageLevel;
			initialVillageLevelSet = false;			
			
			//setup any dialgoues or information boxes
			healthComponent.healthBar.width = MainHullSprite.width;
			levelComponent.experienceBar.width = MainHullSprite.width;
			villageInfoDialogue = new VillageInfoDialogue(null,this);
			villageInfoDialogue.showComponent = false;
			(FlxG.state as PlayState).effectDisplays.add(villageInfoDialogue.graphicHolder);
			
			//get all the upgrades for this building the player has purchased
			availableGrowthItems = PlayerStats.getAllGrowthItemsForBuilding(Village);
			
			//create a couple dummy bots to test them.
			for (var i:int = 0 ; i < 0 ; i++  ){
				addBotToQueue();
			}	
			
			//dirty hack to get healthbars to render at start
			healthComponent.currentHealth--;
			healthComponent.currentHealth++;			
			
			
		}
		
		override public function update():void
		{
			if(isFrozen == true){
				return
			}
			super.update();

			healthComponent.healthChange = healthComponent.maxHealth*0.0008;
			healthComponent.drawVisual();
			healthComponent.update();
			levelComponent.update();
			availableResources += villageResourceGrowth;
			levelComponent.defaultPopulation = villagePopulation;
			var amountToAdd:Number = villageResourceGrowth*(availableResources/(villageResourceGrowth*20))
			if( (amountToAdd + villagePopulation) < villageMaxPopulation){
				villagePopulation += amountToAdd;
			}
			levelComponent.currentExperience += amountToAdd;
			
			MainHullSprite.x = x - MainHullSprite.width/2;
			MainHullSprite.y = y - MainHullSprite.height;
			
			//Create bot
			if( lastBotCreationCounter > botCreationDelay
				&& countAliveUnits() < maxAliveUnits
			) {
				if( shipResourceCost < availableResources ){
					if(Math.random()*100 < productionRate){
						availableResources -= shipResourceCost;
						createBot();
						var test:FlxGroup = (FlxG.state as PlayState).enemyBots;
					}
					lastBotCreationCounter = 0;
				}
			}
			if(availableResources > 0 && availableResources > shipResourceCost){
				lastBotCreationCounter++;
			}
			
			//tell bots to protect if needed
			if(healthComponent.currentHealth < (healthComponent.maxHealth*0.5)){
				for (var i:int = 0 ; i < createdBots.length ; i++){
					(createdBots[i] as HostileAirBot).goProtect = true;
					(createdBots[i] as HostileAirBot).movementComponent.moveObjectTarget = MainHullSprite;
				}
			} else {
				for (var i:int = 0 ; i < createdBots.length ; i++){
					(createdBots[i] as HostileAirBot).goProtect = false;
				}
			}
				
				
			
			villageInfoDialogue.x = MainHullSprite.x - villageInfoDialogue.spriteCanvas.width/2 + MainHullSprite.width/2;
			villageInfoDialogue.y = MainHullSprite.y - villageInfoDialogue.spriteCanvas.height;
			villageInfoDialogue.update();
			
			refreshTargetVisibilities();
		}
		
		public function resetInfoDialogue():void
		{
			//this turns off the dialogue if the player's mouse is not on top of the building
			if(villageInfoDialogue.showComponent == true){
				var playerSprite:FlxSprite = (FlxG.state as PlayState).mouseCollisionCheckObject;
				
				if( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x ||
					(playerSprite.x + playerSprite.width/2) > (MainHullSprite.x + MainHullSprite.width) ||
					(playerSprite.y + playerSprite.height/2) < MainHullSprite.y ||
					(playerSprite.y + playerSprite.height/2) > (MainHullSprite.y + MainHullSprite.height) ||
					(	( (playerSprite.x + playerSprite.width/2) < MainHullSprite.x || (playerSprite.x + playerSprite.width/2) > MainHullSprite.x + MainHullSprite.width) &&
						( (playerSprite.y + playerSprite.height/2) < MainHullSprite.y || (playerSprite.y + playerSprite.height/2) > MainHullSprite.y + MainHullSprite.height))
				){
					villageInfoDialogue.showComponent = false;
				}
			}			
		}

		private function addBotToQueue(randomized:Boolean = false):void
		{
			if(randomized == false){
				var bot:HostileAirBot = new HostileAirBot(objectCreatedCallback);
				bot.movementComponent.moveSpeed = 60;				
				botCreationQueue.push(bot);
			}
		}		
		
		private function createBot():void
		{
			var bot:HostileAirBot = botCreationQueue.shift();
			if(botCreationQueue.length == 0){
				addBotToQueue();
				bot = botCreationQueue.shift();
				trace("addBotToQueue called");
			}
			
			bot.isEnemy = isEnemy;
			
			var weights:Array = new Array();
			for (var i:int = 0 ; i < buildingTargetUIIndicators.length ; i++){
				weights.push(buildingTargetUIIndicators[i].percentageUnitsSentHere);
			}
			var unitTarget:FlxPoint;
			if(buildingTargetUIIndicators.length == 0 ){
				unitTarget = null
			} else {
				unitTarget = buildingTargetUIIndicators[randomIndexByWeights( weights )].targetLocation;
			}
			var botAIItem:AiItem = new AiItem();
			GroupGameObject.copyData(aiItem, botAIItem);
			
			botAIItem.objectLevel = Math.round( Math.random()*levelComponent.currentLevel );
			if(botAIItem.objectLevel > 2){
				botAIItem.objectLevel = 2;
			}
			if(botAIItem.objectLevel < levelComponent.currentLevel){
				var levelDiff:Number = levelComponent.currentLevel - botAIItem.objectLevel; 
				botAIItem.healthDivider -= 0.35*levelDiff;
				botAIItem.damageDivider -= 1*levelDiff;
				botAIItem.setStats();
				//botAIItem.delayDivider -= 
			}
			
			bot.x = MainHullSprite.x + botAIItem.levelShipGraphicParameters[botAIItem.objectLevel][2]/2;
			bot.y = MainHullSprite.y - botAIItem.levelShipGraphicParameters[botAIItem.objectLevel][3];
			bot.createBot(buildingTarget, levelComponent.currentLevel, botAIItem);
			
			if(unitTarget != null){
				bot.movementComponent.moveLocationTarget = unitTarget
			}
			bot.movementComponent.PhysicalSprite.velocity.y -= bot.movementComponent.thrustForce.y;
			
			bot.gunComponent.shotDamage += botShotBonus;
			//levelComponent.currentExperience += 30;
			createdBots.push(bot);
			objectCreatedCallback(bot,null,null,null);
		}
		
		/**
		 * Takes an array of weights, and returns a random index based on the weights
		 */
		private function randomIndexByWeights( weights:Array ) : int
		{
			// add weights
			var weightsTotal:Number = 0;
			for( var i:int = 0; i < weights.length; i++ ) weightsTotal += weights[i];
			// pick a random number in the total range
			var rand:Number = Math.random() * weightsTotal;
			// step through array to find where that would be 
			weightsTotal = 0;
			for( i = 0; i < weights.length; i++ )
			{
				weightsTotal += weights[i];
				if( rand < weightsTotal ) return i;
			}
			// if random num is exactly = weightsTotal
			return weights.length - 1;
		}		
				
		public function hullCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
			
		}

		/**
		 * Find closest enemy Village
		 * @param buildingGroup
		 * @return true if enemy is found
		 * 
		 */
		override public function findTarget(group:FlxGroup):Boolean
		{
			var currentTarget:FlxObject;
			var shortestDistance:Number = 99999;
			var distance:Number;
			var currentObjectDistanceCheck:GroupGameObject;
			for (var j:int = 0 ; j < group.members.length ; j++){
				if(group.members[j] is GroupGameObject){
					currentObjectDistanceCheck = group.members[j];
					if(isEnemy != currentObjectDistanceCheck.isEnemy && 
						currentObjectDistanceCheck.dead == false ){
						distance = Math.sqrt( 	(currentObjectDistanceCheck.x - x)*(currentObjectDistanceCheck.x - x) +
							(currentObjectDistanceCheck.y - y)*(currentObjectDistanceCheck.y - y) );
						if(shortestDistance > distance){
							shortestDistance = distance
							currentTarget = group.members[j]; 
						}
					}
				}
			}
			if(currentTarget != null){
				buildingTarget = currentTarget;
				return true
			} else {
				return false
			}
		}
		
		public function addTarget(target:FlxPoint, targetId:String = "", name:String=""):void
		{
			var buildingTargetUIIndicator:VillageUnitTarget = new VillageUnitTarget(null,this);
			buildingTargetUIIndicator.id = targetId;
			buildingTargetUIIndicator.nameOfLocation = name;
			buildingTargetUIIndicator.targetLocation = target;
			
			var dx:Number = target.x - x;
			var dy:Number = target.y - y;
			var length:Number = Math.sqrt(dx*dx + dy*dy);
			var desiredLength:Number = length - 0;
			var percentage:Number = desiredLength/length;
			
			buildingTargetUIIndicator.x = x + Math.round(dx*percentage);
			buildingTargetUIIndicator.y = y + Math.round(dy*percentage);
			buildingTargetUIIndicators.push(buildingTargetUIIndicator);
			(FlxG.state as PlayState).effectDisplays.add(buildingTargetUIIndicator.graphicHolder);
			
			evenlyWeightBuildingTargets();
		}
		
		public function removeTarget(indexToRemove:String):void
		{
			var amountToRedistribute:Number = 0;
			for (var i:int = 0 ; i <  buildingTargetUIIndicators.length ; i++){
				if(buildingTargetUIIndicators[i].id == indexToRemove){
					(FlxG.state as PlayState).GameUIDialogueGroup.remove(buildingTargetUIIndicators[i].graphicHolder);
					buildingTargetUIIndicators.splice(i,1);
				}
			}
		}	
		
		public var targetWeights:Array = new Array();
		public var unitsSentToEachTarget:Array = new Array();
		public function evenlyWeightBuildingTargets():void
		{
			var percentageForEachItem:Number = Math.floor( 100/buildingTargetUIIndicators.length) ;
			var i:int = 0;
			for (i = 0 ; i < buildingTargetUIIndicators.length ; i++ ){
				buildingTargetUIIndicators[i].percentageUnitsSentHere = percentageForEachItem;
			}
		}
		
		public function canTargetChangeToValue(value:int, id:String):Boolean
		{
			var totalPercentageAmount:Number = 0;
			for (var i:int = 0 ; i < buildingTargetUIIndicators.length ; i++ ){
				if(buildingTargetUIIndicators[i].id == id){
					totalPercentageAmount += value;
				} else {
					totalPercentageAmount += buildingTargetUIIndicators[i].percentageUnitsSentHere;
				}
			}
			if(totalPercentageAmount >= 100 || totalPercentageAmount < 0){
				return false
			}
			return true
		}
		
		public function refreshTargetVisibilities():void
		{
			if(isEnemy == false){
				for (var i:int = 0 ; i <  buildingTargetUIIndicators.length ; i++){
					buildingTargetUIIndicators[i].showComponent = villageInfoDialogue.showComponent;
					buildingTargetUIIndicators[i].update();
				}
			} else {
				for (var i:int = 0 ; i <  buildingTargetUIIndicators.length ; i++){
					buildingTargetUIIndicators[i].showComponent = false;
					buildingTargetUIIndicators[i].update();
				}				
			}
		}
		
		override public function render():void
		{
			super.render();
			
			if( (FlxG.state as PlayState).isFrozen == true &&
				isEnemy == false &&
				(FlxG.state as PlayState).gameStarted == true &&
				villageInfoDialogue.showComponent == true
			) {
				var drawCanvas:Shape=new Shape();
				
				var maxLineWidth:Number = 20;
				for (var i:int = 0 ; i < buildingTargetUIIndicators.length ; i++){
					//buildingTargets[i]
					var screenStartLocation:FlxPoint = MainHullSprite.getScreenXY();
					var screenEndLocation:FlxPoint;
					var relativePoint:FlxPoint = new FlxPoint( buildingTargetUIIndicators[i].targetLocation.x - MainHullSprite.x,buildingTargetUIIndicators[i].targetLocation.y - MainHullSprite.y);
					screenEndLocation = new FlxPoint(screenStartLocation.x + relativePoint.x,screenStartLocation.y + relativePoint.y);
	
					//drawCanvas.graphics.lineStyle(3,0xFF00FF);
						
					//drawCanvas.graphics.moveTo(screenStartLocation.x+MainHullSprite.width/2,screenStartLocation.y+MainHullSprite.height/2);
					//drawCanvas.graphics.lineTo(screenEndLocation.x,screenEndLocation.y);

					var dx:Number = screenEndLocation.x - (screenStartLocation.x+MainHullSprite.width/2);
					var dy:Number = screenEndLocation.y - (screenStartLocation.y+MainHullSprite.height/2);
					var distance:Number = Math.sqrt(dx*dx+dy*dy);					
					
					var dashy:DashedLine = new DashedLine( 
						((buildingTargetUIIndicators[i].percentageUnitsSentHere+1)/100)*maxLineWidth,0,
						[	10,
							5
						]
					);
					dashy.moveTo(screenStartLocation.x+MainHullSprite.width/2,screenStartLocation.y+MainHullSprite.height/2);
					dashy.lineTo(screenEndLocation.x,screenEndLocation.y);
					
					FlxG.buffer.draw(dashy);
				}
				
			}
			
		}		
		
		
		public function sellMineral(acquiredItem:AcquiredItem):void
		{
			availableResources += acquiredItem;
			levelComponent.currentExperience += 100;
		}
		
		override public function showInfo():void{
			villageInfoDialogue.showComponent = true;
		}
		
		override public function botOverlapsBuilding(bot:Bot):void
		{

		}	
		
		public function countAliveUnits():Number{
			var aliveCount:Number = 0;
			for (var i:int = 0 ; i < createdBots.length ;i++){
				if( createdBots[i].dead == false){
					aliveCount++
				}
			}
			return aliveCount
		}
		
		override public function levelUp(level:Number):void {
			if(level < LevelData.LevelCreationData[PlayerStats.currentLevelId][9] && level < 3){
				if(isEnemy == true){
					SoundController.playSoundEffect("SfxEnemyVillageUpgraded");
				} else {
					SoundController.playSoundEffect("SfxFriendlyVillageUpgraded");
				}

				if( initialVillageLevelSet == true){
					villagePopulation = VillageInfoGenerator.generatePopulation(levelComponent.currentLevel+1);
					//villageMaxPopulation = villagePopulation + levelComponent.maxLevel;
				}
				villageResourceGrowth = aiItem.villageResourceGrowth[level];
				shipResourceCost = aiItem.levelShipResourceCost[level];
				
				EffectController.displayMessageAtPoint(MainHullSprite.x,MainHullSprite.y,"Leveled up!");
				if(aiItem != null){
					MainHullSprite.loadGraphic(
						aiItem.villageGraphics[level],
						aiItem.villageGraphicParams[level][0],
						aiItem.villageGraphicParams[level][1],
						aiItem.villageGraphicParams[level][2],
						aiItem.villageGraphicParams[level][3] 
					);
				}
/*				
				if(level == 1){
					MainHullSprite.x = MainHullSprite.x-(46-MainHullSprite.width);
					MainHullSprite.y = MainHullSprite.y-(46-MainHullSprite.height);
					MainHullSprite.loadGraphic(Resources.FortressLevel1, true, true, 46,46 );
				} else if(level == 2){
					MainHullSprite.x = MainHullSprite.x-(69-MainHullSprite.width);
					MainHullSprite.y = MainHullSprite.y-(69-MainHullSprite.height);
					MainHullSprite.loadGraphic(Resources.FortressLevel2, true, true, 69,69 );
				}*/
			} else {
				levelComponent.currentLevel--;
			}
			
		}
		override public function destroyObject():void
		{
			if(isEnemy == true){
				SoundController.playSoundEffect("SfxEnemyVillageDestroyed");
			} else {
				SoundController.playSoundEffect("SfxFriendlyVillageDestroyed");
			}
			FlxG.flash.start(0xFFFFFFFF,.15,null,true);
			FlxG.quake.start(0.05,0.5);
			
			EffectController.explodeAtPoint(MainHullSprite,"EffectWreckageSmall", 9,15,1);
			
			var effectName:String = "";
			if(levelComponent.currentLevel == 0){
				effectName = "EffectSmallShockwave";
			} else if(levelComponent.currentLevel == 1){
				effectName = "EffectMediumShockwave";
			} else if(levelComponent.currentLevel == 2){
				effectName = "EffectLargeShockwave";
			}
			EffectController.showEffectAnimation(
				effectName,
				LevelData.effectData[effectName][0],
				LevelData.effectData[effectName][1],
				new Point(
					MainHullSprite.x + MainHullSprite.width/2,
					MainHullSprite.y + MainHullSprite.height/2),
				LevelData.effectData[effectName][2]
			);			
			
			effectName = "EffectVillageDeathShockwave";
			EffectController.showEffectAnimation(
				effectName,
				LevelData.effectData[effectName][0],
				LevelData.effectData[effectName][1],
				new Point(
					MainHullSprite.x + MainHullSprite.width/2,
					MainHullSprite.y + MainHullSprite.height),
				LevelData.effectData[effectName][2]
			);
			
			super.destroyObject();
		}

			
	}
}