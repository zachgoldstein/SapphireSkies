package zachg.gameObjects
{
	import com.PlayState;
	import com.Resources;
	
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	import zachg.GroupGameObject;
	import zachg.PlayerStats;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.util.EffectController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;

	public class BulletGroup extends GroupGameObject
	{
		public var bullet:CallbackSprite;
		public var bulletCollideCallback:Function;
		public var bulletLifeSpan:Number = 40;
		public var bulletAge:Number = 0;
		public var bulletDamage:Number = 0;
		public var bulletMass:Number = 10;
		
		public var bulletLevel:Number = 0;
		
		public var bulletImageClass:Class;
		public var bulletImageParams:Array;
		
		public static var maxBulletMass:Number = 100;
		public static var maxVelocityChange:Number = 750;
		
		public static var MAXBULLETDAMAGE:Number = 600;
		
		public var isCounted:Boolean = false;
		
		public function BulletGroup(BulletCollideCallback:Function = null, createBullet:Boolean = true)
		{
			bulletCollideCallback = BulletCollideCallback
			if(createBullet == true){
				bullet = new CallbackSprite(0,0,bulletCollision,this);
				if(bulletImageClass != null){
					bullet.loadGraphic(
						bulletImageClass,
						bulletImageParams[0],
						bulletImageParams[1],
						bulletImageParams[2],
						bulletImageParams[3]
					);
				} else {
					bullet.loadGraphic(Resources.MiscBullet,false,false,4,4);
				}				
				add(bullet);
			}
			
		}
		
		public override function update():void
		{
			if(isFrozen == true){
				return
			}
			
			super.update();
			bulletAge++;
			if(bulletLifeSpan < bulletAge){
				if(bullet != null){
					if( bulletLevel == 0){
						var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectBulletmissSmall"+randomNumber
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(bullet.x,bullet.y),
							LevelData.effectData[effectName][2]
						);
					} else if( bulletLevel == 1){
						var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectBulletmissMedium"+randomNumber
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(bullet.x,bullet.y),
							LevelData.effectData[effectName][2]
						);
					} else if( bulletLevel == 2){
						var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectBulletmissLarge"+randomNumber
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(bullet.x,bullet.y),
							LevelData.effectData[effectName][2]
						);								
					}					
				}
				kill();
			}
		}
		
		public function bulletCollision(Contact:FlxObject, Velocity:Number, collisionSide:String):void
		{
			if(Contact is CallbackSprite){
				if( (Contact as CallbackSprite).rootObject is GroupGameObject){
					//Damage
					((Contact as CallbackSprite).rootObject as GroupGameObject).healthComponent.currentHealth -= bulletDamage;
					((Contact as CallbackSprite).rootObject as GroupGameObject).healthComponent.update();
					
					//change position
					if( (Contact as CallbackSprite).rootObject is HostileAirBot ||
						(Contact as CallbackSprite).rootObject is PlayerGroup
					){
						if((Contact as CallbackSprite).rootObject is PlayerGroup){
							SoundController.playSoundEffect("SfxPlayerGotHit");
						} else {

						}
						
						var dx:Number = bullet.velocity.x;
						var dy:Number = bullet.velocity.y;
						
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
					EffectController.displayMessageAtPoint(bullet.x,bullet.y, bulletDamage +"pts");
					
					if( bulletLevel == 0){
						var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectBulletHitSmall"+randomNumber
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(bullet.x,bullet.y),
							LevelData.effectData[effectName][2]
						);
					} else if( bulletLevel == 1){
						var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectBulletHitMedium"+randomNumber
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(bullet.x,bullet.y),
							LevelData.effectData[effectName][2]
						);
					} else if( bulletLevel == 2){
						var randomNumber:Number = (Math.round(Math.random()*2)+1);
						var effectName:String = "EffectBulletHitLarge"+randomNumber
						EffectController.showEffectAnimation(
							effectName,
							LevelData.effectData[effectName][0],
							LevelData.effectData[effectName][1],
							new Point(bullet.x,bullet.y),
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
									bullet.x,
									bullet.y,
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
						new Point(bullet.x,bullet.y),
						LevelData.effectData[effectName][2]
					);
				} else if( bulletLevel == 1){
					var randomNumber:Number = (Math.round(Math.random()*2)+1);
					var effectName:String = "EffectBulletmissMedium"+randomNumber
					EffectController.showEffectAnimation(
						effectName,
						LevelData.effectData[effectName][0],
						LevelData.effectData[effectName][1],
						new Point(bullet.x,bullet.y),
						LevelData.effectData[effectName][2]
					);
				} else if( bulletLevel == 2){
					var randomNumber:Number = (Math.round(Math.random()*2)+1);
					var effectName:String = "EffectBulletmissLarge"+randomNumber
					EffectController.showEffectAnimation(
						effectName,
						LevelData.effectData[effectName][0],
						LevelData.effectData[effectName][1],
						new Point(bullet.x,bullet.y),
						LevelData.effectData[effectName][2]
					);								
				}
			}
			
			if(bulletCollideCallback != null && isCounted == false){ 
				bulletCollideCallback(Contact, Velocity, collisionSide)
				isCounted = true;
			}
			
			destroyObject();
		}
		
	}
}