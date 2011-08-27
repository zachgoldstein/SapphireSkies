package zachg.gameObjects
{
	import com.PlayState;
	import com.Resources;
	
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	import zachg.GroupGameObject;
	import zachg.PlayerStats;
	import zachg.components.MovementComponent;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.util.EffectController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;

	public class Rocket extends BulletGroup
	{
		
		public var target:FlxObject;
		public var isHoming:Boolean = true;
		public var movementComponent:MovementComponent;
		public var explodeNoise:String = "";

		public function Rocket(BulletCollideCallback:Function = null)
		{
			super(BulletCollideCallback,false);
			//bullet = new CallbackSprite(0,0,bulletCollision,this);
			//bullet.loadGraphic(Resources.Rocket,false,false,15,33);
			
			bulletLifeSpan = 80; 
			bulletMass = 10;
			
			movementComponent = new MovementComponent(bulletCollision,this);
			movementComponent.PhysicalSprite = new CallbackSprite(0,0,bulletCollision,this);
			
			movementComponent.isAir = true;
			movementComponent.isGround = false;
			movementComponent.thrustForce = new Point(500,500);
			movementComponent.targetStopRange = -1;
			movementComponent.rotateSpeedMultiplier = 3;
			movementComponent.PhysicalSprite.acceleration.y = 0;
			movementComponent.PhysicalSprite.loadGraphic(Resources.MiscRocket,false,false,12,5);
			addComponent(movementComponent);
			
		}
		
		public override function update():void
		{
			super.update();
			//bullet.x = movementComponent.PhysicalSprite.x;
			//bullet.y = movementComponent.PhysicalSprite.y;
			
			var targets:FlxGroup = new FlxGroup();
			if(isHoming == true){
				if(isEnemy == false){
					findClosestObject( (FlxG.state as PlayState).enemyGroup, true );
				} else {
					findClosestObject( (FlxG.state as PlayState).friendlyGroup, true );
				}
			} else {
				movementComponent.randomizeDirection = true;
			}
			
			movementComponent.update();
			
		}
		
		override public function bulletCollision(Contact:FlxObject, Velocity:Number, collisionSide:String):void
		{
			if(Contact is CallbackSprite){
				if( (Contact as CallbackSprite).rootObject is GroupGameObject){
					SoundController.playSoundEffect(explodeNoise);
					
					//Damage
					((Contact as CallbackSprite).rootObject as GroupGameObject).healthComponent.currentHealth -= bulletDamage;
					((Contact as CallbackSprite).rootObject as GroupGameObject).healthComponent.update();
					
					//change position
					if( (Contact as CallbackSprite).rootObject is HostileAirBot ||
						(Contact as CallbackSprite).rootObject is PlayerGroup
					){
						if((Contact as CallbackSprite).rootObject is PlayerGroup){
							SoundController.playSoundEffect("SfxPlayerGotHit");
						}
						
						var dx:Number = movementComponent.PhysicalSprite.velocity.x;
						var dy:Number = movementComponent.PhysicalSprite.velocity.y;
						
						var angleInDegrees:Number = FlxU.getAngle(dx,dy);
						
						var percentToChangeVelocity:Number = bulletMass/maxBulletMass;
						if((Contact as CallbackSprite).rootObject is HostileAirBot){
							percentToChangeVelocity /= (((Contact as CallbackSprite).rootObject as HostileAirBot).aiItem.objectLevel+1); 
						} else if((Contact as CallbackSprite).rootObject is PlayerGroup){
							var playerLevel:Number = (PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).playerMapping.properties.equipSize + 1;
							percentToChangeVelocity /= playerLevel;
						}						
						var amountToChangeVelocity:Number = percentToChangeVelocity*maxVelocityChange;
						
						var amountToChangeX:Number;
						if( Math.abs(angleInDegrees) > 90 ){
							amountToChangeX = ((180 - Math.abs(angleInDegrees) ) /90)*amountToChangeVelocity;
						} else {
							amountToChangeX = ((90 - Math.abs(angleInDegrees))/90)*amountToChangeVelocity;
						}
						var amountToChangeY:Number;
						if( Math.abs(angleInDegrees) > 90 ){
							amountToChangeY = ((180 - Math.abs(angleInDegrees) ) /90)*amountToChangeVelocity;
						} else {
							amountToChangeY = (Math.abs(angleInDegrees)/90)*amountToChangeVelocity;
						}
						
						if(angleInDegrees > 0){
							Contact.velocity.y += amountToChangeY;
						} else {
							Contact.velocity.y -= amountToChangeY;						
						}
						
						if( Math.abs(angleInDegrees) > 90 ){
							Contact.velocity.x -= amountToChangeX;
						} else {
							Contact.velocity.x += amountToChangeX;
						}
					} 
					
					//annouce the damage
					EffectController.displayMessageAtPoint(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y, bulletDamage +"pts");
					
					if( bulletLevel == 0){
						var randomNumber:Number = (Math.round(Math.random())+1);
						var effectName:String = "EffectMissileHitSmall"+randomNumber
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
							LevelData.effectData[effectName][2]
						);
					} else if( bulletLevel == 1){
						//var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectMissileHitMedium1";
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
							LevelData.effectData[effectName][2]
						);
					} else if( bulletLevel == 2){
						//var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectMissileHitLarge";
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
							LevelData.effectData[effectName][2]
						);								
					}
					
				}
			} else if(Contact is FlxTilemap){
				var explosionProbability:Number = bulletDamage/BulletGroup.MAXBULLETDAMAGE + .25;
				
				if(Math.random() < explosionProbability){
					var explosionRange:Number = (Math.ceil(10*(bulletDamage/BulletGroup.MAXBULLETDAMAGE)) + 1)*10;
					for (var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.masterLayer.members.length; i++){
						if((FlxG.state as PlayState).currentLevel.masterLayer.members[i] is FlxTilemap){
							if( ((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).dataObject.isDestroyable == true ){
								((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).clearTilesInCircle(
									movementComponent.PhysicalSprite.x,
									movementComponent.PhysicalSprite.y,
									explosionRange);
							}
						}
					}
				}
				if( bulletLevel == 0){
					var randomNumber:Number = (Math.round(Math.random()*2)+1);
					var effectName:String = "EffectBulletmissSmall"+randomNumber
					EffectController.showEffectAnimation(
						effectName,
						LevelData.effectData[effectName][0],
						LevelData.effectData[effectName][1],
						new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
						LevelData.effectData[effectName][2]
					);
				} else if( bulletLevel == 1){
					var randomNumber:Number = (Math.round(Math.random()*2)+1);
					var effectName:String = "EffectBulletmissMedium"+randomNumber
					EffectController.showEffectAnimation(
						effectName,
						LevelData.effectData[effectName][0],
						LevelData.effectData[effectName][1],
						new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
						LevelData.effectData[effectName][2]
					);
				} else if( bulletLevel == 2){
					var randomNumber:Number = (Math.round(Math.random()*2)+1);
					var effectName:String = "EffectBulletmissLarge"+randomNumber
					EffectController.showEffectAnimation(
						effectName,
						LevelData.effectData[effectName][0],
						LevelData.effectData[effectName][1],
						new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
						LevelData.effectData[effectName][2]
					);								
				}				
			}			
			
			if(bulletCollideCallback != null){ bulletCollideCallback(Contact, Velocity, collisionSide) }
			
			destroyObject();
		}
		
		
		private function findClosestObject(group:FlxGroup,setTarget:Boolean = false):GroupGameObject{
			var objectsInRange:Array = new Array();
			
			var distance:Number;
			var currentBotDistanceCheck:GroupGameObject;
			var shortestDistance:Number = 99999;
			var currentClosestObject:GroupGameObject;
			
			for ( var i:int = 0 ; i < group.members.length; i++){
				currentBotDistanceCheck = group.members[i];
				if(currentBotDistanceCheck is BulletGroup){
				} else {
					if(isEnemy != currentBotDistanceCheck.isEnemy && currentBotDistanceCheck.dead == false){
						distance = Math.sqrt( 	(currentBotDistanceCheck.x - x)*(currentBotDistanceCheck.x - x) +
							(currentBotDistanceCheck.y - y)*(currentBotDistanceCheck.y - y) );
						objectsInRange.push( currentBotDistanceCheck);
						if(shortestDistance > distance){
							if(setTarget == true){
								movementComponent.moveObjectTarget = currentBotDistanceCheck;
							}
							shortestDistance = distance;
							currentClosestObject = currentBotDistanceCheck;
						}
					}
				}
			}
			return currentClosestObject
		}
				
		
	}
}