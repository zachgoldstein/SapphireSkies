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

	public class KikiShip extends PlayerItem
	{
		
		public function KikiShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconMediumFriendlySet2";
			
			growthItemTitle = "Kiki";
			weaponListing = "1. XS-LAZOR \n2. Kimura";
			simpleDescription = "A modified Seaplane from the days long forgotten"
			description = "The Kiki is a modified Seaplane from the days long forgotten. Now it serves as a front line medium tank. Its main weapon is the XS-LAZOR turret, which disintegrates anything in its path of fire. The Kimura is a specialized aerial ramming device."
			playerMapping.properties.passHealth = 500;
			playerMapping.properties.thrustForce = new Point(1260,1260);
			clarityPtsRequired = 21503;
			
			playerMapping.properties.thrustCost = 2.5;
			playerMapping.properties.shootCost = 12.5;
			playerMapping.properties.equipSize = 1;
			playerMapping.properties.cargoSizeLimit = 12;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			weaponMapping.properties.isLaserMode = true;
			//weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 3;
			//weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 3;	
			//weaponMapping.properties.isShotGunMode = true;
			//weaponMapping.properties.numShotgunBullets = 5;
			//weaponMapping.properties.shotgunAccuracy = 100;
			weaponMapping.properties.shotDelay = 16;
			
			weaponMapping.properties.canRam = true;
			weaponMapping.properties.secondaryShotDamage = 500;
			weaponMapping.properties.secondaryShotDelay = 0;
			//weaponMapping.properties.secondaryBulletClass = Bomb;
			
			//weaponMapping.properties.bulletClass = Rocket;
			//weaponMapping.properties.shotMass = 25;
			
			weaponMapping.properties.mineDistance = 2;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.canRam = true;		
			weaponMapping.properties.secondaryShotDamage = 750;
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon7";
			weaponMapping.properties.shotExplode = "";
			
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon7";
			weaponMapping.properties.secondaryShotExplodeNoise = ""; 			
			
			shipGraphic = "PlayerShipMediumFriendlySet2";
			//shipGraphicParameters = [true, true, 40, 30]; 
			shipGraphicParameters = [true,true,72,44,4];

			//shipGraphicParameters = [true, true, 110, 80];
			
			turretGraphic = "MiscGunMedium";
			//turretGraphicParameters = [false, false, 10, 6];
			turretGraphicParameters = [false, false, 13, 8];
			//turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-48,-17);
			turretOffsetLeft = new FlxPoint(-48,-17);
			
			tutorialTipData = null
		}
	}
}