package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.MiningBot;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class GeboShip extends PlayerItem
	{
		
		public function GeboShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconBigEnemySet1";
			
			growthItemTitle = "Gebo";
			weaponListing = "1. MAUL Cluster \n2. Rambo";
			simpleDescription = "One of the latest Corporation military designs."
			description = "The Battle cruiser Gebo is one of the latest military designs of the Corporation. It was purposefully designed to take down swarms of enemy ships with its MAUL cluster, which fires a volley of 5 small heat-seeking missiles. Its slow speed is compromised by the prototype E-ram coating, which causes damage to any ship that comes into contact with it."
			clarityPtsRequired = 8950;

			playerMapping.properties.passHealth = 300;
			playerMapping.properties.thrustForce = new Point(900,900);
			playerMapping.properties.thrustCost = 1.5;
			playerMapping.properties.shootCost = 7.5;
			playerMapping.properties.equipSize = 2;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			//weaponMapping.properties.isLaserMode = true;
			//weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 3;
			//weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 2;	
			weaponMapping.properties.isShotGunMode = true;
			weaponMapping.properties.numShotgunBullets = 5;
			weaponMapping.properties.shotgunAccuracy = 200;
			
			weaponMapping.properties.shotDelay = 38
			weaponMapping.properties.shotDamage = 18;
			
			weaponMapping.properties.isHoming = false;
			weaponMapping.properties.bulletClass = Rocket;
			weaponMapping.properties.shotMass = 25;
			
			playerMapping.properties.cargoSizeLimit = 17;
			weaponMapping.properties.mineDistance = 3;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.canRam = true;
			weaponMapping.properties.secondaryShotDamage = 100;
			weaponMapping.properties.secondaryShotDelay = 0;
			
			weaponMapping.properties.bulletImageClass = "MiscRocket2";
			weaponMapping.properties.bulletImageParams = [true,true,16,5];			
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon5Launch";
			weaponMapping.properties.shotExplode = "SfxPlayerWeapon5Explode";

			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon5";
			weaponMapping.properties.secondaryShotExplodeNoise = "";  
			
			shipGraphic = "PlayerShipBigEnemySet1";
			//shipGraphicParameters = [true, true, 40, 30]; 
			//shipGraphicParameters = [true, true, 70, 55];
			shipGraphicParameters = [true,true,111,80,5];
			
			turretGraphic = "MiscGunLarge";
			//turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-51,-34);
			turretOffsetLeft = new FlxPoint(-51,-34);
			
			tutorialTipData = null
		}
	}
}