package zachg.gameObjects
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	
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
	import zachg.Mineral;
	import zachg.components.GunComponent;
	import zachg.components.HealthComponent;
	import zachg.components.MiningComponent;
	import zachg.components.MovementComponent;
	import zachg.growthItems.aiItem.AiItem;
	import zachg.ui.gameComponents.MiningBar;
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
	public class MiningBot extends Bot
	{

		
		public var target:FlxObject;
		
		public var deathEmitter:FlxEmitter;
		
		public var level:Number = 0;
		
		public var mineDistance:Number = 3;
		public var didCollideWithGround:Boolean = false;
		
		public var miningBar:MiningBar = new MiningBar();
		public var miningComponent:MiningComponent = new MiningComponent();
		
		public var botLifeSpan:Number = 200;
		public var botAge:Number = 0;
		
		public var collisionSide:String;
		
		public var gravityResetTimeLength:Number = 10;
		public var timeSinceGravityChanged:Number = 0;	
		public var miningBotImageClass:Class;
		
		public function MiningBot(creationCallback:Function = null)
		{
			objectCreatedCallback = creationCallback;
			movementComponent = new MovementComponent(botCollision,this);
			movementComponent.PhysicalSprite = new CallbackSprite(0,0,botCollision,this);
			movementComponent.PhysicalSprite.acceleration.y = GlobalVariables.gravityAcceleration.y;
			
			movementComponent.isAir = false;
			movementComponent.isGround = false;
			healthComponent = new HealthComponent();
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;
			movementComponent.PhysicalSprite.acceleration.y = 9.8*10;
			movementComponent.PhysicalSprite.maxVelocity.x = 300;
			movementComponent.PhysicalSprite.maxVelocity.y = 300;
			movementComponent.PhysicalSprite.drag.x = 25;
			movementComponent.PhysicalSprite.drag.y = 25;
			
			healthComponent.maxHealth = 300;
			healthComponent.currentHealth = 300;
			
			botName = "Mining Bot";
			
			deathEmitter = new FlxEmitter();
		}
		
		override public function createBot(movementTarget:FlxPoint, Level:Number = 0, aiItem:AiItem = null):void
		{
			level = Level;
			
			//set properties specific to type (note that some are also set in Factory, but will be more general properties)
			movementComponent.PhysicalSprite.createGraphic(40,38);
/*			if(miningBotImageClass != null){
				movementComponent.hullSprite.loadGraphic(miningBotImageClass,true,true,34,28);
			} 
*/			if(level == 0){
				miningBotImageClass = Resources.MiscMiningBotSmall;
				movementComponent.hullSprite.loadGraphic(miningBotImageClass,true,true,30,28);
			} else if(level == 1){
				miningBotImageClass = Resources.MiscMiningBotMedium;
				movementComponent.hullSprite.loadGraphic(miningBotImageClass,true,true,32,25);
			} else if(level == 2){
				miningBotImageClass = Resources.MiscMiningBotLarge;
				movementComponent.hullSprite.loadGraphic(miningBotImageClass,true,true,34,21);
			}
 
				
			movementComponent.hullSprite.solid = true;
			movementComponent.PhysicalSprite.solid = true;
			movementComponent.PhysicalSprite.visible = false;
			
			//assorted other stuff
			healthComponent.healthBar.width = movementComponent.PhysicalSprite.width;	
			healthComponent.drawVisual();
			
			miningComponent.bodyObject = movementComponent.hullSprite;
			
			miningBar = new MiningBar();
			miningBar.mineBar.width = movementComponent.PhysicalSprite.width;			
			
			//add to group
			add(movementComponent.hullSprite);
			addComponent(movementComponent);
			add(healthComponent.graphicHolder);
			add(miningBar.graphicHolder)
			
			update();
			//dirty hack to get healthbars to render at start
			healthComponent.currentHealth--;
			healthComponent.currentHealth++;
			
		}
		
		override public function update():void
		{
			super.update();
			
			if(isFrozen == true){
				return
			}
			
			botAge++;
			if(botLifeSpan < botAge){
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
				destroyObject();
			}
			
			//movementComponent.update();
			
			if(miningComponent.lastMinedCounter <= miningComponent.mineDelay){
				miningBar.currentMineProgress = miningComponent.lastMinedCounter;
				miningBar.mineDelay = miningComponent.mineDelay;
			}
			
			miningBar.showMineCounter = 0;
			healthComponent.showHealth = true
			healthComponent.showHealthCounter = 0;
			
			miningBar.x = movementComponent.PhysicalSprite.x;
			miningBar.y = movementComponent.PhysicalSprite.y -miningBar.spriteCanvas.height + 6;			
			miningBar.drawVisual();
			miningBar.update();			
			
			//TODO: this is very very intensive, rework how the components get updates so that they don't have to do it every frame.
			//movementComponent.update();
			miningComponent.location.x = movementComponent.PhysicalSprite.x;
			miningComponent.location.y = movementComponent.PhysicalSprite.y;
			
			healthComponent.x = movementComponent.PhysicalSprite.x;
			healthComponent.y = miningBar.y - 10;			
			healthComponent.drawVisual();
			healthComponent.update();
			
			miningComponent.update();
			
			if( Math.abs( movementComponent.PhysicalSprite.velocity.x) >
				Math.abs( movementComponent.PhysicalSprite.velocity.y)
			) {
				if( movementComponent.PhysicalSprite.velocity.x > 0){
					movementComponent.PhysicalSprite.angle = 0;
					movementComponent.hullSprite.angle = 0;
				} else {
					movementComponent.PhysicalSprite.angle = 180;
					movementComponent.hullSprite.angle = 180;
				}
			} else {
				if( movementComponent.PhysicalSprite.velocity.y > 0){
					movementComponent.PhysicalSprite.angle = 90;
					movementComponent.hullSprite.angle = 90;
				} else {
					movementComponent.PhysicalSprite.angle = 270;
					movementComponent.hullSprite.angle = 270;
				}
			}			
			
			if(timeSinceGravityChanged > gravityResetTimeLength){
				resetGravity();
			}
			timeSinceGravityChanged++;
		}
		
		override public function botCollision(object:FlxObject, Velocity:Number,collisionSide:String):void
		{
			if(miningComponent.numTimesMined < mineDistance){
				timeSinceGravityChanged = 0;
				if(movementComponent.PhysicalSprite.angle == 270){
					if(collisionSide == "top"){
						if( miningComponent.mineArea(object as FlxTilemap,"up") == true){
							movementComponent.PhysicalSprite.velocity.y -= 100;
							movementComponent.PhysicalSprite.acceleration.y = -9.8;
							(FlxG.state as PlayState).tileMapChanged();
							SoundController.playSoundEffect("SfxMineBotExcavates");
							EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageSmall", 9,15,1);
						}
					}
				} else if(movementComponent.PhysicalSprite.angle == 90){
					if(collisionSide == "bottom"){
						if( miningComponent.mineArea(object as FlxTilemap,"down") == true){
							movementComponent.PhysicalSprite.velocity.y += 100;
							(FlxG.state as PlayState).tileMapChanged();
							SoundController.playSoundEffect("SfxMineBotExcavates");
							EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageSmall", 9,15,1);
						}
					}
				} else if(movementComponent.PhysicalSprite.angle == 0){
					if(collisionSide == "right"){
						if( miningComponent.mineArea(object as FlxTilemap,"right") == true){
							movementComponent.PhysicalSprite.velocity.x += 100;
							movementComponent.PhysicalSprite.acceleration.y = 0;
							movementComponent.PhysicalSprite.acceleration.x = 9.8;
							(FlxG.state as PlayState).tileMapChanged();
							SoundController.playSoundEffect("SfxMineBotExcavates");
							EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageSmall", 9,15,1);
						}
					}
				} else if(movementComponent.PhysicalSprite.angle == 180){
					if(collisionSide == "left"){
						if( miningComponent.mineArea(object as FlxTilemap,"left") == true){
							movementComponent.PhysicalSprite.velocity.x -= 100;
							movementComponent.PhysicalSprite.acceleration.y = 0;
							movementComponent.PhysicalSprite.acceleration.x = -9.8;
							(FlxG.state as PlayState).tileMapChanged();
							SoundController.playSoundEffect("SfxMineBotExcavates");
							EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageSmall", 9,15,1);
						}
					}
				}
			}
			
			if(miningComponent.numTimesMined >= mineDistance){
				reverseOutOfMinedArea();
				resetGravity();
			}
			
		}
		
		public function reverseOutOfMinedArea():void
		{
			if(movementComponent.PhysicalSprite.angle == 0){
				movementComponent.PhysicalSprite.velocity.x += 100*mineDistance;
			} else if(movementComponent.PhysicalSprite.angle == 180){
				movementComponent.PhysicalSprite.velocity.x -= 100*mineDistance;
			} else if(movementComponent.PhysicalSprite.angle == 90){
				movementComponent.PhysicalSprite.velocity.y -= 100*mineDistance;
			} else if(movementComponent.PhysicalSprite.angle == -90){	
				movementComponent.PhysicalSprite.velocity.y += 100*mineDistance;
			}				
		}
		
		public function resetGravity():void
		{
			movementComponent.PhysicalSprite.acceleration.y = 9.8*10;
			movementComponent.PhysicalSprite.acceleration.x = 0;	
		}
		
		public function giveCargoToPlayer():void
		{
			
			if(miningComponent.currentMinerals.length == 0){
				return
			}

			if( (FlxG.state as PlayState).player.cargoSizeLimit - (FlxG.state as PlayState).player.currentPlayerMinerals.length <
				miningComponent.currentMinerals.length){
				EffectController.displayMessageAtPoint(	movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y-50,"Not enough space in cargo for all mined minerals",
					0xEEEE00, 
					0x000000,
					50);
			} else {
				EffectController.displayMessageAtPoint(	movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y-50,"Minerals Obtained!",
					0xEEEE00, 
					0x000000,
					50);
				SoundController.playSoundEffect("SfxMineBotDepositsMinerals");
			}
			var totalMineralValue:Number = 0;
			for ( var i:int = 0 ; i < miningComponent.currentMinerals.length ; i++ ){
				if( (FlxG.state as PlayState).player.currentPlayerMinerals.length < (FlxG.state as PlayState).player.cargoSizeLimit){
					(FlxG.state as PlayState).player.currentPlayerMinerals.push(miningComponent.currentMinerals[i]);
					totalMineralValue += miningComponent.currentMinerals[i].resourceValue;
				}
			}
			miningComponent.currentMinerals = new Vector.<Mineral>();
			(FlxG.state as PlayState).player.levelComponent.currentExperience += totalMineralValue;
			
			destroyObject();
		}
		
		override public function botOverlapsBuilding(building:BuildingGroup):void
		{
			
		}
		
		override public function destroyObject():void
		{
			EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageSmall", 9,15,1);
			super.destroyObject();
		}
		
	}
}