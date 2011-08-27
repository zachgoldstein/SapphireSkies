package zachg.components
{
	import com.PlayState;
	import com.Resources;
	
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	import zachg.GroupGameObject;
	import zachg.components.maps.Mapping;
	import zachg.gameObjects.Bomb;
	import zachg.gameObjects.Bot;
	import zachg.gameObjects.BulletGroup;
	import zachg.gameObjects.CallbackSprite;
	import zachg.gameObjects.HostileAirBot;
	import zachg.gameObjects.MiningBot;
	import zachg.gameObjects.PlayerGroup;
	import zachg.gameObjects.Rocket;
	import zachg.util.EffectController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;

	public class GunComponent extends GameComponent
	{
		
		private var objectCreatedCallback:Function;
		private var bulletCollisionCallback:Function;
		
		public var gunRotateSpeedMultiplier:Number = 15;
		public var bulletClass:Class;
		public var secondaryBulletClass:Class;
		
		public var isMiningEnabled:Boolean = true;
		public var mineDelay:int = 50;
		public var mineCounter:int = 0;
		public var miningLifespan:int = 150;
		public var mineDistance:int = 1;
		
		public var miningImage:String = "MiscMiningBot";
		
		public var shotDelay:int = 15;
		public var lastShotCounter:int = 0;
		public var secondaryShotDelay:int = 50;
		public var lastSecondaryShotCounter:int = 0;
		public var ramDelay:int = 15
		public var ramCounter:int = 15
		
		public var secondaryShotMass:Number = 5;
		public var shotMass:Number = 10;	
			
		public var shotVelocity:Number = 250;
		public var shotDamage:Number = 5;
		public var secondaryShotDamage:Number = 5;
		public var shotRange:Number = 350;
		
		public var canRam:Boolean = false;
		
		//LAZOR props
		public var isLaserMode:Boolean = false;
		public var laserAppearTime:Number = 10;
		public var laserAppearTimeCounter:Number = 11;
		public var laserThickness:Number = 2;
		public var laserCurrentColor:uint = 0;	
		public var laserWarmupColor:uint = 0xFFFFFF;	
		public var laserShootColor:uint = 0xFF0000;	
		public var laserCollisionObject:FlxSprite = new FlxSprite();
		public var laserAccuracy:Number = 20;
		public var warmUpTimerDelay:Number = 5;
		public var warmUpTimerDelayCounter:Number = 0;
		
		//normal gun properties
		public var isSingleShotMode:Boolean = true;
		
		//mutliple bullet shot modes 
		public var isFanShot:Boolean = false;
		public var fanAngleRange:Number = 15;
		public var numFanBullets:Number = 3;
		public var isParallelShot:Boolean = false;
		public var parallelBulletSpacing:Number = 10;
		public var numParallelBullets:Number = 3;
		
		//shotgun mode properties
		public var isShotGunMode:Boolean = false;
		public var numShotgunBullets:int = 5;
		public var shotgunAccuracy:int = 100; //Lower is better
		
		public var isHoming:Boolean = false;
		
		public var secondaryBulletObject:FlxObject;
		
		public var gunJamProbabililty:Number = 0;
		
		public var shootInAllDirections:Boolean = true;
		public var isAiControlled:Boolean = false;
		
		public var targetObject:FlxObject;
		
		public var isEnemy:Boolean = false;
		
		public var referenceVelocity:FlxPoint;
		
		public var shotNoise:String = "";
		public var shotExplode:String = "";
		
		public var secondaryShotNoise:String = "";
		public var secondaryShotExplodeNoise:String = "";
		//public var ramNoise:String = "";
		
		public var bulletImageClass:String;
		public var bulletImageParams:Array;		
		
		public var secondaryImage:String;
		public var secondaryImageParams:Array;
		
		public var bullets:Vector.<*> = new Vector.<*>();		
		
		public function GunComponent(creationCallback:Function,BulletCollisionCallback:Function=null,RootObject:FlxObject=null)
		{
			super();
			objectCreatedCallback = creationCallback;
			bulletCollisionCallback = BulletCollisionCallback;
			
			rootObject = RootObject;
			
			PhysicalSprite = new CallbackSprite(0,0,null,rootObject);
			PhysicalSprite.maxThrust = 120;
			PhysicalSprite.maxAngular = 1000;

			laserCollisionObject = new FlxSprite(0,0);
			laserCollisionObject.width = 10;
			laserCollisionObject.height = 10;
			objectCreatedCallback(laserCollisionObject,null,null,null);
		}
		
		override public function update():void
		{
			if( (rootObject as GroupGameObject).isFrozen == true){
				return
			}			
			
			//only on first update,
			//pre-generate bullets for efficiency
			if (bullets.length == 0){
				for (var i:int = 0 ; i < 5 ; i++){
					var bullet:* = new bulletClass(bulletCollisionCallback);
					bullet.dead = true;
					bullet.active = false;
					bullets.push(bullet);
				}
			}
			
			if(rootObject is PlayerGroup){
				
				if( (FlxG.keys.justPressed("Q") || FlxG.keys.justPressed("SPACE")) && mineCounter > mineDelay){
					fireMiningBot()
					mineCounter = 0;
				}
				mineCounter++;
			}
			
			if(isAiControlled == true){
				aimGunAtTarget();
				if(isTargetWithinRange() == true){
					shoot();
				}
			} else {
				aimGunAtMouse();
			}
			
			if(canRam == true && ramCounter > ramDelay){
				var ramObject:CallbackSprite;
				if(rootObject is PlayerGroup){
					ramObject = ((rootObject as PlayerGroup).MainHullSprite as CallbackSprite);
				} else if(rootObject is HostileAirBot){
					ramObject = (rootObject as HostileAirBot).movementComponent.PhysicalSprite;
				}				
				FlxU.overlap( 
					ramObject,
					(FlxG.state as PlayState).enemyGroup,ramDamage
				);	
			}
			
			lastSecondaryShotCounter++;
			lastShotCounter++;
			
			ramCounter++;
		}
		
		public var friction:Number = 0.95;
		public var avoiding:Boolean = false;
		private var targetAngle:Number;				
		public function aimGunAtTarget():void
		{
			if(targetObject != null){
				if(shootInAllDirections == true){
					var dx:Number = (targetObject.x + targetObject.width/2) - (PhysicalSprite.x - PhysicalSprite.offset.x + PhysicalSprite.width/2);
					var dy:Number = (targetObject.y + targetObject.height/2)  - (PhysicalSprite.y- PhysicalSprite.offset.y + PhysicalSprite.height/2);
					targetAngle = (Math.atan2(dy, dx) * 57.295) - PhysicalSprite.angle;
					var delta:Number = PhysicalSprite.maxAngular * FlxG.elapsed;
					if (avoiding) targetAngle += 180;
					if (targetAngle < -180) targetAngle += 360; // shortest route
					if (targetAngle > 180) targetAngle -= 360;
					if (targetAngle > delta) targetAngle = delta; // cap turn speed
					else if (targetAngle < -delta) targetAngle = -delta;
					PhysicalSprite.angularVelocity = targetAngle*gunRotateSpeedMultiplier;
				}				
			}
		}
		
		public function aimGunAtMouse():void
		{
			if(shootInAllDirections == true){
				var dx:Number = FlxG.mouse.x - (PhysicalSprite.x - PhysicalSprite.offset.x + PhysicalSprite.width/2);
				var dy:Number = FlxG.mouse.y - (PhysicalSprite.y - PhysicalSprite.offset.y + PhysicalSprite.height/2);
				targetAngle = (Math.atan2(dy, dx) * 57.295) - PhysicalSprite.angle;
				var delta:Number = PhysicalSprite.maxAngular * FlxG.elapsed;
				if (avoiding) targetAngle += 180;
				if (targetAngle < -180) targetAngle += 360; // shortest route
				if (targetAngle > 180) targetAngle -= 360;
				if (targetAngle > delta) targetAngle = delta; // cap turn speed
				else if (targetAngle < -delta) targetAngle = -delta;
				PhysicalSprite.angularVelocity = targetAngle*gunRotateSpeedMultiplier;
			}
			
			//			var cosa:Number = Math.cos(angleRad);
			//			var sina:Number = Math.sin(angleRad);
			//			velocity.x += (cosa * thrust) * _elap;
			//			velocity.y += (sina * thrust) * _elap;
			//			if (velocity.x > maxThrust) velocity.x = maxThrust; // cap
			//			else if (velocity.x < -maxThrust) velocity.x = -maxThrust;
			//			if (velocity.y > maxThrust) velocity.y = maxThrust;
			//			else if (velocity.y < -maxThrust) velocity.y = -maxThrust;
			//			velocity.x *= friction;
			//			velocity.y *= friction;
		}
		
		public function fireMiningBot():void
		{
			SoundController.playSoundEffect("SfxMineBotLaunch");
			
			var miningBot:MiningBot = new MiningBot()
			miningBot.miningBotImageClass = Resources[miningImage]
			miningBot.createBot(null,(rootObject as PlayerGroup).equipSize);
			
			miningBot.isEnemy = isEnemy;
			miningBot.botLifeSpan = miningLifespan;
			miningBot.mineDistance = mineDistance;
			miningBot.healthComponent.currentHealth = (rootObject as PlayerGroup).healthComponent.maxHealth/4; 
			miningBot.healthComponent.maxHealth = (rootObject as PlayerGroup).healthComponent.maxHealth/4;
			miningBot.miningComponent.cargoSizeLimit = Math.ceil( (rootObject as PlayerGroup).cargoSizeLimit/4);
			
			miningBot.movementComponent.PhysicalSprite.x = PhysicalSprite.x;
			miningBot.movementComponent.PhysicalSprite.y = PhysicalSprite.y;
			miningBot.movementComponent.PhysicalSprite.velocity.x += (rootObject as PlayerGroup).MainHullSprite.velocity.x;
			miningBot.movementComponent.PhysicalSprite.velocity.y += (rootObject as PlayerGroup).MainHullSprite.velocity.y;
			
			miningBot.dead = false;
			miningBot.active = true;
			miningBot.exists = true;
			
			miningBot.x = PhysicalSprite.x - PhysicalSprite.offset.x;
			miningBot.y = PhysicalSprite.y - PhysicalSprite.offset.y;
			
			objectCreatedCallback(miningBot,null,null,null);
		}
		
		public function shoot(doShootSecondary:Boolean = false):Boolean
		{
			if(doShootSecondary == false){
				if(shotDelay < lastShotCounter && bulletClass != null){
					if(doesGunJam() == false){
						if(isLaserMode == true){
							shootLaser()
						} else {
							createBullets();
						}
						if(	PhysicalSprite.onScreen() == true){
							SoundController.playSoundEffect(shotNoise);
						}
						return true
					} else {
						EffectController.displayMessageAtPoint(PhysicalSprite.x, PhysicalSprite.y,"Gun Jammed");
						lastShotCounter = 0;
						return false
					}
				}
				return false
			} else {
				if(lastSecondaryShotCounter > secondaryShotDelay){
					shootSecondary();
					return true;
				} else {
					return false;
				}
			}
		}
		
		private function shootSecondary():void
		{
			if( (secondaryBulletObject == null || (secondaryBulletObject.active == false || secondaryBulletObject.dead == true) ) &&
				secondaryBulletClass != null ){

				secondaryBulletObject = new secondaryBulletClass();
				
				if(secondaryBulletObject is Bot){
					(secondaryBulletObject as Bot).createBot(null);
					(secondaryBulletObject as Bot).isEnemy = isEnemy;

					(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.x = PhysicalSprite.x;
					(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.y = PhysicalSprite.y;
					(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.velocity.x += referenceVelocity.x;
					(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.velocity.y += referenceVelocity.y;
					 
					if(secondaryBulletObject is MiningBot){
						trace("shouldn't set secondary as mining bots");
						
/*						if( Math.abs( (secondaryBulletObject as Bot).movementComponent.PhysicalSprite.velocity.x) >
							Math.abs( (secondaryBulletObject as Bot).movementComponent.PhysicalSprite.velocity.y)
							) {
							if( (secondaryBulletObject as Bot).movementComponent.PhysicalSprite.velocity.x > 0){
								(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.angle = 90;
								(secondaryBulletObject as Bot).movementComponent.hullSprite.angle = 90;
							} else {
								(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.angle = -90;
								(secondaryBulletObject as Bot).movementComponent.hullSprite.angle = -90;
							}
						} else {
							if( (secondaryBulletObject as Bot).movementComponent.PhysicalSprite.velocity.y > 0){
								(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.angle = 180;
								(secondaryBulletObject as Bot).movementComponent.hullSprite.angle = 180;
							} else {
								(secondaryBulletObject as Bot).movementComponent.PhysicalSprite.angle = 0;
								(secondaryBulletObject as Bot).movementComponent.hullSprite.angle = 0;
							}
						}*/
					}
				} else if(secondaryBulletObject is Bomb){
					SoundController.playSoundEffect(secondaryShotNoise);
					if(secondaryImage != null && secondaryImageParams != null){
						(secondaryBulletObject as BulletGroup).bulletImageClass = Resources[secondaryImage];
						(secondaryBulletObject as BulletGroup).bulletImageParams = secondaryImageParams;
					}
					(secondaryBulletObject as Bomb).explodeNoise = secondaryShotExplodeNoise;
					(secondaryBulletObject as Bomb).movementComponent.PhysicalSprite.velocity.x += (rootObject as PlayerGroup).MainHullSprite.velocity.x;
					(secondaryBulletObject as Bomb).movementComponent.PhysicalSprite.velocity.y += (rootObject as PlayerGroup).MainHullSprite.velocity.y;
					if(secondaryImage != null && secondaryImageParams != null){
						(secondaryBulletObject as Bomb).movementComponent.PhysicalSprite.loadGraphic(
							Resources[secondaryImage],
							secondaryImageParams[0],
							secondaryImageParams[1],
							secondaryImageParams[2],
							secondaryImageParams[3]
						);
					} else {
						(secondaryBulletObject as Bomb).movementComponent.PhysicalSprite.loadGraphic(Resources.MiscBomb,false,false,14,7);
					}				
					
					
				} else if(secondaryBulletObject is BulletGroup){
					(secondaryBulletObject as BulletGroup).bulletDamage = secondaryShotDamage;
					//(secondaryBulletObject as BulletGroup).bullet.loadGraphic(Resources.MiscBullet,false,false,4,4);
				}
				secondaryBulletObject.dead = false;
				secondaryBulletObject.active = true;
				secondaryBulletObject.exists = true;
				
				secondaryBulletObject.x = PhysicalSprite.x - PhysicalSprite.offset.x;
				secondaryBulletObject.y = PhysicalSprite.y - PhysicalSprite.offset.y;

				objectCreatedCallback(secondaryBulletObject,null,null,null);
				
				lastSecondaryShotCounter = 0;
			}
		}
		 
		public var laserLocation:FlxPoint = new FlxPoint();
		public var collisionLocation:FlxPoint = new FlxPoint();
		public var relativePoint:FlxPoint = new FlxPoint();	
		public var targetPosition:FlxPoint;
		private function shootLaser(warmUp:Boolean = true):void
		{
			if(warmUp == true){
				var didCollide:Boolean = false;
				targetPosition = new FlxPoint();
				if(rootObject is PlayerGroup){
					targetPosition = new FlxPoint(FlxG.mouse.x,FlxG.mouse.y);
				} else if(rootObject is HostileAirBot){
					targetPosition = new FlxPoint(
						targetObject.x + Math.random()*laserAccuracy,
						targetObject.y + Math.random()*laserAccuracy);
				}
				laserCollisionObject.x = targetPosition.x - laserCollisionObject.width/2;
				laserCollisionObject.y = targetPosition.y - laserCollisionObject.height/2;				
				laserLocation = new FlxPoint(laserCollisionObject.x + laserCollisionObject.width/2,laserCollisionObject.y+laserCollisionObject.height/2);
				
				warmUpTimerDelayCounter = 0;
				laserCurrentColor = laserWarmupColor; 
				laserAppearTimeCounter = 0;
				lastShotCounter = 0;
				
			} else {
				laserCurrentColor = laserShootColor;
				
				for ( var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.hitTilemaps.members.length ; i++ ){
					if ( ((FlxG.state as PlayState).currentLevel.hitTilemaps.members[i] as FlxTilemap).ray(
						PhysicalSprite.x,
						PhysicalSprite.y,
						targetPosition.x,
						targetPosition.y,
						laserLocation) ==true
					){
						didCollide = true;
						//laserAppearTimeCounter = 0;
					} 
				}			
				if(didCollide == false){
					//laserAppearTimeCounter = 0;
					
					//is there an enemy here?
					if(rootObject is PlayerGroup){
						//laserLocation = new FlxPoint(FlxG.mouse.x,FlxG.mouse.y);
						FlxU.overlap( 
							(FlxG.state as PlayState).mouseCollisionCheckObject,
							(FlxG.state as PlayState).enemyGroup,laserDamageTarget);
					} else{
						//laserLocation = new FlxPoint(laserCollisionObject.x + laserCollisionObject.width/2,laserCollisionObject.y+laserCollisionObject.height/2);
						if(isEnemy == true){
							FlxU.overlap( 
								laserCollisionObject,
								(FlxG.state as PlayState).friendlyGroup,laserDamageTarget);
							FlxU.overlap( 
								laserCollisionObject,
								(FlxG.state as PlayState).friendlyBuildings,laserDamageTarget);
							FlxU.overlap( 
								laserCollisionObject,
								(FlxG.state as PlayState).player.MainHullSprite,laserDamageTarget);
						} else {
							FlxU.overlap( 
								laserCollisionObject,
								(FlxG.state as PlayState).enemyBots,laserDamageTarget);
							FlxU.overlap( 
								laserCollisionObject,
								(FlxG.state as PlayState).enemyBuildings,laserDamageTarget);						
						}
					}
				}
			}
		}
		
		public function laserDamageTarget(mouseTestSprite:FlxObject,genericFlxObject:FlxObject):void
		{
			((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.currentHealth -= shotDamage;
			((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.update();
			
			var doRail:Boolean = false;
			var doLAZOR:Boolean = false;
			if(rootObject is PlayerGroup){
				if( (rootObject as PlayerGroup).equipSize == 0){
					doRail = true;
				} else {
					doLAZOR = true;
				}
			} else if(rootObject is HostileAirBot){
				if( (rootObject as HostileAirBot).aiItem.objectLevel == 0){
					doRail = true;
				} else {
					doLAZOR = true;
				}				
			}
			var effectName:String;
			if(doLAZOR == true){
				effectName = "EffectLaserHit"
			} else {
				effectName = "EffectRailHit"
			}
			EffectController.showEffectAnimation(
				effectName,
				LevelData.effectData[effectName][0],
				LevelData.effectData[effectName][1],
				new Point(
					laserLocation.x,
					laserLocation.y),
				LevelData.effectData[effectName][2]
			);
			
			EffectController.displayMessageAtPoint(genericFlxObject.x,genericFlxObject.y, shotDamage +"pts");
			bulletCollisionCallback(genericFlxObject);
		}
		
		public function showLasers():void
		{
			if (laserAppearTimeCounter < laserAppearTime){
				
				var drawCanvas:Shape=new Shape();
				var alphaToSet:Number = (laserAppearTime - laserAppearTimeCounter)/laserAppearTime;
				if(alphaToSet < 0) { alphaToSet = 0 };
				drawCanvas.alpha = alphaToSet;
				
				var glowFiler:GlowFilter = new GlowFilter(laserCurrentColor,1,laserThickness*3,laserThickness*3,laserThickness*2,3);
				drawCanvas.filters = [glowFiler];
				
				var screenStartLocation:FlxPoint = PhysicalSprite.getScreenXY();
				var screenEndLocation:FlxPoint;
				relativePoint = new FlxPoint( 
					laserLocation.x - PhysicalSprite.x + PhysicalSprite.offset.x,
					laserLocation.y - PhysicalSprite.y + PhysicalSprite.offset.y);
				screenEndLocation = new FlxPoint(screenStartLocation.x + relativePoint.x,screenStartLocation.y + relativePoint.y);
				drawCanvas.graphics.lineStyle(laserThickness,laserCurrentColor);
				drawCanvas.graphics.moveTo(screenStartLocation.x+PhysicalSprite.width/2,screenStartLocation.y+PhysicalSprite.height/2);
				drawCanvas.graphics.lineTo(screenEndLocation.x,screenEndLocation.y);
				
				if (warmUpTimerDelayCounter > warmUpTimerDelay){
					
					shootLaser(false);
					warmUpTimerDelayCounter = 0
				} else {
					drawCanvas.graphics.drawCircle(screenEndLocation.x,screenEndLocation.y,laserThickness+1);
				}
				warmUpTimerDelayCounter++;
				
				
				FlxG.buffer.draw(drawCanvas);
				laserAppearTimeCounter++;
			}			
			
		}		
		
		public function ramDamage(mouseTestSprite:FlxObject,genericFlxObject:FlxObject):void
		{
			SoundController.playSoundEffect(secondaryShotNoise);
			var velocityMultiplier:Number = 0;
			var velocityObject:CallbackSprite;
			if(rootObject is PlayerGroup){
				velocityObject = ((rootObject as PlayerGroup).MainHullSprite as CallbackSprite);
				velocityMultiplier =  Math.sqrt( velocityObject.velocity.x*velocityObject.velocity.x
					+ velocityObject.velocity.y*velocityObject.velocity.y ) / 
					Math.sqrt( velocityObject.maxVelocity.x*velocityObject.maxVelocity.x
					+ velocityObject.maxVelocity.y*velocityObject.maxVelocity.y );
			} else if(rootObject is HostileAirBot){
				velocityObject = (rootObject as HostileAirBot).movementComponent.PhysicalSprite;
				velocityMultiplier =  Math.sqrt( velocityObject.velocity.x*velocityObject.velocity.x
					+ velocityObject.velocity.y*velocityObject.velocity.y ) / 
					Math.sqrt( velocityObject.maxVelocity.x*velocityObject.maxVelocity.x
						+ velocityObject.maxVelocity.y*velocityObject.maxVelocity.y );
			}
			((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.currentHealth -= (secondaryShotDamage/2)*velocityMultiplier;
			((genericFlxObject as CallbackSprite).rootObject as GroupGameObject).healthComponent.update();
			
			EffectController.displayMessageAtPoint(genericFlxObject.x,genericFlxObject.y, Math.round((secondaryShotDamage/2)*velocityMultiplier) +"pts");
			bulletCollisionCallback(genericFlxObject,-1,null,true);	
			ramCounter = 0;
		}
		
		private function createBullets():void
		{
			var numBullets:Number = 0;
			if(isShotGunMode == true){
				numBullets = numShotgunBullets;
			} else if ( isFanShot == true){
				numBullets = numFanBullets;
			} else if ( isParallelShot == true){
				numBullets = numParallelBullets;
			} else if ( isSingleShotMode == true){
				numBullets = 1;
			}
			
			var cosa:Number;
			var sina:Number;
			
			for (var i:int = 0 ; i < numBullets ; i++){ 

				var bulletGroup:* = null;
				for(var j:int = 0 ; j < bullets.length ; j++){
					if(bullets[j].active == false){
						bulletGroup = bullets[j];
					}
				}
				if(bulletGroup == null){
					for (var l:int = 0 ; l < 10 ; l++){
						var bullet:* = new bulletClass(bulletCollisionCallback);
						bullet.dead = true;
						bullet.active = false;
						bullets.push(bullet);
					}
					bulletGroup = bullets[bullets.length-1];
				}
				
				bulletGroup.dead = false;
				bulletGroup.active = true;
				bulletGroup.exists = true;
				
				var bulletObject:FlxObject;
				if(bulletGroup.bullet != null){
					bulletObject = bulletGroup.bullet;
				} else if(bulletGroup.movementComponent != null){
					bulletObject = bulletGroup.movementComponent.PhysicalSprite;
				}
				
				bulletObject.velocity.x = 0;
				bulletObject.velocity.y = 0;
				bulletGroup.velocity.x = 0;
				bulletGroup.velocity.y = 0;
				
				bulletObject.x = PhysicalSprite.x - PhysicalSprite.offset.x;
				bulletObject.y = PhysicalSprite.y - PhysicalSprite.offset.y;
				bulletGroup.isEnemy = isEnemy;
				bulletGroup.bulletDamage = shotDamage;
				bulletGroup.bulletMass = shotMass;
				
				if(shootInAllDirections == true){
					cosa = Math.cos((Math.PI/180)*PhysicalSprite.angle);
					sina = Math.sin((Math.PI/180)*PhysicalSprite.angle);						

					bulletObject.x += PhysicalSprite.width * cosa;
					bulletObject.y += PhysicalSprite.height*2 * sina;
					if(isShotGunMode == true){
						cosa = Math.cos((Math.PI/180)*PhysicalSprite.angle);
						sina = Math.sin((Math.PI/180)*PhysicalSprite.angle);						
						bulletObject.velocity.x = (cosa * shotVelocity) + (Math.random()-0.5)*shotgunAccuracy;
						bulletObject.velocity.y = (sina * shotVelocity) + (Math.random()-0.5)*shotgunAccuracy;
					} else if ( isFanShot == true){
						var fanAngle:Number = (-fanAngleRange + (((fanAngleRange*2)/numFanBullets)*i) + PhysicalSprite.angle);
						cosa = Math.cos((Math.PI/180)* fanAngle);
						sina = Math.sin((Math.PI/180)* fanAngle);
						bulletObject.velocity.x = Math.round((cosa * shotVelocity));
						bulletObject.velocity.y = Math.round((sina * shotVelocity));						
						trace("fanAngle:"+fanAngle+" PhysicalSprite.angle:"+PhysicalSprite.angle+" cosa,sina ("+cosa+","+sina+"), shotvelocity:("+bulletObject.velocity.x+","+bulletObject.velocity.y+")");
					} else if ( isParallelShot == true){
						cosa = Math.cos((Math.PI/180)*PhysicalSprite.angle);
						sina = Math.sin((Math.PI/180)*PhysicalSprite.angle);
						bulletObject.velocity.x = (cosa * shotVelocity);
						bulletObject.velocity.y = (sina * shotVelocity);
						cosa = Math.cos((Math.PI/180)*(PhysicalSprite.angle+90));
						sina = Math.sin((Math.PI/180)*(PhysicalSprite.angle+90));
						bulletObject.x += ( -((parallelBulletSpacing * numBullets)/2) + (parallelBulletSpacing * i) ) * cosa;
						bulletObject.y += ( -((parallelBulletSpacing * numBullets)/2) + (parallelBulletSpacing * i) ) * sina;						
					} else if ( isSingleShotMode == true){
						cosa = Math.cos((Math.PI/180)*PhysicalSprite.angle);
						sina = Math.sin((Math.PI/180)*PhysicalSprite.angle);						
						bulletObject.velocity.x = (cosa * shotVelocity);
						bulletObject.velocity.y = (sina * shotVelocity);						
					}
					
					
					if(referenceVelocity != null){
						//bulletObject.velocity.y += referenceVelocity.y;
						//bulletObject.velocity.x += referenceVelocity.x;				
					}
				} else {
					if(PhysicalSprite.facing == FlxSprite.LEFT){
						bulletObject.velocity.x = -shotVelocity;
						bulletObject.velocity.y = Math.random()*shotgunAccuracy
						bulletObject.x -= PhysicalSprite.width;					
					} else if(PhysicalSprite.facing == FlxSprite.RIGHT) {
						bulletObject.velocity.x = shotVelocity;
						bulletObject.velocity.y = Math.random()*shotgunAccuracy
						bulletObject.x += PhysicalSprite.width;
					}
				}
				
				if(rootObject is PlayerGroup){
					(bulletGroup as BulletGroup).bulletLevel = (rootObject as PlayerGroup).equipSize;
				} else {
					(bulletGroup as BulletGroup).bulletLevel = (rootObject as HostileAirBot).aiItem.objectLevel;
				}
					
				if( bulletGroup is Rocket){
					(bulletGroup as Rocket).isEnemy = isEnemy;
					(bulletGroup as Rocket).isHoming = isHoming; 
					(bulletGroup as Rocket).bulletDamage = shotDamage;
					(bulletGroup as Rocket).target = targetObject;
					(bulletGroup as Rocket).movementComponent.moveObjectTarget = targetObject; 
					(bulletGroup as Rocket).movementComponent.quickSetCorrectRotation();
					(bulletGroup as Rocket).explodeNoise = shotExplode;
					if(bulletImageClass != null){
						(bulletGroup as Rocket).movementComponent.PhysicalSprite.loadGraphic(
							Resources[bulletImageClass],
							bulletImageParams[0],
							bulletImageParams[1],
							bulletImageParams[2],
							bulletImageParams[3]
						);
					} else {
						(bulletGroup as Rocket).movementComponent.PhysicalSprite.loadGraphic(Resources.MiscRocket,false,false,4,4);
					}				
				} else {
					if(rootObject is PlayerGroup){
						if( (rootObject as PlayerGroup).equipSize == 0){
							(bulletGroup as BulletGroup).bullet.loadGraphic(Resources.MiscsmallPlayerBullet,false,false,4,4);
						} else {
							(bulletGroup as BulletGroup).bullet.loadGraphic(Resources.MiscmediumPlayerBullet,false,false,5,5);
						}
					} else if( (rootObject as HostileAirBot).isEnemy == true ) {
						if( (rootObject as HostileAirBot).aiItem.objectLevel == 0){
							(bulletGroup as BulletGroup).bullet.loadGraphic(Resources.MiscsmallEnemyBullet,false,false,4,4);
						} else {
							(bulletGroup as BulletGroup).bullet.loadGraphic(Resources.MiscmediumEnemyBullet,false,false,5,5);
						}
					} else {
						if( (rootObject as HostileAirBot).aiItem.objectLevel == 0){
							(bulletGroup as BulletGroup).bullet.loadGraphic(Resources.MiscsmallFriendlyBullet,false,false,4,4);
						} else {
							(bulletGroup as BulletGroup).bullet.loadGraphic(Resources.MiscmediumFriendlyBullet,false,false,5,5);
						}
					}
				}
				
				objectCreatedCallback(bulletGroup,null,null,null);
				
				lastShotCounter = 0;
			}			
		}
		
		private function doesGunJam():Boolean{
			var randomNumber:Number = Math.random();
			if(gunJamProbabililty > randomNumber){
				return true
			} else {
				return false
			}
		}
		
		private function isTargetWithinRange():Boolean
		{
			var currentBotDistanceCheck:FlxObject = targetObject;
			if(currentBotDistanceCheck == null) return false				
			var distance:Number = Math.sqrt( 	(currentBotDistanceCheck.x - rootObject.x)*(currentBotDistanceCheck.x - rootObject.x) +
				(currentBotDistanceCheck.y - rootObject.y)*(currentBotDistanceCheck.y - rootObject.y) );
			if(shotRange > distance){
				return true
			} else {
				return false
			}
		}
		
		public function loadPropertyMapping(mapping:Mapping):void
		{
			for (var key:* in mapping.properties)
			{
				trace(key + " = " + mapping.properties[key]);
				if( this.hasOwnProperty(key)){
					this[key] = mapping.properties[key];
				}
			}		
		}
				
	}
}