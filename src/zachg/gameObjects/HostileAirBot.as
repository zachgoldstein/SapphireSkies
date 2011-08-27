package zachg.gameObjects
{
	import com.BaseLevel;
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.vexhel.FlxPathfindingNode;
	
	import flash.display.Shape;
	import flash.geom.Point;
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
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
	import zachg.util.EffectController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;

	/**
	 * NOTE: Does not automatically create everything in the constructor, it waits
	 * and creates later because it could stick around in a queue for a while doing nothing.
	 *  
	 * @author zachgoldstein
	 * 
	 */	
	public class HostileAirBot extends Bot
	{
		
		public var target:FlxObject;
		public var visualObject:CallbackSprite;
		
		public var deathEmitter:FlxEmitter;
		public var smokeEmitter:FlxEmitter;
		//0 is white, 1 is grey, 3 is black
		public var currentSmokeDamageLevel:int = -1;
		
		public var level:Number = 0;
		
		public var pathObstructionBumpDelay:Number = 20;
		public var pathObstructionBumpCounter:Number = 0;
		
		public var lockedOnMoveTarget:Boolean = false;
		
		public var avoidBulletFrequency:Number = 3;
		public var lastBulletAvoidance:Number = 0;
		public var distanceMultiplier:Number = 10;
		
		public var aiItem:AiItem;

		private var _markerGroup:FlxGroup = new FlxGroup();
		public var currentPathList:Array = new Array();
		
		public function HostileAirBot(creationCallback:Function = null)
		{
			objectCreatedCallback = creationCallback;
			movementComponent = new MovementComponent(botCollision,this);
			movementComponent.isAir = true;
			movementComponent.isGround = false;
			gunComponent = new GunComponent(objectCreatedCallback,botBulletCollision,this);
			healthComponent = new HealthComponent();
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;
			movementComponent.PhysicalSprite.acceleration.y = 0;
			
			healthComponent.maxHealth = 300;
			healthComponent.currentHealth = 300;
			
			botName = "Hostile Air Bot";
			
			deathEmitter = new FlxEmitter();
			smokeEmitter = new FlxEmitter();
			smokeEmitter.delay = 5;
			smokeEmitter.gravity = 0;
			
		}
		
		override public function createBot(movementTarget:FlxPoint, Level:Number = 0, _aiItem:AiItem = null):void
		{
			aiItem = _aiItem;
			level = aiItem.objectLevel;
			//(FlxG.state as PlayState).effectDisplays.add(smokeEmitter);
			
			gunComponent.shotNoise = aiItem.shootNoise[aiItem.objectLevel];
			gunComponent.shotExplode =  aiItem.shotExplode[aiItem.objectLevel];

			
			//set properties specific to type (note that some are also set in Factory, but will be more general properties)
			
			if(movementTarget != null){
				movementComponent.moveLocationTarget = movementTarget;
				lockedOnMoveTarget = true;
			} 
			
			movementComponent.thrustForce = _aiItem.levelShipSpeed[_aiItem.objectLevel]; 
			gunComponent.shotDamage = Math.round(_aiItem.levelShipShotDamage[_aiItem.objectLevel]+Math.random()*_aiItem.levelShipShotDamage[_aiItem.objectLevel]/4);			
			gunComponent.shotDelay = _aiItem.levelShipShotDelay[_aiItem.objectLevel];
			
			healthComponent.maxHealth = _aiItem.levelShipHealth[_aiItem.objectLevel];
			healthComponent.currentHealth = _aiItem.levelShipHealth[_aiItem.objectLevel];
				
			movementComponent.PhysicalSprite.visible = false;
			
			visualObject = new CallbackSprite(x,y,null,null);
			visualObject.solid = false;

			visualObject.loadGraphic(	aiItem.levelShipGraphics[aiItem.objectLevel],
				aiItem.levelShipGraphicParameters[aiItem.objectLevel][0],
				aiItem.levelShipGraphicParameters[aiItem.objectLevel][1],
				aiItem.levelShipGraphicParameters[aiItem.objectLevel][2],
				aiItem.levelShipGraphicParameters[aiItem.objectLevel][3]-2);
			var frameArray:Array = new Array();
			for(var i:int = 0 ; i < aiItem.levelShipGraphicParameters[aiItem.objectLevel][4] ; i++ ){
				frameArray.push(i);
			}
			visualObject.addAnimation("moving",frameArray,15);
			visualObject.play("moving");
			gunComponent.PhysicalSprite.loadGraphic(aiItem.levelTurretGraphics[aiItem.objectLevel][0][0],
				aiItem.levelTurretGraphicParameters[aiItem.objectLevel][0][0],
				aiItem.levelTurretGraphicParameters[aiItem.objectLevel][0][1],
				aiItem.levelTurretGraphicParameters[aiItem.objectLevel][0][2],
				aiItem.levelTurretGraphicParameters[aiItem.objectLevel][0][3]);
			
			movementComponent.PhysicalSprite.createGraphic(visualObject.width,visualObject.height);
			movementComponent.hullSprite.createGraphic(visualObject.width,visualObject.height);
			movementComponent.hullSprite.visible = false;
			
			gunComponent.PhysicalSprite.offset = new FlxPoint(aiItem.levelTurretPositions[aiItem.objectLevel][0][0],
				aiItem.levelTurretPositions[aiItem.objectLevel][0][1]);
			gunComponent.PhysicalSprite.origin = new FlxPoint( gunComponent.PhysicalSprite.width/4,gunComponent.PhysicalSprite.height/2);
			//gunComponent.PhysicalSprite.visible = false;
			gunComponent.bulletClass = BulletGroup;
			gunComponent.isAiControlled = true;
			gunComponent.isEnemy = isEnemy;
			
			var currentProperty:String;
			for(var i:int = 0 ; i < (aiItem.levelShipWeaponParameters[aiItem.objectLevel] as Array).length ; i++){
				if( i%2==0){
					currentProperty = (aiItem.levelShipWeaponParameters[aiItem.objectLevel] as Array)[i];
				} else {
					gunComponent[currentProperty] = (aiItem.levelShipWeaponParameters[aiItem.objectLevel] as Array)[i];
				}
			}
			
			//temp
			//gunComponent.shotDamage = 1
			
			//set graphic stuff
			//movementComponent.PhysicalSprite.loadGraphic(Resources.ImgPlayer,true,true,60,40);
			// .loadGraphic(Resources.ImgPlayer,true,true,60,40);
			
			//assorted other stuff
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;	
			healthComponent.drawVisual();
			
			
			//add to group
			addComponent(movementComponent);
			add(movementComponent.hullSprite);
			add(healthComponent.graphicHolder);
			add(visualObject);
			addComponent(gunComponent);
			
			add(_markerGroup);

			update();
			//dirty hack to get healthbars to render at start
			healthComponent.currentHealth--;
			
		}
		
		public var balanceCounter:Number = 0;
		public var balanceSwith:Number = 10;
		
		public var smokeFrequency:Number = 10;
		public var smokeCounter:Number = 0;
		
		private var convertIslandCounter:Number = 0;
		private var totalToConvertIsland:Number = -1;
		
		override public function update():void
		{
			if(isFrozen == true){
				return
			}
			
			super.update();
			
			//TODO: this is very very intensive, rework how the components get updates so that they don't have to do it every frame.
			movementComponent.update();
			gunComponent.update();
			healthComponent.update();
			//detectBotsInRange();
			
			if( movementComponent.PhysicalSprite.y > (BaseLevel.boundsMaxY - movementComponent.PhysicalSprite.height) ){
				movementComponent.PhysicalSprite.y = (BaseLevel.boundsMaxY - movementComponent.PhysicalSprite.height);
			} else if ( movementComponent.PhysicalSprite.y < (BaseLevel.boundsMinY + movementComponent.PhysicalSprite.height) ){
				movementComponent.PhysicalSprite.y = (BaseLevel.boundsMinY + movementComponent.PhysicalSprite.height);
			}
			if( movementComponent.PhysicalSprite.x > (BaseLevel.boundsMaxX - movementComponent.PhysicalSprite.width) ){
				movementComponent.PhysicalSprite.x = (BaseLevel.boundsMaxX - movementComponent.PhysicalSprite.width);
			} else if (movementComponent.PhysicalSprite.x < (BaseLevel.boundsMinX + movementComponent.PhysicalSprite.width) ){
				movementComponent.PhysicalSprite.x = (BaseLevel.boundsMinX + movementComponent.PhysicalSprite.width);
			}
			
			visualObject.x = x;
			visualObject.y = y;
			gunComponent.PhysicalSprite.x = visualObject.x;
			gunComponent.PhysicalSprite.y = visualObject.y;			
			
			if(movementComponent.PhysicalSprite.velocity.x < 0){
				if(balanceCounter > -balanceSwith){
					balanceCounter--;
				}
			} else {
				if(balanceCounter < balanceSwith){
					balanceCounter++;
				}
			}
			
			if(level != aiItem.objectLevel){
				//level = aiItem.objectLevel
				//trace("fuck");
			}
			
			if( balanceCounter == balanceSwith-1 ){
				visualObject.facing = FlxSprite.RIGHT;
			} else if( balanceCounter == -(balanceSwith-1) ){
				visualObject.facing = FlxSprite.LEFT;
			}
			
			if(visualObject.facing == FlxSprite.LEFT){
				gunComponent.PhysicalSprite.offset = new FlxPoint( 
					-visualObject.width - aiItem.levelTurretPositions[aiItem.objectLevel][0][2] + 2,
					aiItem.levelTurretPositions[aiItem.objectLevel][0][3] + 3);
			} else {
				gunComponent.PhysicalSprite.offset = new FlxPoint(
					aiItem.levelTurretPositions[aiItem.objectLevel][0][0] + 2,
					aiItem.levelTurretPositions[aiItem.objectLevel][0][1] + 3);
			}
			
/*			if(totalToConvertIsland != -1){
				convertIslandCounter++;
				if(totalToConvertIsland < convertIslandCounter){
					convertIsland();
				}
				
			}
*/			
			figureOutTargets();
			
			smokeCounter++;
			if(smokeCounter%smokeFrequency == 0){
				createSmoke();
			}
			smokeEmitter.update();
			//smokeEmitter.emitParticle();
//			if( lastBulletAvoidance > avoidBulletFrequency){
//				avoidBullets();
//				lastBulletAvoidance = 0;
//			}
//			lastBulletAvoidance++
			
			
		}
		
		public function convertIsland():void
		{
			
		}
		
		public var goProtect:Boolean = false;
		public function figureOutTargets():void
		{			
			//Go after closest building, but if a bot or the player is closer, go after them.
			
			target = findClosestObject((FlxG.state as PlayState).buildings,true);
			gunComponent.targetObject = target;
			if(goProtect == false){
				movementComponent.moveObjectTarget = target;
				movementComponent.goDirectlyToTarget = false;
			}
			
			var botsInRange:Array = findObjectsInRange((FlxG.state as PlayState).bots,true);			
			if(botsInRange.length > 0){
				if(goProtect == false){
					movementComponent.moveObjectTarget = target;
				}
				gunComponent.targetObject = target;				
			}
			if(	isPlayerWithinRange() == true &&
				isEnemy == true &&
				isPathToTargetObstructed(new FlxPoint(
					(FlxG.state as PlayState).player.MainHullSprite.x,
					(FlxG.state as PlayState).player.MainHullSprite.y)
				) == false
			){
				movementComponent.moveObjectTarget = (FlxG.state as PlayState).player;
				gunComponent.targetObject = (FlxG.state as PlayState).player
			}
			
			//check if we're close to the locked target, and if we are, stop being locked into it
			if(lockedOnMoveTarget == true){
				var dx:Number = movementComponent.moveLocationTarget.x - (movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2);
				var dy:Number = movementComponent.moveLocationTarget.y - (movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2);
				var distance:Number = Math.sqrt(dx*dx+dy*dy);	
				if(distance < detectionRange){
					lockedOnMoveTarget = false;
				} else {
					movementComponent.moveObjectTarget = null;
				}
			}
			
			if(pathObstructionBumpDelay < pathObstructionBumpCounter){
				var locationToPathFindTo:FlxPoint
				if(lockedOnMoveTarget == true){
					locationToPathFindTo = movementComponent.moveLocationTarget;
				} else if(movementComponent.moveObjectTarget != null){
					locationToPathFindTo = new FlxPoint(movementComponent.moveObjectTarget.x,movementComponent.moveObjectTarget.y);						
				}
				
				if ( isPathToTargetObstructed(locationToPathFindTo) == true){
					
					var dx:Number = locationToPathFindTo.x - (movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2);
					var dy:Number = locationToPathFindTo.y - (movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2);
					var distance:Number = Math.sqrt(dx*dx+dy*dy);	
					
					var maxDistanceToPathfind:Number = 300;					
					var nodePointToCheck:Point;
					if(distance < maxDistanceToPathfind){
						//pathfind directly to the target
						nodePointToCheck = new Point(
							Math.round(locationToPathFindTo.x/(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount)),
							Math.round(locationToPathFindTo.y/(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount))  );						
					} else {
						//pathfind to some location along path to target, but closer to this bot

						var percentageToTarget:Number = maxDistanceToPathfind/distance;
						var newXDisplacement:Number = dx*percentageToTarget;
						var newYDisplacement:Number = dy*percentageToTarget; 
						
						locationToPathFindTo = new FlxPoint(
							newXDisplacement + (movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2),
							newYDisplacement + (movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2)  );
						nodePointToCheck = new Point(
							Math.round(locationToPathFindTo.x /(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount)),
							Math.round(locationToPathFindTo.y/(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount))  );						
					}

					var nodeToCheck:FlxPathfindingNode = (FlxG.state as PlayState).pathFinder.getNodeAt( nodePointToCheck.x, nodePointToCheck.y	);
					if(nodeToCheck != null){
						var path:Array = 
							(FlxG.state as PlayState).pathFinder.findPath(
								new Point(
									int(movementComponent.PhysicalSprite.x/(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount)),
									int(movementComponent.PhysicalSprite.y/(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount))),
								new Point(
									int(locationToPathFindTo.x/(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount)),
									int(locationToPathFindTo.y/(16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount)) ) 
							)
						pathFoundLocation(path);
					}

					pathObstructionBumpCounter = 0;
				} else {
					currentPathList = new Array();
				}
			}
			pathObstructionBumpCounter++;
			
			if(currentPathList.length > 0){
				movementComponent.moveObjectTarget = null;
				movementComponent.goDirectlyToTarget = true;
				var dx:Number = currentPathList[0].x - (movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2);
				var dy:Number = currentPathList[0].y - (movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2);
				var distanceToNextPathNode:Number = Math.sqrt(dx*dx+dy*dy);
				
				var dx:Number = currentPathList[currentPathList.length-1].x - (movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2);
				var dy:Number = currentPathList[currentPathList.length-1].y - (movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2);				
				var distanceToTarget:Number = Math.sqrt(dx*dx+dy*dy); 
				
				if(distanceToNextPathNode < 30){
					currentPathList.shift();
					if(currentPathList.length > 0){
						movementComponent.moveLocationTarget = new FlxPoint(currentPathList[0].x,currentPathList[0].y);
					} else {
						movementComponent.moveLocationTarget = null;
					}
				} else if(distanceToTarget > detectionRange){
					currentPathList = new Array();
					movementComponent.moveLocationTarget = null;
				} else {
					movementComponent.moveLocationTarget = new FlxPoint(currentPathList[0].x,currentPathList[0].y);
				}
			}
			
		}
		
		
		public var showPathfindingMarkers:Boolean = false
		public function pathFoundLocation(path:Array):void
		{
			FlxG.log("Path Length:"+path.length);
			_markerGroup.kill();
			currentPathList = new Array();
			
			for each (var p:Point in path) {
				var markerSize:Number = 16*(FlxG.state as PlayState).pathFinder.tileSimplificationAmount
				currentPathList.push(
					new Point(
						p.x * markerSize + markerSize/2,
						p.y * markerSize + markerSize/2) 
				);
				if(showPathfindingMarkers == true){
					var marker:FlxSprite = _markerGroup.getFirstAvail() as FlxSprite;
					if (marker == null) {
						marker = new FlxSprite();
						marker.createGraphic(
							markerSize/2 ,
							markerSize/2, 
							0xffff0000
						);
						marker.solid = false;
						_markerGroup.add(marker);	
					}
					marker.reset(
						p.x * markerSize + 4,
						p.y * markerSize + 4); //place the markers along the path
				}
			}			
			
			_markerGroup.visible = true;
			_markerGroup.dead = false;
			_markerGroup.exists = true;
			_markerGroup.solid = false;			
		}
		
		public function createSmoke():void
		{
			var smokeAlpha:Number = .75
			if( healthComponent.currentHealth/healthComponent.maxHealth > 0.75){
				if(currentSmokeDamageLevel != 0){
					currentSmokeDamageLevel = 0;
					if(aiItem.objectLevel == 0){
						smokeEmitter.createSprites(Resources.EffectWhiteSmallSmoke,12,1,true,0,smokeAlpha);
					} else {
						smokeEmitter.createSprites(Resources.EffectWhiteMediumSmoke,9,1,true,0,smokeAlpha);
					}
				}
			} else if( healthComponent.currentHealth/healthComponent.maxHealth > 0.35){
				if(currentSmokeDamageLevel != 1){
					currentSmokeDamageLevel = 1;
					if(aiItem.objectLevel == 0){
						smokeEmitter.createSprites(Resources.EffectGreySmallSmoke,12,1,true,0,smokeAlpha);
					} else {
						smokeEmitter.createSprites(Resources.EffectGreyMediumSmoke,9,1,true,0,smokeAlpha);
					}
				}
			} else if( healthComponent.currentHealth/healthComponent.maxHealth > 0){
				if(currentSmokeDamageLevel != 2){
					currentSmokeDamageLevel = 2;
					if(aiItem.objectLevel == 0){
						smokeEmitter.createSprites(Resources.EffectBlackSmallSmoke,12,1,true,0,smokeAlpha);
					} else {
						smokeEmitter.createSprites(Resources.EffectBlackMediumSmoke,9,1,true,0,smokeAlpha);
					}
				}
			}
			
			smokeEmitter.at(movementComponent.PhysicalSprite);
			if( visualObject.facing == FlxSprite.RIGHT){
				smokeEmitter.x += aiItem.smokeLocation[aiItem.objectLevel][0];
			} else {
				smokeEmitter.x -= aiItem.smokeLocation[aiItem.objectLevel][0];
			}
			smokeEmitter.y += aiItem.smokeLocation[aiItem.objectLevel][1];				
			
			smokeEmitter.setXSpeed(-distanceMultiplier,distanceMultiplier);
			smokeEmitter.setYSpeed(-distanceMultiplier,distanceMultiplier);
			smokeEmitter.setRotation(-720,-720);
			smokeEmitter.start(false,0.075,0);
			
		}
		
		override public function render():void
		{
			super.render();
			smokeEmitter.render();
			
			gunComponent.showLasers();
			
			showDebugVisual();			
		}
		
		public var showGunTargetting:Boolean = false;
		public var showMovementTargetting:Boolean = false;
		public function showDebugVisual():void
		{
			//DEBUG VISUAL INFO
			if (showGunTargetting == true){
				if(gunComponent.targetObject == null){
					return
				}
				
				var drawCanvas:Shape=new Shape();
				var screenStartLocation:FlxPoint = movementComponent.PhysicalSprite.getScreenXY();
				var screenEndLocation:FlxPoint;
				if(didCollide == true){
					relativePoint = new FlxPoint( collisionLocation.x - movementComponent.PhysicalSprite.x,collisionLocation.y - movementComponent.PhysicalSprite.y);
					screenEndLocation = new FlxPoint(screenStartLocation.x + relativePoint.x,screenStartLocation.y + relativePoint.y);
				} else{
					screenEndLocation = new FlxPoint(gunComponent.targetObject.getScreenXY().x,gunComponent.targetObject.getScreenXY().y);
				}
				drawCanvas.graphics.lineStyle(3,0xFF00FF);
				drawCanvas.graphics.moveTo(screenStartLocation.x+movementComponent.PhysicalSprite.width/2,screenStartLocation.y+movementComponent.PhysicalSprite.height/2);
				drawCanvas.graphics.lineTo(screenEndLocation.x,screenEndLocation.y);
				
				FlxG.buffer.draw(drawCanvas);		
			}
			if (showMovementTargetting == true){
				if(movementComponent.moveLocationTarget == null){
					return
				}
				
				var drawCanvas:Shape=new Shape();
				var screenStartLocation:FlxPoint = movementComponent.PhysicalSprite.getScreenXY();
				var screenEndLocation:FlxPoint;
				relativePoint = new FlxPoint( movementComponent.moveLocationTarget.x - movementComponent.PhysicalSprite.x,movementComponent.moveLocationTarget.y - movementComponent.PhysicalSprite.y);
				screenEndLocation = new FlxPoint(screenStartLocation.x + relativePoint.x,screenStartLocation.y + relativePoint.y);
				drawCanvas.graphics.lineStyle(3,0xFF00FF);
				drawCanvas.graphics.moveTo(screenStartLocation.x+movementComponent.PhysicalSprite.width/2,screenStartLocation.y+movementComponent.PhysicalSprite.height/2);
				drawCanvas.graphics.lineTo(screenEndLocation.x,screenEndLocation.y);
				
				FlxG.buffer.draw(drawCanvas);		
			}
			
		}
		
		
		public var didCollide:Boolean = false;
		public var collisionLocation:FlxPoint = new FlxPoint();
		public var relativePoint:FlxPoint = new FlxPoint();
		private function isPathToTargetObstructed(targetToTestObstruction:FlxPoint):Boolean
		{
			didCollide = false
			if(gunComponent.targetObject == null || targetToTestObstruction == null){
				return false
			}
			for ( var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.hitTilemaps.members.length ; i++ ){
				if ( ((FlxG.state as PlayState).currentLevel.hitTilemaps.members[i] as FlxTilemap).ray(
					movementComponent.PhysicalSprite.x,
					movementComponent.PhysicalSprite.y,
					targetToTestObstruction.x,
					targetToTestObstruction.y,
					collisionLocation) ==true
				){
					didCollide = true;
				} 
				relativePoint = new FlxPoint( collisionLocation.x - movementComponent.PhysicalSprite.x,collisionLocation.y - movementComponent.PhysicalSprite.y);
				if(didCollide == true){
					break
				}
			}
			
//			if(didCollide == true){
//				if( Math.abs(relativePoint.x) > Math.abs(relativePoint.y) ){
//					//Right or left is largest, Move up or down
//					if(relativePoint.y > 0){
//						movementComponent.PhysicalSprite.velocity.y += 1000;
//					} else {
//						movementComponent.PhysicalSprite.velocity.y -= 1000;
//					}
//				} else {
//					//up or down is largest, Move right or left
//					if(relativePoint.x > 0){
//						movementComponent.PhysicalSprite.velocity.x += 1000;
//					} else {
//						movementComponent.PhysicalSprite.velocity.x -= 1000;
//					}
//				}
//			}
			return didCollide
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
		
		public function detectBuildingsInRange():void
		{
			var buildingsInRange:Array = findObjectsInRange((FlxG.state as PlayState).buildings,true);
			if(buildingsInRange.length > 1){
				movementComponent.stopMoving();
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
								target = currentBotDistanceCheck;
							}
							shortestDistance = distance;
						}
					}
				}
			}
			return objectsInRange
		}

		private function findClosestObject(group:FlxGroup,setTarget:Boolean = false):GroupGameObject{
			var objectsInRange:Array = new Array();
			
			var distance:Number;
			var currentBotDistanceCheck:GroupGameObject;
			var shortestDistance:Number = 99999;
			var currentClosestObject:GroupGameObject;
			
			for ( var i:int = 0 ; i < group.members.length; i++){
				currentBotDistanceCheck = group.members[i];
				if(isEnemy != currentBotDistanceCheck.isEnemy && currentBotDistanceCheck.dead == false){
					distance = Math.sqrt( 	(currentBotDistanceCheck.x - x)*(currentBotDistanceCheck.x - x) +
						(currentBotDistanceCheck.y - y)*(currentBotDistanceCheck.y - y) );
					objectsInRange.push( currentBotDistanceCheck);
					if(shortestDistance > distance){
						if(setTarget == true){
							target = currentBotDistanceCheck;
						}
						shortestDistance = distance;
						currentClosestObject = currentBotDistanceCheck;
					}
				}
			}
			return currentClosestObject
		}
		
		
		private function isPlayerWithinRange():Boolean
		{
			var currentBotDistanceCheck:GroupGameObject = (FlxG.state as PlayState).player;
			var distance:Number = Math.sqrt( 	(currentBotDistanceCheck.x - x)*(currentBotDistanceCheck.x - x) +
				(currentBotDistanceCheck.y - y)*(currentBotDistanceCheck.y - y) );
			if(detectionRange > distance){
				return true
			} else {
				return false
			}
		}
		
		private function botInRange(bot1:CallbackSprite,bot2:CallbackSprite):void
		{
			if(	(bot1.uid == detectionArea.uid && bot2.uid == movementComponent.PhysicalSprite.uid) ||
				(bot2.uid == detectionArea.uid && bot1.uid == movementComponent.PhysicalSprite.uid) ){
			} else {
				
				
			}
		}
		
//		private function avoidBullets():void
//		{
//			
//			if(isEnemy == true){
//				findClosestObject( (FlxG.state as PlayState).e
//				var closestBulletDistance:Number
//				
//			}
//		}

		override public function botCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			
		}

		public function botBulletCollision(Contact:FlxObject, Velocity:Number=-1,collisionSide:String=null):void
		{
			
		}
		
		override public function botOverlapsBuilding(building:BuildingGroup):void
		{
			
		}
		
		override public function destroyObject():void
		{
			//EffectController.explodeAtPoint(movementComponent.PhysicalSprite);
			smokeEmitter.stop();
			if(aiItem.objectLevel == 2){
				var effectName:String = "EffectShipDeathLarge";
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(
						movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2,
						movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2),
					LevelData.effectData[effectName][2]
				);				
				EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageLarge", 9,25,1);
				SoundController.playSoundEffect("SfxLargeEnemyShipDied")
			} else if(aiItem.objectLevel == 1){
				var randomNumber:Number = (Math.round(Math.random())+1);
				var effectName:String = "EffectShipDeathMedium"+randomNumber
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(
						movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2,
						movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2),
					LevelData.effectData[effectName][2]
				);				
				EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageMedium", 12,20,1);
				SoundController.playSoundEffect("SfxMediumEnemyShipDied")
			} else if(aiItem.objectLevel == 0){
				var randomNumber:Number = (Math.round(Math.random()*2)+1);
				var effectName:String = "EffectShipDeathSmall"+randomNumber
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(
						movementComponent.PhysicalSprite.x + movementComponent.PhysicalSprite.width/2,
						movementComponent.PhysicalSprite.y + movementComponent.PhysicalSprite.height/2),
					LevelData.effectData[effectName][2]
				);				
				EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageSmall", 9,15,1);
				SoundController.playSoundEffect("SfxSmallEnemyShipDied")
			}
			
			super.destroyObject();
		}
		
	}
}