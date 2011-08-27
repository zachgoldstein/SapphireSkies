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

	public class BombuShip extends PlayerItem
	{
		
		public function BombuShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconSmallFriendlySet2";
			
			growthItemTitle = "Bombu";
			weaponListing = "1. Mitrailleuse \n2. Cloudmaker";
			simpleDescription = "Newest design of the Islander Machineries"
			description = "The Small Bombu fighter is the newest design of the Islander Machineries. Created purposefully to compete with the advanced Algiz enemy fighter. Bombu has mounted triple shot fast firing machine gun capable of much more firepower than its predecessor. Secondary weapon is the devastating Cloudmaker ground attack bomb."
			clarityPtsRequired = 13873;
			
			playerMapping.properties.passHealth = 250;
			playerMapping.properties.thrustForce = new Point(1440,1440);
			playerMapping.properties.thrustCost = 1.25;
			playerMapping.properties.shootCost = 6.25;
			playerMapping.properties.equipSize = 0;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			//weaponMapping.properties.isLaserMode = true;
			//weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 3;
			weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			weaponMapping.properties.numParallelBullets = 3;	
			//weaponMapping.properties.isShotGunMode = true;
			//weaponMapping.properties.numShotgunBullets = 5;
			//weaponMapping.properties.shotgunAccuracy = 100;
			
			weaponMapping.properties.shotDelay = 5
			weaponMapping.properties.shotDamage = 16.66;
			
			playerMapping.properties.cargoSizeLimit = 7;
			weaponMapping.properties.mineDistance = 1;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";
			
			weaponMapping.properties.secondaryImage = "bomb4";
			weaponMapping.properties.secondaryImageParams = [true,true,21,9];			
			
			//weaponMapping.properties.bulletClass = Rocket;
			//weaponMapping.properties.shotMass = 25;
			
			//weaponMapping.properties.canRam = true;
			weaponMapping.properties.secondaryShotDamage = 175;
			weaponMapping.properties.secondaryShotDelay = 50;
			weaponMapping.properties.secondaryBulletClass = Bomb;
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon6";
			weaponMapping.properties.shotExplode = "";
			
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon6Drop";
			weaponMapping.properties.secondaryShotExplodeNoise = "SfxPlayerAltWeapon6Explode";  			
			
			shipGraphic = "PlayerShipSmallFriendlySet2";
			shipGraphicParameters = [true,true,42,27,4]; 
			
			//shipGraphicParameters = [true, true, 70, 55];
			//shipGraphicParameters = [true, true, 110, 80];
			
			turretGraphic = "MiscGunSmall";
			turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			//turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-17,-9);
			turretOffsetLeft = new FlxPoint(-17,-9);
			
			tutorialTipData = null
		}
	}
}