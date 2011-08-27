package zachg.gameObjects
{
	import com.GlobalVariables;
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

	public class Bomb extends BulletGroup
	{
		
		public var target:FlxObject;
		public var movementComponent:MovementComponent;
		public var bombRange:Number = 200;
		public var explodeNoise:String;
		
		
		public function Bomb(BulletCollideCallback:Function = null)
		{
			super(BulletCollideCallback,false);
			//bullet = new CallbackSprite(0,0,bulletCollision,this);
			//bullet.loadGraphic(Resources.Rocket,false,false,15,33);
			//add(bullet);
			//bullet.visible = false;

			bulletLifeSpan = 80; 
			bulletDamage = 100;
			bulletMass = 25;
			
			movementComponent = new MovementComponent(bulletCollision,this);
			movementComponent.PhysicalSprite = new CallbackSprite(0,0,bulletCollision,this);			
			movementComponent.PhysicalSprite.acceleration.y = GlobalVariables.gravityAcceleration.y;
			
			movementComponent.isAir = false;
			movementComponent.isGround = false;
			if(bulletImageClass != null){
				movementComponent.PhysicalSprite.loadGraphic(
					bulletImageClass,
					bulletImageParams[0],
					bulletImageParams[1],
					bulletImageParams[2],
					bulletImageParams[3]
				);
			} else {
				movementComponent.PhysicalSprite.loadGraphic(Resources.MiscBomb,false,false,14,7);
			}
			addComponent(movementComponent);
			
		}
		
		public override function update():void
		{
			super.update();
			movementComponent.update();
		}

		override public function bulletCollision(Contact:FlxObject, Velocity:Number, collisionSide:String):void
		{			
			detonate();
			
			if(Contact is CallbackSprite){
				if( (Contact as CallbackSprite).rootObject is GroupGameObject){
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
			}			
			
			destroyObject();
		}
		
		public function detonate():void
		{
			SoundController.playSoundEffect(explodeNoise);
			var group:FlxGroup;
			if(isEnemy == false){
				group = (FlxG.state as PlayState).enemyGroup;
			} else {
				group = (FlxG.state as PlayState).friendlyGroup;
			} 
			
			damageEnemiesInGroup((FlxG.state as PlayState).friendlyGroup);
			damageEnemiesInGroup((FlxG.state as PlayState).enemyGroup);
			damageEnemiesInGroup((FlxG.state as PlayState).enemyBuildings);
			damageEnemiesInGroup((FlxG.state as PlayState).friendlyBuildings);
			
			if( bulletLevel == 0 || 1){
				var effectName:String = "EffectMissileHitMedium1";
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
					LevelData.effectData[effectName][2]
				);
				
			} else {
				var effectName:String = "EffectMissileHitLarge";
				EffectController.showEffectAnimation(
					effectName,
					LevelData.effectData[effectName][0],
					LevelData.effectData[effectName][1],
					new Point(movementComponent.PhysicalSprite.x,movementComponent.PhysicalSprite.y),
					LevelData.effectData[effectName][2]
				);
			}
			EffectController.explodeAtPoint(movementComponent.PhysicalSprite,"EffectWreckageSmall", 9,50,3);
		}
		
		public function damageEnemiesInGroup(group:FlxGroup):void
		{
			var distance:Number;
			var currentBotDistanceCheck:GroupGameObject;
			
			for ( var i:int = 0 ; i < group.members.length; i++){
				currentBotDistanceCheck = group.members[i];
				if(isEnemy != currentBotDistanceCheck.isEnemy && currentBotDistanceCheck.dead == false){
					distance = Math.sqrt( 	(currentBotDistanceCheck.x - movementComponent.PhysicalSprite.x)*(currentBotDistanceCheck.x - movementComponent.PhysicalSprite.x) +
						(currentBotDistanceCheck.y - movementComponent.PhysicalSprite.y)*(currentBotDistanceCheck.y - movementComponent.PhysicalSprite.y) );
					if(distance < bombRange){
						var proximitryPercent:Number = (distance / bombRange);
						EffectController.displayMessageAtPoint((currentBotDistanceCheck as GroupGameObject).x,(currentBotDistanceCheck as GroupGameObject).y,Math.round(bulletDamage*proximitryPercent) +"pts");
						(currentBotDistanceCheck as GroupGameObject).healthComponent.currentHealth -= Math.round(bulletDamage*proximitryPercent);
						(currentBotDistanceCheck as GroupGameObject).healthComponent.update();

						if(group.members[i] is Village){}
						else {
/*							var dy:Number = currentBotDistanceCheck.y - movementComponent.PhysicalSprite.y;
							var dx:Number = currentBotDistanceCheck.x - movementComponent.PhysicalSprite.x;
							
							var angleInDegrees:Number = FlxU.getAngle(dx,dy);
							
							var percentToChangeVelocity:Number = bulletMass/maxBulletMass;
							if(currentBotDistanceCheck is HostileAirBot){
								percentToChangeVelocity /= ((currentBotDistanceCheck as HostileAirBot).aiItem.objectLevel+1); 
							} else if(currentBotDistanceCheck is PlayerGroup){
								var playerLevel:Number = (PlayerStats.growthItems[PlayerStats.currentPlayerDataVo.currentPlayerEquip] as PlayerItem).playerMapping.properties.equipSize + 1;
								percentToChangeVelocity /= playerLevel;
							}			
							percentToChangeVelocity /= proximitryPercent;
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
								currentBotDistanceCheck.velocity.y += amountToChangeY;
							} else {
								currentBotDistanceCheck.velocity.y -= amountToChangeY;						
							}
							
							if( Math.abs(angleInDegrees) > 90 ){
								currentBotDistanceCheck.velocity.x -= amountToChangeX;
							} else {
								currentBotDistanceCheck.velocity.x += amountToChangeX;
							}*/
							
						}
					}
				}				
			} 				
			
		}
		
	}
}