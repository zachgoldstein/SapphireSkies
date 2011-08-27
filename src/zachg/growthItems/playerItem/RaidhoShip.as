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

	public class RaidhoShip extends PlayerItem
	{
		
		public function RaidhoShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			
			iconName = "PlayerShipIconMediumEnemySet2";
			
			growthItemTitle = "Raidho";
			weaponListing = "1. Metal Storm 36 \n2. MOAB";
			simpleDescription = "A purposefully designed bomber"
			description = "The Raidho is a purposefully designed bomber. Created to destroy the Islanders villages with extreme effectiveness. Armed with a Metal Storm rocket launcher that and a MOAB Carpet bomb to destroy any ground forces."
			clarityPtsRequired = 80076;
			
			playerMapping.properties.passHealth = 700;
			playerMapping.properties.thrustForce = new Point(1512,1512);
			playerMapping.properties.thrustCost = 3.5;
			playerMapping.properties.shootCost = 17.5;
			playerMapping.properties.equipSize = 1;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			//weaponMapping.properties.isLaserMode = true;
			//weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 5;
			//weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 3;	
			//weaponMapping.properties.isShotGunMode = true;
			//weaponMapping.properties.numShotgunBullets = 5;
			//weaponMapping.properties.shotgunAccuracy = 100;
			
			playerMapping.properties.cargoSizeLimit = 13;
			weaponMapping.properties.mineDistance = 2;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.shotDelay = 2
			weaponMapping.properties.shotDamage = 100;
			
			//weaponMapping.properties.bulletClass = Bomb;
			weaponMapping.properties.shotMass = 10;
			
			weaponMapping.properties.canRam = false;
			weaponMapping.properties.secondaryShotDamage = 400;
			weaponMapping.properties.secondaryShotDelay = 100;
			weaponMapping.properties.secondaryBulletClass = Bomb;
			
			weaponMapping.properties.secondaryImage = "bomb7";
			weaponMapping.properties.secondaryImageParams = [true,true,22,11];			
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon10";
			weaponMapping.properties.shotExplode = "";
			
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon10Drop";
			weaponMapping.properties.secondaryShotExplodeNoise = "SfxPlayerAltWeapon10Explode";			
			
			shipGraphic = "PlayerShipMediumEnemySet2";
			//shipGraphicParameters = [true, true, 40, 30]; 
			shipGraphicParameters = [true,true,69,46,4];
			//shipGraphicParameters = [true, true, 110, 80];

			turretGraphic = "MiscGunMedium";
			//turretGraphicParameters = [false, false, 10, 6];
			turretGraphicParameters = [false, false, 13, 8];
			//turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-45,-32);
			turretOffsetLeft = new FlxPoint(-45,-32);
			
			tutorialTipData = null
		}
	}
}