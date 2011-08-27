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

	public class FuguShip extends PlayerItem
	{
		
		public function FuguShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconBigFriendlySet2";
			
			growthItemTitle = "Fugu";
			weaponListing = "1. Howitzer \n2. Blu-82";
			simpleDescription = "The latest marvel of the Islanders engineering"
			description = "The fearsome Fugu is the latest marvel of the Islanders engineering. Firing its massive Howitzer in a 5 shot barrage can deal enormous damage to any enemy caught within. The most powerful weapon in the Islanders arsenal is the tactical Blu-82 Nuke that makes cities vaporize."
			clarityPtsRequired = 33330;
			
			playerMapping.properties.passHealth = 1000;
			playerMapping.properties.thrustForce = new Point(1080,1080);
			playerMapping.properties.thrustCost = 5;
			playerMapping.properties.shootCost = 25;
			playerMapping.properties.equipSize = 2;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			//weaponMapping.properties.isLaserMode = true;
			weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			weaponMapping.properties.numFanBullets = 5;
			//weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 3;	
			//weaponMapping.properties.isShotGunMode = true;
			//weaponMapping.properties.numShotgunBullets = 5;
			//weaponMapping.properties.shotgunAccuracy = 100;
			
			weaponMapping.properties.shotDelay = 38
			weaponMapping.properties.shotDamage = 60;
			
			weaponMapping.properties.secondaryBulletClass = Bomb;
			weaponMapping.properties.shotMass = 25;
			
			playerMapping.properties.cargoSizeLimit = 17;
			weaponMapping.properties.mineDistance = 3;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.canRam = false;		
			weaponMapping.properties.secondaryShotDamage = 500;
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon8";
			weaponMapping.properties.shotExplode = "";
			
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon8Drop";
			weaponMapping.properties.secondaryShotExplodeNoise = "SfxPlayerAltWeapon8Explode";			
			
			weaponMapping.properties.secondaryImage = "bomb5";
			weaponMapping.properties.secondaryImageParams = [true,true,24,9];			
			
			shipGraphic = "PlayerShipBigFriendlySet2";
			//shipGraphicParameters = [true, true, 40, 30]; 
			//shipGraphicParameters = [true, true, 70, 55];
			shipGraphicParameters = [true,true,103,78,6];
			
			turretGraphic = "MiscGunLarge";
			//turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-89,-24);
			turretOffsetLeft = new FlxPoint(-89,-24);
			
			tutorialTipData = null
		}
	}
}