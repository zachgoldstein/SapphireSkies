package zachg.gameObjects
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
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
	import org.flixel.data.FlxMouse;
	
	import zachg.GroupGameObject;
	import zachg.Mineral;
	import zachg.MineralGenerator;
	import zachg.PlayerStats;
	import zachg.components.GameComponent;
	import zachg.components.GunComponent;
	import zachg.components.HealthComponent;
	import zachg.components.LevelInfoComponent;
	import zachg.components.MiningComponent;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.minerals.specialMinerals.SpecialMineral;
	import zachg.ui.gameComponents.MiningBar;
	import zachg.util.EffectController;
	import zachg.util.GameMessageController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;
	
	public class PlayerGroup extends GroupGameObject
	{
		
		public var MainHullSprite:FlxSprite;
		public var visualGroup:FlxSprite;
		public var gunComponent:GunComponent;
		
		public var levelComponent:LevelInfoComponent = new LevelInfoComponent();
		
		public var currentPlayerMinerals:Vector.<Mineral> = new Vector.<Mineral>();
		
		public var spriteGroup:FlxGroup;
		
		public var thrustForce:Point;
		
		private var flying:Boolean = true;
		private var thrustDelay:Number = 0;
		private var lastThrustCounter:int = 0;
		private var objectCreatedCallback:Function;
		
		public var thrustExperienceGain:Number = 1;
		public var shootExperienceGain:Number = 10;
		public var secondaryExperienceGain:Number = 10;
		
		public var cargoSizeLimit:Number = 25;
		public var cargoThrustAffect:Number = 250;
		
		public var thrustCost:Number = .2;
		public var shootCost:Number = 1;
		
		private var _passHealth:Number = 0;
		
		public var smokeEmitter:FlxEmitter;
		public var smokeFrequency:Number = 5;
		public var smokeCounter:Number = 0;		
		public var distanceMultiplier:Number = 20;
		
		public var offsetRight:FlxPoint = new FlxPoint();
		public var offsetLeft:FlxPoint = new FlxPoint();
		
		public var equipSize:int = 0;
		public var currentSmokeDamageLevel:int = -1;
		
		public function PlayerGroup(X:Number, Y:Number,
							   passedWidth:Number,passedHeight:Number,
							   scaleX:Number,scaleY:Number,
							   boundsX:Number, boundsY:Number,
							   boundsWidth:Number, boundsHeight:Number,
							   imageName:String, callback:Function
								):void 
		{
			super();
			isEnemy = false;
			objectCreatedCallback = callback;
			var currentGrowthItem:PlayerItem = (PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem);
			
			currentPlayerMinerals = new Vector.<Mineral>();
			
			visualGroup = new CallbackSprite(X,Y,collisionCallback,this);
			if(currentGrowthItem.shipGraphic == null){
				visualGroup.loadGraphic(Resources.ShipDefaultPlayer, true, true, 40, 30);				
			} else {
				visualGroup.loadGraphic( 
					Resources[currentGrowthItem.shipGraphic],
					currentGrowthItem.shipGraphicParameters[0],
					currentGrowthItem.shipGraphicParameters[1],
					currentGrowthItem.shipGraphicParameters[2],
					currentGrowthItem.shipGraphicParameters[3] 
				);
			}
			var frameArray:Array = new Array();
			if(currentGrowthItem.shipGraphicParameters[4] != null){
				for(var i:int = 0 ; i < currentGrowthItem.shipGraphicParameters[4] ; i++ ){
					frameArray.push(i);
				}
			} else {
				for(var i:int = 0 ; i < 4 ; i++ ){
					frameArray.push(i);
				}				
			}
			visualGroup.addAnimation("idle",frameArray, 15);
			visualGroup.play("idle");
			visualGroup.solid = false;
			
			//visualGroup.color = currentGrowthItem.shipColorTint;
			
			
			//setup the main hull sprite (it controls movement, collisions and health)
			MainHullSprite = new CallbackSprite(X,Y,collisionCallback,this);
			MainHullSprite.createGraphic(Math.round(visualGroup.width*(3/4)),Math.round(visualGroup.height*(3/4)));
			MainHullSprite.visible = false;
			
			thrustForce = new Point(1500,1500);
			if(flying == true){
				thrustDelay = 1;
			} else {
				thrustDelay = 100;
			}
			
			MainHullSprite.maxVelocity.x = 500;
			MainHullSprite.maxVelocity.y = 500;
			//Gravity
			MainHullSprite.acceleration.y = GlobalVariables.gravityAcceleration.y;			
			//Friction
			MainHullSprite.drag.x = 300;
			//bounding box tweaks
			
			//MainHullSprite.width = boundsWidth;
			//MainHullSprite.height = boundsHeight;
			
			//setup the gun
			gunComponent = new GunComponent(objectCreatedCallback,bulletCollided,this);
			gunComponent.shotDamage = 25;
			gunComponent.shotDelay = 5;
			gunComponent.shotgunAccuracy = 200;
			if(currentGrowthItem.turretGraphic == null){
				gunComponent.PhysicalSprite.loadGraphic(Resources.MiscMachineGun,false,false,32,13);				
			} else {
				gunComponent.PhysicalSprite.loadGraphic( 
					Resources[currentGrowthItem.turretGraphic],
					currentGrowthItem.turretGraphicParameters[0],
					currentGrowthItem.turretGraphicParameters[1],
					currentGrowthItem.turretGraphicParameters[2],
					currentGrowthItem.turretGraphicParameters[3] 
				);
				offsetRight = currentGrowthItem.turretOffsetRight;
				offsetLeft = currentGrowthItem.turretOffsetLeft;
				offsetRight.x += 2;
				offsetRight.y += 3;
				offsetLeft.x += 2;
				offsetLeft.y += 3;
			}
			
			gunComponent.PhysicalSprite.origin = new FlxPoint(
				Math.round(gunComponent.PhysicalSprite.width/5),
				Math.round(gunComponent.PhysicalSprite.height/2)
			);
			
			gunComponent.bulletClass = BulletGroup;
			gunComponent.isAiControlled = false;
			gunComponent.isEnemy = false;

			levelComponent = new LevelInfoComponent();
			levelComponent.experienceBar.width = MainHullSprite.width;
			levelComponent.currentExperience = 0;
			
			healthComponent = new HealthComponent();
			healthComponent.healthBar.width = MainHullSprite.width;
			
			healthComponent.maxHealth = 100;
			healthComponent.currentHealth = healthComponent.maxHealth;
			
			add(MainHullSprite);
			add(visualGroup);
			//add(levelComponent.graphicHolder);
			add(healthComponent.graphicHolder);
			addComponent(gunComponent);
			
			//load any player upgrades
			
			if( PlayerStats.currentPlayerDataVo.currentPlayerEquip != -1){
				if( (PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).isWeapon != false){
					loadPropertyMapping( (PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).playerMapping );
					gunComponent.loadPropertyMapping( (PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).weaponMapping );
				} 
			}
			
			//temp
			//gunComponent.isLaserMode = true;
			//gunComponent.canRam = true;
			//gunComponent.shotDamage = 100;
			
			smokeEmitter = new FlxEmitter();
			smokeEmitter.delay = 5;
			smokeEmitter.gravity = 0;
			smokeEmitter.setRotation(-720,-720);
			//smokeEmitter.createSprites(Resources.WhiteCircle,20,1,false,0,.25);
		}
		
		public override function update():void
		{
			if(isFrozen == true){
				return
			}
			
			playerInput();
			super.update();
			x = MainHullSprite.x;
			y = MainHullSprite.y;
			width = MainHullSprite.width;
			height = MainHullSprite.height;	
			visualGroup.x = MainHullSprite.x - MainHullSprite.width*(1/8);
			visualGroup.y = MainHullSprite.y - MainHullSprite.height*(1/8);
			
			gunComponent.PhysicalSprite.x = visualGroup.x;
			gunComponent.PhysicalSprite.y = visualGroup.y;
			if(visualGroup.facing == FlxSprite.RIGHT){
				gunComponent.PhysicalSprite.offset = offsetRight;
			} else {
				gunComponent.PhysicalSprite.offset = new FlxPoint( -visualGroup.width - offsetLeft.x,offsetLeft.y);
			}
			
			var percentCargoFilled:Number = currentPlayerMinerals.length/cargoSizeLimit;
			MainHullSprite.velocity.y += ( (thrustForce.x/6) *percentCargoFilled) * FlxG.elapsed;
			
			if(healthComponent.currentHealth < (healthComponent.maxHealth)){
				if(healthComponent.currentHealth < (healthComponent.maxHealth*.25) ){
					healthComponent.healthChange = healthComponent.maxHealth*0.0004;
				} else {
					healthComponent.healthChange = healthComponent.maxHealth*0.0002;					
				}
			} else {
				healthComponent.healthChange = 0;
			}
			if(healthComponent.currentHealth < 0){
				destroyObject();
			}
			
			// so health and level bars always show
			//healthComponent.showHealthCounter = 0;
//			levelComponent.showLevelCounter = 0;
			
			
			
//			levelComponent.x = MainHullSprite.x;
//			levelComponent.y = MainHullSprite.y - levelComponent.spriteCanvas.height;			
//			levelComponent.drawVisual();
//			levelComponent.update();
			
			healthComponent.x = MainHullSprite.x;
			healthComponent.y = MainHullSprite.y - healthComponent.spriteCanvas.height + 6;
			healthComponent.drawVisual();
			healthComponent.update();
			
			gunComponent.update();
			smokeCounter++;
			if(smokeCounter%smokeFrequency == 0){
				createSmoke();
			}
			smokeEmitter.update();
			
			//Test Raycast
		}

		public function createSmoke():void
		{
			var smokeAlpha:Number = .75
			if( healthComponent.currentHealth/healthComponent.maxHealth > 0.75){
				if(currentSmokeDamageLevel != 0){
					currentSmokeDamageLevel = 0;
					if(equipSize == 0){
						smokeEmitter.createSprites(Resources.EffectWhiteSmallSmoke,12,1,true,0,smokeAlpha);
					} else {
						smokeEmitter.createSprites(Resources.EffectWhiteMediumSmoke,9,1,true,0,smokeAlpha);
					}
				}
			} else if( healthComponent.currentHealth/healthComponent.maxHealth > 0.35){
				if(currentSmokeDamageLevel != 1){
					currentSmokeDamageLevel = 1;
					if(equipSize == 0){
						smokeEmitter.createSprites(Resources.EffectGreySmallSmoke,12,1,true,0,smokeAlpha);
					} else {
						smokeEmitter.createSprites(Resources.EffectGreyMediumSmoke,9,1,true,0,smokeAlpha);
					}
				}
			} else if( healthComponent.currentHealth/healthComponent.maxHealth > 0){
				if(currentSmokeDamageLevel != 2){
					currentSmokeDamageLevel = 2;
					if(equipSize == 0){
						smokeEmitter.createSprites(Resources.EffectBlackSmallSmoke,12,1,true,0,smokeAlpha);
					} else {
						smokeEmitter.createSprites(Resources.EffectBlackMediumSmoke,9,1,true,0,smokeAlpha);
					}
				}
			}
			
			smokeEmitter.at(MainHullSprite);
			smokeEmitter.setXSpeed(-distanceMultiplier,distanceMultiplier);
			smokeEmitter.setYSpeed(-distanceMultiplier,distanceMultiplier);
			smokeEmitter.setRotation(-720,-720);			
			smokeEmitter.start(false,.075,0);
		}
		
		public var showGunTargetting:Boolean = false;
		override public function render():void
		{
			super.render();
			smokeEmitter.render();

			gunComponent.showLasers();
			
			if(showGunTargetting == true){
				var drawCanvas:Shape=new Shape();
		
				var collisionLocation:FlxPoint = new FlxPoint();
				var didCollide:Boolean = false;
				for ( var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.hitTilemaps.members.length ; i++ ){
					if ( ((FlxG.state as PlayState).currentLevel.hitTilemaps.members[i] as FlxTilemap).ray(MainHullSprite.x,MainHullSprite.y,FlxG.mouse.x,FlxG.mouse.y,collisionLocation) ==true){
						didCollide = true;
						break
					} 
				}
				var screenStartLocation:FlxPoint = MainHullSprite.getScreenXY();
				var screenEndLocation:FlxPoint;
				if(didCollide == true){
					var relativePoint:FlxPoint = new FlxPoint( collisionLocation.x - MainHullSprite.x,collisionLocation.y - MainHullSprite.y);
					screenEndLocation = new FlxPoint(screenStartLocation.x + relativePoint.x,screenStartLocation.y + relativePoint.y);
				} else{
					screenEndLocation = new FlxPoint(FlxG.mouse.screenX,FlxG.mouse.screenY);
				}
				drawCanvas.graphics.lineStyle(3,0xFF00FF);
				drawCanvas.graphics.moveTo(screenStartLocation.x+MainHullSprite.width/2,screenStartLocation.y+MainHullSprite.height/2);
				drawCanvas.graphics.lineTo(screenEndLocation.x,screenEndLocation.y);
				
				FlxG.buffer.draw(drawCanvas);
			}
			
		}

		public function playerInput():void
		{
			if( (FlxG.state as PlayState).isFrozen == true){
				
			} else {
				
					
				if(flying == true){
					flyingInput();
				} else {
				
				}
				
				if(FlxG.mouse.pressed() == true){
					gunComponent.referenceVelocity = new FlxPoint(MainHullSprite.velocity.x,MainHullSprite.velocity.y);
					if ( gunComponent.shoot() == true){
						//levelComponent.currentExperience += shootExperienceGain;
						PlayerStats.currentLevelDataVo.cashBalance -= shootCost; 					
	
						if(gunComponent.isShotGunMode == true){
							PlayerStats.currentLevelDataVo.shotsFired += gunComponent.numShotgunBullets; 
						} else if(gunComponent.isFanShot == true){
							PlayerStats.currentLevelDataVo.shotsFired += gunComponent.numFanBullets;
						} else if(gunComponent.isParallelShot == true){
							PlayerStats.currentLevelDataVo.shotsFired += gunComponent.numParallelBullets;
						} else {							
							PlayerStats.currentLevelDataVo.shotsFired++;
						}
						//EffectController.displayMessageAtPoint(MainHullSprite.x,MainHullSprite.y,"Shot!");
					}
				}
				if(FlxG.keys.CONTROL || FlxG.keys.E){
					gunComponent.referenceVelocity = new FlxPoint(MainHullSprite.velocity.x,MainHullSprite.velocity.y);
					if ( gunComponent.shoot(true) == true && gunComponent.canRam == false){
						PlayerStats.currentLevelDataVo.cashBalance -= shootCost*2;
						//levelComponent.currentExperience += secondaryExperienceGain;
					}
				}
			}
			
			
		}
		
		public function flyingInput():void
		{
			if(lastThrustCounter > thrustDelay){
				if ( FlxG.keys.LEFT || FlxG.keys.A)
				{
					visualGroup.facing = FlxSprite.LEFT;
					gunComponent.PhysicalSprite.facing = FlxSprite.LEFT;
					MainHullSprite.velocity.x -= thrustForce.x * FlxG.elapsed;
					
					//levelComponent.currentExperience += thrustExperienceGain;
					PlayerStats.currentLevelDataVo.cashBalance -= thrustCost; 					
					PlayerStats.currentLevelDataVo.thrustSpent++;
				}
				else if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					visualGroup.facing = FlxSprite.RIGHT;
					gunComponent.PhysicalSprite.facing = FlxSprite.RIGHT;
					MainHullSprite.velocity.x += thrustForce.x * FlxG.elapsed;

					PlayerStats.currentLevelDataVo.cashBalance -= thrustCost; 					
					PlayerStats.currentLevelDataVo.thrustSpent++;
				}
				
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					MainHullSprite.velocity.y -= (thrustForce.y) * FlxG.elapsed;
					PlayerStats.currentLevelDataVo.cashBalance -= thrustCost; 					
					PlayerStats.currentLevelDataVo.thrustSpent++;
				} 
				else if(FlxG.keys.DOWN || FlxG.keys.S)
				{
					MainHullSprite.velocity.y += thrustForce.y * FlxG.elapsed;
					PlayerStats.currentLevelDataVo.cashBalance -= thrustCost; 					
					PlayerStats.currentLevelDataVo.thrustSpent++;
				}
				lastThrustCounter = 0;
			}
			lastThrustCounter++;
		}
		
		public function isMineralArrayDifferent(minerals:Vector.<Mineral>):Boolean{
			if(currentPlayerMinerals.length == 0 && minerals == null){
				return false
			} else if(minerals == null){
				return true
			}
			if(minerals.length != currentPlayerMinerals.length){
				return true
			}
			return false
		}
		
		public function getMinerals():Vector.<Mineral>
		{
			return currentPlayerMinerals;
		}
		
		public function collisionCallback(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			if( (Contact is CallbackSprite) ) {
				if ( (Contact as CallbackSprite).rootObject is BulletGroup){
					//TODO: turn on only for lasers or repeated damage
					//EffectController.showNoise(2);
					SoundController.playSoundEffect("SfxGetHit");
				}
			}	
		}
		
		public function bulletCollided(Contact:FlxObject = null, Velocity:Number = -1,collisionSide:String = null, isRam:Boolean = false):void
		{
			if( Contact is CallbackSprite) {
				
				if( (Contact as CallbackSprite).rootObject is HostileAirBot ){
					if( ((Contact as CallbackSprite).rootObject as HostileAirBot).aiItem.objectLevel == 0 ){
						SoundController.playSoundEffect("SfxPlayerHitSmallEnemy");
					} else if( ((Contact as CallbackSprite).rootObject as HostileAirBot).aiItem.objectLevel == 1 ){
						SoundController.playSoundEffect("SfxPlayerHitMediumEnemy");
					} else if( ((Contact as CallbackSprite).rootObject as HostileAirBot).aiItem.objectLevel == 2 ){
						SoundController.playSoundEffect("SfxPlayerHitLargeEnemy");
					}
					
					if( ((Contact as CallbackSprite).rootObject as HostileAirBot).healthComponent.currentHealth < 0){
						//bot died
						PlayerStats.currentLevelDataVo.kills++;
					}
				} else if( (Contact as CallbackSprite).rootObject is Village ){
					SoundController.playSoundEffect("SfxPlayerHitVillage");
				}
				
				PlayerStats.currentLevelDataVo.shotsHit++;
				var totalReward:Number = LevelData.LevelCreationData[PlayerStats.currentLevelId][8];
				if(gunComponent.isFanShot == true){
					totalReward = totalReward/gunComponent.numFanBullets;
				} else if(gunComponent.isParallelShot == true){
					totalReward = totalReward/gunComponent.numParallelBullets;
				} else if(gunComponent.isShotGunMode == true){
					totalReward = totalReward/gunComponent.numShotgunBullets;
				}
				PlayerStats.currentLevelDataVo.cashBalance += totalReward;
				
				var screenPosition:Point = new Point( 
					(FlxG.state as PlayState).gameInterface.currentMoney.x + (FlxG.state as PlayState).gameInterface.currentMoney.width - Math.random()*(String(totalReward).length*12),
					(FlxG.state as PlayState).gameInterface.currentMoney.y - Math.random()*10
				);
				EffectController.displayMessageAtPoint(screenPosition.x, screenPosition.y,Math.round(totalReward) + " Rupees",uint.MAX_VALUE,uint.MAX_VALUE,500,false);
			}
		}
		
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			super.hitBottom(Contact,Velocity);
			trace(Contact);
		}

		public function get passHealth():Number
		{
			return _passHealth;
		}

		public function set passHealth(value:Number):void
		{
			_passHealth = value;
			healthComponent.maxHealth = value;
			healthComponent.currentHealth = value;
		}
		
		override public function destroyObject():void
		{
			//EffectController.explodeAtPoint(movementComponent.PhysicalSprite);
			smokeEmitter.stop();
			if(equipSize == 2){
				var effectName:String = "EffectShipDeathLarge";
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(
						MainHullSprite.x + MainHullSprite.width/2,
						MainHullSprite.y + MainHullSprite.height/2),
					LevelData.effectData[effectName][2]
				);				
				EffectController.explodeAtPoint(MainHullSprite,"EffectWreckageLarge", 9,25,1);
				SoundController.playSoundEffect("SfxLargeEnemyShipDied")
			} else if(equipSize == 1){
				var randomNumber:Number = (Math.round(Math.random())+1);
				var effectName:String = "EffectShipDeathMedium"+randomNumber
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(
						MainHullSprite.x + MainHullSprite.width/2,
						MainHullSprite.y + MainHullSprite.height/2),
					LevelData.effectData[effectName][2]
				);				
				EffectController.explodeAtPoint(MainHullSprite,"EffectWreckageMedium", 12,20,1);
				SoundController.playSoundEffect("SfxMediumEnemyShipDied")
			} else if(equipSize == 0){
				var randomNumber:Number = (Math.round(Math.random()*2)+1);
				var effectName:String = "EffectShipDeathSmall"+randomNumber
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(
						MainHullSprite.x + MainHullSprite.width/2,
						MainHullSprite.y + MainHullSprite.height/2),
					LevelData.effectData[effectName][2]
				);				
				EffectController.explodeAtPoint(MainHullSprite,"EffectWreckageSmall", 9,15,1);
				SoundController.playSoundEffect("SfxSmallEnemyShipDied")
			}
			visualGroup.visible = false;
			
			super.destroyObject();
		}		
	}
}