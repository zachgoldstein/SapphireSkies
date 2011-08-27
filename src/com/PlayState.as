package com 
{

	import Playtomic.*;
	
	import com.BaseLevel;
	import com.Player;
	import com.bit101.components.PushButton;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.vexhel.FlxPathfinding;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	import zachg.GameInterface;
	import zachg.GroupGameObject;
	import zachg.MainMenu;
	import zachg.PlayerStats;
	import zachg.gameObjects.Bot;
	import zachg.gameObjects.BuildingGroup;
	import zachg.gameObjects.BulletGroup;
	import zachg.gameObjects.CallbackSprite;
	import zachg.gameObjects.CivilianBot;
	import zachg.gameObjects.Crystal;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.HostileAirBot;
	import zachg.gameObjects.MiningBot;
	import zachg.gameObjects.PlayerGroup;
	import zachg.gameObjects.ResourceBot;
	import zachg.gameObjects.Shop;
	import zachg.gameObjects.Village;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.states.StatsState;
	import zachg.ui.dialogues.InteruptDialogue;
	import zachg.util.EffectController;
	import zachg.util.GameMessageController;
	import zachg.util.GenericDisplay;
	import zachg.util.LevelData;
	import zachg.util.LevelGenerator;
	import zachg.util.Noise;
	import zachg.util.SoundController;
	import zachg.util.levelEvents.LevelEvent;
	import zachg.util.levelEvents.NarrativeTrigger;
	import zachg.windows.TutorialWindow;
	
	public class PlayState extends FlxState
	{
		//[Embed(systemFont = 'Verdana', embedAsCFF="true", fontName = 'VerdanaFont', mimeType = 'application/x-font')] private var fontVerdana:Class;
		//[Embed(systemFont='Arial', embedAsCFF="true", fontName='ArialFont', mimeType='application/x-font')] private var fontArial:Class;
		
		public var levelClassName:Class;
		
		public var currentLevel:BaseLevel;
		private var nextLevel:BaseLevel = null;
		public var player:PlayerGroup;
		
		public var gameInterface:GameInterface;
		public var mainMenu:MainMenu;
		public var gameGraphics:Sprite = new Sprite();
		
		public static var elaspedTime:Number = 0;
		private static var lastTime:uint = 0;
		
		private var bullets:FlxGroup = new FlxGroup;
		public var buildings:FlxGroup = new FlxGroup;
		public var crystals:FlxGroup = new FlxGroup;
		public var bots:FlxGroup = new FlxGroup;
		
		private var friendlyBullets:FlxGroup = new FlxGroup;
		private var enemyBullets:FlxGroup = new FlxGroup;
		public var friendlyBuildings:FlxGroup = new FlxGroup;
		public var enemyBuildings:FlxGroup = new FlxGroup;
		public var friendlyBots:FlxGroup = new FlxGroup;
		public var enemyBots:FlxGroup = new FlxGroup;
		
		//For bots where overlap with the player toggles something
		public var specialBots:FlxGroup = new FlxGroup;
		
		private var civilianBots:FlxGroup = new FlxGroup;
		public var hostileBots:FlxGroup = new FlxGroup;
		
		public var enemyGroup:FlxGroup = new FlxGroup;
		public var friendlyGroup:FlxGroup = new FlxGroup;
		
		public var effectDisplays:FlxGroup = new FlxGroup;
		
		private var coinsGroup:FlxGroup = new FlxGroup;
		private var platformsGroup:FlxGroup = new FlxGroup;
		private var triggersGroup:FlxGroup = new FlxGroup;
		
		public var GameUIDialogueGroup:FlxGroup = new FlxGroup;
		
		private var ids:Dictionary = new Dictionary(true);
		
		public var gameStarted:Boolean = false;
		
		public var timeSinceLastPrune:Number = 0;
		public var objectPruneFrequency:Number = 1000;
		
		public var startTime:Date;
		public var endTime:Date;
		
		public var isFrozen:Boolean = false;
		private var _doChangeFrozenState:Boolean = false;
		
		public var cameraObject:FlxSprite = new FlxSprite();
		public var trackedLevelStart:Boolean = false;
		
		public var pathFinder:FlxPathfinding;
		
		public var stageMoveEnabled:Boolean = true;
		
		public var objectHolder:FlxGroup = new FlxGroup();
		
		public function PlayState(levelName:Class):void
		{
			transitionIn();
			levelClassName = levelName;
			super();
		}

		
		override public function create():void
		{			
			super.create();
						
			FlxG.mouse.hide();
			flash.ui.Mouse.show();
			startTime = new Date();

			FlxG._game.useDefaultHotKeys = false;
			if(PlayerStats.initialized == false){
				PlayerStats.initializeStats();
			}
			var loggingLevelTite:String = "I"+PlayerStats.currentLevelDataVo.levelId+" "+LevelData.LevelTitles[PlayerStats.currentLevelDataVo.levelId];
			var currentEquip:Number = PlayerStats.currentPlayerDataVo.currentPlayerEquip;
			Log.LevelRangedMetric("currentPlayerEquip", loggingLevelTite, (currentEquip+1));	
			Log.LevelCounterMetric("LevelStarted", loggingLevelTite); // names must be alphanumeric				
			
			PlayerStats.currentLevelDataVo.shotsFired = 0;
			PlayerStats.currentLevelDataVo.shotsHit = 0;
			PlayerStats.currentLevelDataVo.thrustSpent = 0;
			PlayerStats.currentLevelDataVo.areaMined = 0;
			PlayerStats.currentLevelDataVo.resourcesEarned = 0;
			PlayerStats.currentLevelDataVo.cashBalance = 0;
			PlayerStats.currentLevelDataVo.kills = 0;
			
			//TODO: LUA does not export property for line breaks in word boxes. They need to be fixed bya hand. :(
			currentLevel = LevelGenerator.createLevel(true, PlayerStats.currentLevelDataVo.levelId, onObjectAddedCallback);
			if(levelClassName != null){
				//currentLevel = new levelClassName(true, onObjectAddedCallback);
			}
			
			if( gameInterface == null){
				gameInterface = new GameInterface();
				addChild(gameInterface);
				addChild(gameGraphics);
			}
						
			//var buttonTest:PushButton = new PushButton(guiLayer,100,100,"TESTING");
			
			//properties for rollover hitarea.
			mouseCollisionCheckObject.width = 20;
			mouseCollisionCheckObject.height = 20;
			mouseCollisionCheckObject.solid = true;
			mouseCollisionCheckObject.active = true;
			mouseCollisionCheckObject.visible = false;
			mouseCollisionCheckObject.loadGraphic(Resources.UIGameVillageTarget,false,false,31,32);
			add(mouseCollisionCheckObject);
			
			cameraObject.width = 1;
			cameraObject.height = 1;
			cameraObject.x = BaseLevel.boundsMaxX/2
			cameraObject.y = BaseLevel.boundsMaxY/2
			cameraObject.solid = true;
			cameraObject.active = true;
			cameraObject.visible = false;
			add(cameraObject);			
			
			setupPaths(currentLevel);
			setInitialBuildingTargets();
			//FlxG.showBounds = true;			
			
			// Initialise the camera.
			FlxG.follow(player.MainHullSprite, 2.5);
			FlxG.followAdjust(0.5, 0.2);
			FlxG.followBounds(BaseLevel.boundsMinX + 1, BaseLevel.boundsMinY + 1, BaseLevel.boundsMaxX - 1, BaseLevel.boundsMaxY - 1);

			add(effectDisplays);
			pathFinder = new FlxPathfinding(currentLevel.hitTilemaps.members[0] as FlxTilemap);
			
			SoundController.playSong(LevelData.LevelCreationData[PlayerStats.currentLevelDataVo.levelId][23]); 
			SoundController.isMenuMusicPlaying = false;
			
			update();
			player.update();

			if ( (FlxG.state as PlayState).isFrozen == false){
				(FlxG.state as PlayState).doChangeFrozenState = true;
			}
			stage.focus = this;
			stage.focus = null;
			stageMoveEnabled = false;
			
			if (PlayerStats.currentPlayerDataVo.currentPlayerName == ""){
				GameMessageController.showNameInputWindow(startInitialLevelDialogues);
			} else {
				startInitialLevelDialogues();
			}
			stage.focus = this;
			stage.focus = null;
			
		}
		
		public function startInitialLevelDialogues(e:MouseEvent = null):void
		{
			GameMessageController.playLevelDialogues(LevelData.StartLevelEvents, finishedStartDialogues);
		}
		
		public function finishedStartDialogues(params:Array = null):void
		{
			var hasLevelTutBeenShown:Boolean = false;
			for( var i:int = 0 ; i < (PlayerStats.currentPlayerDataVo.tutorialsShown as Array).length ; i++){
				if ((PlayerStats.currentPlayerDataVo.tutorialsShown as Array)[i] == PlayerStats.currentLevelId){
					hasLevelTutBeenShown = true;
				}
			}				
			if(hasLevelTutBeenShown == false && LevelData.LevelTipData[PlayerStats.currentLevelId][0] != null){
				(PlayerStats.currentPlayerDataVo.tutorialsShown as Array).push(PlayerStats.currentLevelId);
				PlayerStats.saveCurrentPlayerData();
				
				GameMessageController.showTutorialTips(
					LevelData.LevelTipData[PlayerStats.currentLevelId][0],
					LevelData.LevelTipData[PlayerStats.currentLevelId][1],
					LevelData.LevelTipData[PlayerStats.currentLevelId][2],
					hasLevelTutBeenShown,
					showShipTutorial);
			} else {
				showShipTutorial();
			}
			//PlayerStats.currentPlayerDataVo.basicPlayTutorialShown = true;
			//PlayerStats.saveCurrentPlayerData();
/*			if(PlayerStats.currentPlayerDataVo.basicPlayTutorialShown == false){
			} else {
				showShipTutorial();
			}
*/		}
		
		public function showShipTutorial():void
		{
			var hasShipTutBeenShown:Boolean = false;
			for( var i:int = 0 ; i < (PlayerStats.currentPlayerDataVo.shipTutorialsShown as Array).length ; i++){
				if ((PlayerStats.currentPlayerDataVo.shipTutorialsShown as Array)[i] == PlayerStats.currentPlayerDataVo.currentPlayerEquip){
					hasShipTutBeenShown = true;
				}
			}
			if(hasShipTutBeenShown == false){
				if( PlayerStats.currentPlayerDataVo.currentPlayerEquip != -1 ){
					if( (PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).tutorialTipData != null ){
						(PlayerStats.currentPlayerDataVo.shipTutorialsShown as Array).push(PlayerStats.currentPlayerDataVo.currentPlayerEquip);
						GameMessageController.showTutorialTips(
							(PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).tutorialTipData[0],
							(PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).tutorialTipData[1],
							(PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).tutorialTipData[2],
							false,
							startGame);
					} else {
						startGame();
					}
				} else {
					startGame();
				}
			} else {
				startGame();
			}			
		}
		
		public function startGame():void
		{
			if(FlxG.state is PlayState){
			} else {
				return
			}
			
			gameStarted = true;
			stageMoveEnabled = true;
			if ( (FlxG.state as PlayState).isFrozen == true){
				(FlxG.state as PlayState).doChangeFrozenState = true;
			} else if ( (FlxG.state as PlayState).doChangeFrozenState == true){
				(FlxG.state as PlayState).doChangeFrozenState = false;
			}
			stage.focus = this;
			stage.focus = null;
			stageMoveEnabled = true;			
		}
		
		/**
		 * goes through all the buildings on the current level and sets appropriate targets for each one 
		 * the method of finding the target for each building is determined by the building itself
		 */
		public function setInitialBuildingTargets():void{
			var currentBuilding:BuildingGroup
			for( var i:int = 0 ; i< buildings.members.length ; i++){
				//(buildings.members[i] as Village).villageInfoDialogue.buildTargetOptions();
				
/*				currentBuilding = buildings.members[i];
				currentBuilding.findTarget(buildings);
				(currentBuilding as Village).addTarget( 
					new FlxPoint( 	(currentBuilding as Village).buildingTarget.x + (currentBuilding as Village).width/2 ,
									(currentBuilding as Village).buildingTarget.y + (currentBuilding as Village).height/2 ),
					((currentBuilding as Village).buildingTarget as Village).id,
					((currentBuilding as Village).buildingTarget as Village).villageName
				);*/
			}
		}
		
		private var objectCounter:int = 1;
		protected function onObjectAddedCallback(obj:Object, layer:FlxGroup, level:BaseLevel, properties:Array):Object
		{
			if(obj is FlxObject){
				(obj as FlxObject).uid = objectCounter;
				objectHolder.add( (obj as FlxObject) );
				objectCounter++;
			}
			
			if ( properties )
			{
				var i:uint = properties.length;
				while(i--)
				{
					if ( properties[i].name == "id" )
					{
						var name:String = properties[i].value;
						ids[name] = obj;
						break;
					}
				}
			}
			if (obj is PlayerGroup)
			{
				player = obj as PlayerGroup;
				friendlyGroup.add(obj as PlayerGroup);
				hostileBots.add(obj as PlayerGroup);
			} 
			else if(obj is BulletGroup){
				bullets.add(obj as BulletGroup);
				currentLevel.masterLayer.add(obj as BulletGroup);
				
				if( (obj as BulletGroup).isEnemy == false){
					friendlyGroup.add(obj as BulletGroup);
					friendlyBullets.add(obj as BulletGroup);
				} else {
					enemyGroup.add(obj as BulletGroup);
					enemyBullets.add(obj as BulletGroup);
				}
			}
			else if(obj is Bot){
				if(obj is CivilianBot || obj is ResourceBot){
					civilianBots.add(obj as Bot);
				} else {
					hostileBots.add(obj as Bot);
				}
				bots.add(obj as Bot);
				currentLevel.masterLayer.add(obj as Bot);
				
				if( (obj as Bot).isEnemy == false){
					friendlyGroup.add(obj as Bot);
					friendlyBots.add(obj as Bot);
				} else {
					enemyGroup.add(obj as Bot);
					enemyBots.add(obj as Bot);
				}
				
				if( (obj as Bot).isEnemy == false && (obj is MiningBot) ){
					specialBots.add(obj as MiningBot);
				}
			}
			else if(obj is BuildingGroup){
				buildings.add(obj as BuildingGroup);
				if( (obj as BuildingGroup).isEnemy == false){
					friendlyGroup.add(obj as BuildingGroup);
					friendlyBuildings.add(obj as BuildingGroup);
					//(obj as BuildingGroup).MainHullSprite.color = 0xADDFFF;
				} else {
					enemyGroup.add(obj as BuildingGroup);
					enemyBuildings.add(obj as BuildingGroup);
					//(obj as BuildingGroup).MainHullSprite.color = 0xF75D59;
				}
			}
			else if(obj is Crystal){
				crystals.add(obj as Crystal);
				if( (obj as Crystal).isEnemy == false){
					friendlyGroup.add(obj as Crystal);
					friendlyBuildings.add(obj as Crystal);
				} else {
					enemyGroup.add(obj as Crystal);
					enemyBuildings.add(obj as Crystal);
				}
			}
			else if (obj is FlxTilemap){
				if ( properties )
				{
					var j:uint = properties.length;
					while(j--)
					{
						(obj as FlxTilemap).dataObject[ properties[j].name ] = properties[j].value;
					}
				}			
			}
			else if (obj is Coin)
			{
				coinsGroup.add(obj as FlxSprite);
			}
			else if ( obj is Platform )
			{
				platformsGroup.add(obj as FlxSprite);
			}
			else if ( obj is TextData )
			{
				var tData:TextData = obj as TextData;
				if ( tData.fontName != "" && tData.fontName != "system" )
				{
					tData.fontName += "Font";
				}
				return level.addTextToLayer(tData, layer, true, properties, onObjectAddedCallback );
			}
			else if ( obj is BoxData )
			{
				// Create the trigger.
				var bData:BoxData = obj as BoxData;
				var box:Trigger = new Trigger(bData.x, bData.y, bData.width, bData.height);
				level.addSpriteToLayer(box, FlxSprite, layer, box.x, box.y, bData.angle);
				triggersGroup.add(box);
				if ( properties )
				{
					i = properties.length;
					while(i--)
					{
						if ( properties[i].name == "target" )
						{
							box.target = properties[i].value;
							break;
						}
					}
				}
				return box;
			}
			else if ( obj is ObjectLink )
			{
				//Links the crystal to the appropriate buildings.
				(( obj as ObjectLink ).fromObject as Crystal).linkedBuildings.push( ( obj as ObjectLink ).toObject );
			}
			return obj;
		}
		
		private function setupPaths(level:BaseLevel):void
		{
			for ( var i:uint = 0; i < level.paths.length; i++ )
			{
				var platform:Platform = level.paths[i].childSprite as Platform;
				if( platform != null )
				{
					platform.path = level.paths[i];
				}
			}
		}

		public var switchTest:Boolean = false;
		public var testingSprite:GenericDisplay;
		override public function update():void
		{
			if(trackedLevelStart == false){
				trackedLevelStart = true;
			}
			
			if(doChangeFrozenState == true){
				cameraObject.x = player.MainHullSprite.x;
				cameraObject.y = player.MainHullSprite.y;
				if(isFrozen == false){
					changeFrozenState(true);
					doChangeFrozenState = false;
					isFrozen = true;
				} else {
					changeFrozenState(false);
					doChangeFrozenState = false;
					isFrozen = false;
				}
			}
			
			if(timeSinceLastPrune > objectPruneFrequency){
				pruneObjects();
				timeSinceLastPrune = 0;
			} else {
				timeSinceLastPrune++;
			}
			
			gameInterface.refresh();
			var time:uint = getTimer();
			elaspedTime = (time - lastTime) / 1000;
			lastTime = time;
			EffectController.update();
			super.update();
			
			mouseCollisionCheckObject.visible = false;
			showInfoForObject();
			refreshVillageInfoDialogues();
			
/*			if (FlxG.keys.pressed("ESCAPE"))
			{
				// Restart
				GlobalVariables.doRestart = true;
				FlxG.state = new PlayState(null);
				//(FlxG.state as PlayState).create();
			}
*/			
			if( FlxG.keys.justPressed("T") && FlxG._game._console.visible == false && gameStarted == true){
				doChangeFrozenState = true;
			}
			if( FlxG.keys.justPressed("C") && FlxG._game._console.visible == false && gameStarted == true){
				gameInterface.toggleCargo();
			}
			if( FlxG.keys.justPressed("M") && FlxG._game._console.visible == false && gameStarted == true){
				gameInterface.gotoMenu();
			}
			if( FlxG.keys.justPressed("P") && FlxG._game._console.visible == false && gameStarted == true){
				gameInterface.pauseGame();
			}
			
			if(isFrozen == true && FlxG._game._console.visible == false && stageMoveEnabled == true){
				moveCamera();
				return
			}

			if (countTeams() == true){
				return
			}
			
			dealWithUnitsOutOfBounds();
			
			// map collisions
			currentLevel.hitTilemaps.collideCallback(player.MainHullSprite,playerOverlap);
			
			currentLevel.hitTilemaps.collide(bullets);
			currentLevel.hitTilemaps.collide(bots);
			currentLevel.hitTilemaps.collide(specialBots);
			
			//player and object collisions
			//FlxU.overlap(coinsGroup, player.MainHullSprite, CoinCollected);
			//FlxU.overlap(triggersGroup, player.MainHullSprite, TriggerEntered);
			FlxU.overlap(buildings, player.MainHullSprite, playerOverlapsBuilding);
			//FlxU.collide(platformsGroup, player.MainHullSprite);
			//FlxU.overlap(bots, bots, botOverlapBot);
			//FlxU.overlap(civilianBots, buildings, botOverlapsBuilding);
			FlxU.overlap(specialBots, player.MainHullSprite, specialBotOverlapsPlayer);
			
			//FlxU.collide(friendlyGroup,enemyGroup);
			
			//FlxU.collide(friendlyBullets, enemyBots);
			FlxU.overlap(friendlyBullets, enemyBots, bulletUnitOverlap);
			FlxU.overlap(friendlyBullets, enemyBuildings, bulletUnitOverlap);
			FlxU.overlap(enemyBullets, player.MainHullSprite, bulletUnitOverlap);
			FlxU.overlap(enemyBullets, friendlyBuildings, bulletUnitOverlap);
			FlxU.overlap(enemyBullets, friendlyBots, bulletUnitOverlap);
			
			//FlxU.collide(enemyBots, friendlyBots);
			
			//FlxU.collide(crystals, player.MainHullSprite);
			//FlxU.collide(bullets, crystals);
			//FlxU.collide(enemyBuildings, player.MainHullSprite);
			
			if(player.healthComponent.currentHealth < 0){
				if(switchTest != true){
					loseLevel("Your ship got blown up");
					switchTest = true;
				}
			}
			
		}
		
		private function bulletUnitOverlap(bot1:CallbackSprite, object2:CallbackSprite):void
		{
			(bot1.rootObject as BulletGroup).bulletCollision(object2,0,"");
			
			
			//(bot2.rootObject as )
		}
		
		private function dealWithUnitsOutOfBounds():void
		{
			for ( var i:int = 0 ; i < enemyBots.members.length ; i++){
				modifyUnitVelocityOutsideBound( (enemyBots.members[i] as Bot).movementComponent.PhysicalSprite );
			}
			for ( var i:int = 0 ; i < friendlyBots.members.length ; i++){
				modifyUnitVelocityOutsideBound( (friendlyBots.members[i] as Bot).movementComponent.PhysicalSprite );
			}
			modifyUnitVelocityOutsideBound(player.MainHullSprite);
			
		}
		
		private function modifyUnitVelocityOutsideBound(sprite:FlxSprite):void
		{
			if(sprite.x < BaseLevel.boundsMinX){
				sprite.velocity.x += (sprite.maxVelocity.x/2);
			}
			if((sprite.x+sprite.width) > BaseLevel.boundsMaxX){
				sprite.velocity.x -= (sprite.maxVelocity.x/2);
			}
			if(sprite.y < BaseLevel.boundsMinY){
				sprite.velocity.y += (sprite.maxVelocity.y/2);
			}
			if((sprite.y+sprite.height) > BaseLevel.boundsMaxY){
				sprite.velocity.y -= (sprite.maxVelocity.y/2);
			}
		}
		
		private function changeFrozenState(doFreeze:Boolean):void
		{
			for (var i:int = 0 ; i < bots.members.length ; i++){
				if( bots.members[i] is GroupGameObject){
					(bots.members[i] as GroupGameObject).isFrozen = doFreeze;
				}
			}
			for (var i:int = 0 ; i < buildings.members.length ; i++){
				if( buildings.members[i] is GroupGameObject){
					(buildings.members[i] as GroupGameObject).isFrozen = doFreeze;
				}
			}
			for (var i:int = 0 ; i < bullets.members.length ; i++){
				if( bullets.members[i] is GroupGameObject){
					(bullets.members[i] as GroupGameObject).isFrozen = doFreeze;
				}
			}
			player.isFrozen = doFreeze;
			
			if(doFreeze == false){
				FlxG.follow(player.MainHullSprite, 2.5);
			} else {
				FlxG.follow(cameraObject,2.5);
			}
			
			if(doFreeze == false){
				setVillageInfoDialoguesVisibility(false);
			} else {
				if(gameStarted == true){
					//setVillageInfoDialoguesVisibility(true);
				}
			}
				
		}

		private function pruneObjects():void
		{
			for (var i:int = 0 ; i < friendlyGroup.members.length ; i++){
				if( (friendlyGroup.members[i] as FlxObject).dead == true){
					friendlyGroup.remove(friendlyGroup.members[i],true);
				}
			}
			for (i = 0 ; i < enemyGroup.members.length ; i++){
				if( (enemyGroup.members[i] as FlxObject).dead == true){
					enemyGroup.remove(enemyGroup.members[i],true);
				}
			}
		}
		
		//this is fucked. gotta be a better way.
		private function countTeams():Boolean
		{
			var team1Count:Number = 0;
			var team2Count:Number = 0;
			for (var i:int = 0 ; i < buildings.members.length ; i++ ){
				if ( (buildings.members[i] as BuildingGroup).exists == true){
					if ( (buildings.members[i] as BuildingGroup).isEnemy == true){
						team1Count++;
					} else {
						team2Count++;
					}
				}
			}
			if(team2Count == 0){
				switchTest = true;
				loseLevel("All allies were destroyed");
				return true
			} else if(team1Count == 0){
				switchTest = true;
				winLevel("All enemies were destroyed");
				return true
			}
			return false
		}
		
		private function playerOverlap(tileMap:FlxTilemap,object:FlxObject):void
		{
			//trace("collided");
			//tileMap.getTilesInArea(object.x,object.y,object.width,object.height);
			
		}
		
		private function botOverlapBot(bot1:CallbackSprite,bot2:CallbackSprite):void
		{
			if(bot1 == bot2){
				return
			}
			if(bot1.rootObject is CivilianBot && bot2.rootObject is CivilianBot) {
				FlxU.collide(bot1,bot2);
			} else if(bot1.rootObject is CivilianBot || bot2.rootObject is CivilianBot){
				
			} else {
				FlxU.collide(bot1,bot2);
			}
		}
		
		private function playerOverlapsBuilding(building:CallbackSprite,bot:CallbackSprite):void
		{
			if( (building.rootObject is BuildingGroup) ){
				//give player resources and sell minerals
/*				if( building.rootObject is Shop){
					if( ( building.rootObject as Shop).isEnemy == false){
						var totalMineralValue:Number = (building.rootObject as Shop).shopDetailedInfo.sellAll();
						if(totalMineralValue > 0){
							EffectController.displayMessageAtPoint(	(building.rootObject as Shop).MainHullSprite.x,
																	(building.rootObject as Shop).MainHullSprite.y - 15,
																	"Sold "+totalMineralValue+" worth of minerals");
						}
						var equipedItemTitle:String = (building.rootObject as Shop).shopDetailedInfo.equip();
						if(equipedItemTitle != null){
							EffectController.displayMessageAtPoint(	(building.rootObject as Shop).MainHullSprite.x,
								(building.rootObject as Shop).MainHullSprite.y,
								"Equipped "+equipedItemTitle);
						}
					}
				}*/
				if( building.rootObject is Village){
					if( ( building.rootObject as Village).isEnemy == false){
						var totalMineralValue:Number = (building.rootObject as Village).villageInfoDialogue.sellAll();
						if(totalMineralValue > 0){
							SoundController.playSoundEffect("SfxMineBotDepositsMinerals");
							PlayerStats.currentLevelDataVo.resourcesEarned += totalMineralValue;
							PlayerStats.currentLevelDataVo.cashBalance += totalMineralValue;
							
							EffectController.displayMessageAtPoint(	(building.rootObject as Village).MainHullSprite.x,
								(building.rootObject as Village).MainHullSprite.y - 15,
								"Sold "+totalMineralValue+" worth of minerals");
						}
					}
				}	
				
				//(building.rootObject as BuildingGroup).showInfo();
			}
		}
		
		
		private function botOverlapsBuilding(bot:CallbackSprite,building:CallbackSprite):void
		{
			if(bot.rootObject is Bot && building.rootObject is BuildingGroup){
				(building.rootObject as BuildingGroup).botOverlapsBuilding((bot.rootObject as Bot));
				(bot.rootObject as Bot).botOverlapsBuilding(building.rootObject as BuildingGroup);
			}
		}

		private function specialBotOverlapsPlayer(bot:CallbackSprite,player:CallbackSprite):void
		{
			if(bot.rootObject is MiningBot && player.rootObject is PlayerGroup){
				(bot.rootObject as MiningBot).giveCargoToPlayer();
			}			
		}		
		
		private function CoinCollected(coin:FlxSprite, plr:FlxSprite):void
		{
			coin.kill();
		}
		
		// For the ClassReference trick to work the static is needed even if it's never assigned anything.
		//private static var area2:Level_Area2;
		
		private function TriggerEntered(trigger:Trigger, plr:FlxSprite):void
		{
			var target:Object = trigger.targetObject ? trigger.targetObject : ids[trigger.target];
			if ( target is Platform )
			{
				var platform:Platform = target as Platform;
				platform.StopMoving();
			}
			else
			{
				try
				{
					var ClassReference:Class = getDefinitionByName("com.Level_" + trigger.target ) as Class;
					if ( nextLevel == null && ClassReference)
					{
						nextLevel = new ClassReference(true, onObjectAddedCallback);
						setupPaths(nextLevel);
					}
				}
				catch ( error:Error)
				{
				}
			}
		}
		
		public var clickBlocker:Sprite;
		public var _endLevelSituation:String;
		public function winLevel(endLevelSituation:String = ""):void
		{
			//Tracking
			endTime = new Date();
			var timePlayedMilliSeconds:Number = endTime.getTime() - startTime.getTime();
			var loggingLevelTite:String = "I"+PlayerStats.currentLevelDataVo.levelId+" "+LevelData.LevelTitles[PlayerStats.currentLevelDataVo.levelId];
			Log.LevelAverageMetric("TimeMilliseconds", loggingLevelTite, timePlayedMilliSeconds);
			Log.LevelCounterMetric("LevelWon", loggingLevelTite);
			Log.ForceSend();
			//
			
			EffectController.stopNoise();
			
			//play end level music here
			SoundController.playEndLevelMusic(true);
			
			if ( (FlxG.state as PlayState).isFrozen == false){
				(FlxG.state as PlayState).doChangeFrozenState = true;
			}	
			if(player.isFrozen == true){
				update();
				player.isFrozen = false;
			} 
				
			clickBlocker = new Sprite();
			clickBlocker.graphics.beginFill(0xFFFFFF,.25);
			clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
			FlxG.state.addChild(clickBlocker);
			
			_endLevelSituation = endLevelSituation;
			
			var interuptDialogue:InteruptDialogue = new InteruptDialogue(
				winLevelDialogues,
				new Point(600/2-250/2,450/2-150/2),
				"\n \nMission Complete","Continue");
			interuptDialogue.showTip();		
		}
		
		public function winLevelDialogues():void
		{
			FlxG.state.removeChild(clickBlocker);
			GameMessageController.playLevelDialogues(LevelData.EndLevelEvents, finishedEndLevelDialogues, [true, _endLevelSituation,true, PlayerStats.currentLevelDataVo]);
			player.isFrozen = true;
		}
		
		
		public function loseLevel(endLevelSituation:String = ""):void
		{
			endTime = new Date();
			var timePlayedMilliSeconds:Number = endTime.getTime() - startTime.getTime();
			var loggingLevelTite:String = "I"+PlayerStats.currentLevelDataVo.levelId+" "+LevelData.LevelTitles[PlayerStats.currentLevelDataVo.levelId];
			Log.LevelAverageMetric("TimeMilliseconds", loggingLevelTite, timePlayedMilliSeconds);
			Log.LevelCounterMetric("LevelLost", loggingLevelTite);
			Log.ForceSend();
			EffectController.stopNoise();
			SoundController.playEndLevelMusic(false);
			if ( (FlxG.state as PlayState).isFrozen == false){
				(FlxG.state as PlayState).doChangeFrozenState = true;
			}
			if(player.isFrozen == true){
				update();
				player.isFrozen = false;
			} 
			
			clickBlocker = new Sprite();
			clickBlocker.graphics.beginFill(0xFFFFFF,.25);
			clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
			FlxG.state.addChild(clickBlocker);
			
			_endLevelSituation = endLevelSituation;
			
			var interuptDialogue:InteruptDialogue = new InteruptDialogue(
				loseLevelDialogues,
				new Point(600/2-250/2,450/2-150/2),
				"\n \nMission Failed","Continue");
			interuptDialogue.showTip();		
			
		}
		
		public function loseLevelDialogues():void
		{
			FlxG.state.removeChild(clickBlocker);
			finishedEndLevelDialogues([true, _endLevelSituation,false, PlayerStats.currentLevelDataVo]);
			player.isFrozen = true;
		}
		
				

		public var menuWarningToggled:Boolean = false;
		public function gotoMenu(e:Event = null):void
		{
			if(menuWarningToggled == false){
				menuWarningToggled = true;
				(FlxG.state as PlayState).stageMoveEnabled = false;
				(FlxG.state as PlayState).doChangeFrozenState = true;							
				

			}
		}		
		
		//SO FUCKING GHETTO>
		public var tempParamHolder:Array;
		public function finishedEndLevelDialogues(params:Array):void
		{
			GameMessageController.stopAllDialogues();
			tempParamHolder = params;
			transitionOut(finishedEndLevelDialoguesTransitionFinished);
		}
		public function finishedEndLevelDialoguesTransitionFinished():void
		{
			//objectHolder.m
			for (var i:int = 0 ; i < objectHolder.members.length ; i++){
				(objectHolder.members[i] as FlxObject).destroy();
				objectHolder.members[i] = null;
			} 	
			objectHolder.destroyMembers();
			objectHolder.destroy();
			
			var c:Object = FlxG._cache; // you will need to set _cache from protected to public namespace
			for each (var obj:* in c) {
				if (obj is BitmapData) obj.dispose();
			}
			FlxG._cache = null;
			FlxG._cache = new Object();
			
			FlxG.state = new StatsState(tempParamHolder[0],tempParamHolder[1],tempParamHolder[2],tempParamHolder[3])
		}

		private function startLevel():void
		{
			create();
		}
		
		private var currentObjects:Array = new Array();
		private var currentPoint:Point = new Point();
		public var mouseCollisionCheckObject:FlxSprite = new FlxSprite(); 
		private function showInfoForObject():void
		{
			mouseCollisionCheckObject.x = FlxG.mouse.x - mouseCollisionCheckObject.width/2;
			mouseCollisionCheckObject.y = FlxG.mouse.y - mouseCollisionCheckObject.height/2;
			FlxU.overlap(mouseCollisionCheckObject,friendlyGroup,testMouseCollide);
			FlxU.overlap(mouseCollisionCheckObject,enemyGroup,testMouseCollide);
//			currentPoint = new Point(FlxG.mouse.x,FlxG.mouse.y);
//			currentObjects = FlxG.state.getObjectsUnderPoint(currentPoint);
//			if(currentObjects.length > 0){
//				trace("more than one object");
//			}
		}
		
		private function setVillageInfoDialoguesVisibility(toggleDialogue:Boolean = false):void
		{
			for (var i:int = 0 ; i < friendlyBuildings.members.length ; i++){
				//(friendlyBuildings.members[i] as Village).resetInfoDialogue();
				(friendlyBuildings.members[i] as Village).villageInfoDialogue.showComponent = toggleDialogue;
				(friendlyBuildings.members[i] as Village).villageInfoDialogue.update();
			}
			for (var j:int = 0 ; j < enemyBuildings.members.length ; j++){
				//(enemyBuildings.members[j] as Village).resetInfoDialogue();
				(enemyBuildings.members[j] as Village).villageInfoDialogue.showComponent = toggleDialogue;
				(enemyBuildings.members[j] as Village).villageInfoDialogue.update();
			}
		}
		
		private function refreshVillageInfoDialogues():void
		{
			for (var i:int = 0 ; i < friendlyBuildings.members.length ; i++){
				(friendlyBuildings.members[i] as Village).villageInfoDialogue.update();
				(friendlyBuildings.members[i] as Village).refreshTargetVisibilities();
			}
			for (var j:int = 0 ; j < enemyBuildings.members.length ; j++){
				(enemyBuildings.members[j] as Village).villageInfoDialogue.update();
				(enemyBuildings.members[j] as Village).refreshTargetVisibilities();
			}			
		}
		
		public function removeVillage(id:String):void
		{
			for (var i:int = 0 ; i < friendlyBuildings.members.length ; i++){
				if( (friendlyBuildings.members[i] as Village).id != id){
					(friendlyBuildings.members[i] as Village).removeTarget(id);
				}
			}
			for (var j:int = 0 ; j < enemyBuildings.members.length ; j++){
				if( (enemyBuildings.members[j] as Village).id != id){
					(enemyBuildings.members[j] as Village).removeTarget(id);
				}
			}			
		}
				
		
		private function testMouseCollide(mouseTestSprite:FlxObject,genericFlxObject:FlxObject):void
		{
			if(isFrozen == true){
				if( genericFlxObject is CallbackSprite){
					if( (genericFlxObject as CallbackSprite).rootObject is Bot){
//						((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.showHealth = true;
//						((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.showHealthCounter = 0;
					} else if( (genericFlxObject as CallbackSprite).rootObject is Village){
						mouseCollisionCheckObject.visible = true;
						if(isFrozen == true && gameStarted == true){
							if(FlxG.mouse.pressed() == true){
								setVillageInfoDialoguesVisibility(false);
								((genericFlxObject as CallbackSprite).rootObject as Village).villageInfoDialogue.showComponent = true;
								((genericFlxObject as CallbackSprite).rootObject as Village).villageInfoDialogue.update();
							} else {
								
							}
						}
						
//						if(FlxG.mouse.justPressed() == true && FlxG.mouse.pressed() == true){
//							((genericFlxObject as CallbackSprite).rootObject as Village).showInfo();
//							((genericFlxObject as CallbackSprite).rootObject as Village).villageInfoDialogue.update();
//							trace("village click");
//						}
					}
				}
				
			} else {
				if( genericFlxObject is CallbackSprite){
					if( (genericFlxObject as CallbackSprite).rootObject is Bot){
						((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.showHealth = true;
						((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.showHealthCounter = 0;
					} else if( (genericFlxObject as CallbackSprite).rootObject is BuildingGroup){
						((genericFlxObject as CallbackSprite).rootObject as BuildingGroup).healthComponent.showHealth = true;
						((genericFlxObject as CallbackSprite).rootObject as BuildingGroup).healthComponent.showHealthCounter = 0;
						((genericFlxObject as CallbackSprite).rootObject as BuildingGroup).levelComponent.showLevel = true;
						((genericFlxObject as CallbackSprite).rootObject as BuildingGroup).levelComponent.showLevelCounter = 0;
					} else if( (genericFlxObject as CallbackSprite).rootObject is Crystal){
						((genericFlxObject as CallbackSprite).rootObject as Crystal).healthComponent.showHealth = true;
						((genericFlxObject as CallbackSprite).rootObject as Crystal).healthComponent.showHealthCounter = 0;
					}
				} else {
					
				} 
			}
		}
		
		public var cameraMoveSpeed:Number = 10;	
		public var cameraMoveDistance:Number = 0;
		public function moveCamera(specificLocation:FlxPoint = null):void
		{
			if(specificLocation == null){
				
				
				if( FlxG.mouse.screenX > (FlxG.stage.stageWidth - gameInterface.minimap.width)  &&
					FlxG.mouse.screenY > gameInterface.minimap.y){
					return
				}				
				
				if( FlxG.keys.A || FlxG.keys.LEFT || FlxG.mouse.screenX < cameraMoveDistance){
					if(cameraObject.x > (BaseLevel.boundsMinX + FlxG.stage.stageWidth/2) ){
						cameraObject.x -= cameraMoveSpeed;
					}
				} else if( FlxG.keys.D || FlxG.keys.RIGHT || FlxG.mouse.screenX > (FlxG.stage.stageWidth - cameraMoveDistance) ){
					if(cameraObject.x < (BaseLevel.boundsMaxX - FlxG.stage.stageWidth/2) ){
						cameraObject.x += cameraMoveSpeed;
					}
				}
				
				if( FlxG.keys.W || FlxG.keys.UP || FlxG.mouse.screenY < cameraMoveDistance){
					if(cameraObject.y > (BaseLevel.boundsMinY + FlxG.stage.stageHeight/2) ){
						cameraObject.y -= cameraMoveSpeed;
					}
				} else if( FlxG.keys.S || FlxG.keys.DOWN || FlxG.mouse.screenY > (FlxG.stage.stageHeight - cameraMoveDistance)){
					if(cameraObject.y < (BaseLevel.boundsMaxY - FlxG.stage.stageHeight/2) ){
						cameraObject.y += cameraMoveSpeed;
					}
				}
			} else {
				cameraObject.x = specificLocation.x;
				cameraObject.y = specificLocation.y;
				
				if( cameraObject.y > (BaseLevel.boundsMaxY - FlxG.stage.stageHeight/2) ){
					cameraObject.y = (BaseLevel.boundsMaxY - FlxG.stage.stageHeight/2);
				} else if ( cameraObject.y < (BaseLevel.boundsMinY + FlxG.stage.stageHeight/2) ){
					cameraObject.y = (BaseLevel.boundsMinY + FlxG.stage.stageHeight/2);
				}
				if( cameraObject.x > (BaseLevel.boundsMaxX - FlxG.stage.stageWidth/2) ){
					cameraObject.x = (BaseLevel.boundsMaxX - FlxG.stage.stageWidth/2);
				} else if (cameraObject.x < (BaseLevel.boundsMinX + FlxG.stage.stageWidth/2) ){
					cameraObject.x = (BaseLevel.boundsMinX + FlxG.stage.stageWidth/2);
				}
			}
		}
		
		public function tileMapChanged():void
		{
			
		}

		public function get doChangeFrozenState():Boolean
		{
			return _doChangeFrozenState;
		}

		public function set doChangeFrozenState(value:Boolean):void
		{
			_doChangeFrozenState = value;
		}

		
		private function transitionIn():void
		{
			var whiteOut:Sprite = new Sprite();
			whiteOut.graphics.beginFill(0xf9f8ec,1);
			whiteOut.graphics.drawRect(0,0,FlxG.stage.stageWidth, FlxG.stage.stageHeight);
			addChild(whiteOut);
			
			var gameLogo:* = new Resources.UISapphireSkiesLogoLarge();
			gameLogo.x = Math.round(FlxG.stage.stageWidth/2 - gameLogo.width/2); 
			gameLogo.y = Math.round(FlxG.stage.stageHeight/2 - gameLogo.height/2);
			whiteOut.addChild(gameLogo);			
			
			var transitionIn:* = new Resources.UITransitionRight();
			transitionIn.x = FlxG.stage.stageWidth-15;
			var blur:BlurFilter =new BlurFilter(25,5,2);
			transitionIn.filters = [blur];
			addChild(transitionIn);
			//.75
			var myTween:GTween = new GTween(whiteOut, .5, {x:(whiteOut.x - FlxG.stage.stageWidth - transitionIn.width)}, {ease:Linear.easeNone});
			var myTween2:GTween = new GTween(transitionIn, .5, {x:(transitionIn.x - FlxG.stage.stageWidth - transitionIn.width)}, {ease:Linear.easeNone});
			//myTween.addEventListener("complete",animationFinished,false,0,true);
		}
		
		private var finishedCallback:Function;
		private function transitionOut(callbackMethod:Function):void
		{
			finishedCallback = callbackMethod;
			var whiteOut:Sprite = new Sprite();
			whiteOut.graphics.beginFill(0xf9f8ec,1);
			whiteOut.graphics.drawRect(0,0,stage.stageWidth+15, stage.stageHeight);
			addChild(whiteOut);
			
			var gameLogo:* = new Resources.UISapphireSkiesLogoLarge();
			gameLogo.x = Math.round(FlxG.stage.stageWidth/2 - gameLogo.width/2); 
			gameLogo.y = Math.round(FlxG.stage.stageHeight/2 - gameLogo.height/2);
			whiteOut.addChild(gameLogo);
			
			
			var transitionOut:* = new Resources.UITransitionLeft();
			transitionOut.x = stage.stageWidth;
			var blur:BlurFilter =new BlurFilter(25,5,2);
			transitionOut.filters = [blur];
			addChild(transitionOut);
			transitionOut.x = FlxG.stage.stageWidth;
			whiteOut.x = FlxG.stage.stageWidth + transitionOut.width-15;
			//.75
			var myTween:GTween = new GTween(whiteOut, .5, {x:(-15)}, {ease:Linear.easeNone});
			var myTween2:GTween = new GTween(transitionOut, .5, {x:(-transitionOut.width)}, {ease:Linear.easeNone});
			myTween.addEventListener("complete",animatedOut,false,0,true);
		}
		
		private function animatedOut(e:Event = null):void
		{
			finishedCallback();
		}				
		
	}

}