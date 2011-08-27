package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Bomb;
	import zachg.gameObjects.MiningBot;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class UruzShip extends PlayerItem
	{
		
		public function UruzShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconSmallEnemySet2";
			
			growthItemTitle = "Uruz";
			weaponListing = "1. Crimson Beam \n2. SkyShaker";
			simpleDescription = "It may be small but it delivers"
			description = "The new age fighter of the Coalition. Its revolutionary design allows it to carry only one but extremely precious weapon. The Crimson Beam fires laser precise stream of electromagnetic energy at its target burning through any armor. Uruz is a swifty little fighter with devastating firepower and that is a deadly combo."
			clarityPtsRequired = 51662;
			
			playerMapping.properties.passHealth = 500;
			playerMapping.properties.thrustForce = new Point(1728,1728);
			playerMapping.properties.thrustCost = 2.5;
			playerMapping.properties.shootCost = 12.5;
			playerMapping.properties.equipSize = 0;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			weaponMapping.properties.isLaserMode = true;
			//weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 5;
			//weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 3;	
			//weaponMapping.properties.isShotGunMode = true;
			//weaponMapping.properties.numShotgunBullets = 5;
			//weaponMapping.properties.shotgunAccuracy = 100;
			
			weaponMapping.properties.shotDelay = 11;
			weaponMapping.properties.shotDamage = 100;
			
			//weaponMapping.properties.bulletClass = Bomb;
			weaponMapping.properties.shotMass = 25;
			
			playerMapping.properties.cargoSizeLimit = 8;
			weaponMapping.properties.mineDistance = 1;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			weaponMapping.properties.canRam = false;
			weaponMapping.properties.secondaryShotDamage = 250;
			weaponMapping.properties.secondaryShotDelay = 50;
			weaponMapping.properties.secondaryBulletClass = Bomb;
			weaponMapping.properties.laserShootColor = 0x0000FF;
			weaponMapping.properties.laserThickness = 3

			weaponMapping.properties.shotNoise = "SfxPlayerWeapon9";
			weaponMapping.properties.shotExplode = "";
			
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon9Drop";
			weaponMapping.properties.secondaryShotExplodeNoise = "SfxPlayerAltWeapon9Explode"; 			
			
			weaponMapping.properties.secondaryImage = "bomb6";
			weaponMapping.properties.secondaryImageParams = [true,true,14,7];			
			
			shipGraphic = "PlayerShipSmallEnemySet2";
			shipGraphicParameters = [true,true,42,29,4]; 
			//shipGraphicParameters = [true, true, 70, 55];
			//shipGraphicParameters = [true, true, 110, 80];
			
			turretGraphic = "MiscGunSmall";
			turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			//turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-28,-22);
			turretOffsetLeft = new FlxPoint(-28,-22);
			
			tutorialTipData = null
		}
	}
}