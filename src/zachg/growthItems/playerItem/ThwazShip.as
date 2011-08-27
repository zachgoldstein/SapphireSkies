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

	public class ThwazShip extends PlayerItem
	{
		
		public function ThwazShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			
			iconName = "PlayerShipIconBigEnemySet2";
			
			growthItemTitle = "Thwaz";
			weaponListing = "1. Rathian Torpedo \n2. Crystal Saw";
			simpleDescription = "A massive Battle Cruiser armed with the most powerful weaponry"
			description = "Marvel of the Coalition Fleet. Thwaz is a massive Battle Cruiser armed with the most powerful weaponry mankind has ever seen. The Rathian Torpedo is designed to fly through the air and explode in the middle of an enemy fleet to cause enormous damage. The most bizarre feature of this ship is the massive chainsaw mounted on the beak. Reinforced with crystal steel it will cut through almost any armor causing extreme damage. "
			clarityPtsRequired = 124118;
			
			playerMapping.properties.passHealth = 1500;
			playerMapping.properties.thrustForce = new Point(1296,1296);
			playerMapping.properties.thrustCost = 7.5;
			playerMapping.properties.shootCost = 37.5;
			playerMapping.properties.equipSize = 2;
			playerMapping.properties.cargoSizeLimit = 18;
			
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
			
			weaponMapping.properties.shotDelay = 10
			weaponMapping.properties.shotDamage = 250;
			
			weaponMapping.properties.bulletClass = Rocket;
			weaponMapping.properties.shotMass = 10;
			
			weaponMapping.properties.mineDistance = 3;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.canRam = true;
			weaponMapping.properties.secondaryShotDamage = 600;
			weaponMapping.properties.secondaryShotDelay = 0;
			//weaponMapping.properties.secondaryBulletClass = Bomb;
			
			weaponMapping.properties.bulletImageClass = "MiscRocket3";
			weaponMapping.properties.bulletImageParams = [true,true,21,5];			
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon11Launch";
			weaponMapping.properties.shotExplode = "SfxPlayerWeapon11Explode";
			
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon11";
			weaponMapping.properties.secondaryShotExplodeNoise = "";			
			
			shipGraphic = "PlayerShipBigEnemySet2";
			//shipGraphicParameters = [true, true, 40, 30]; 
			//shipGraphicParameters = [true, true, 70, 55];
			shipGraphicParameters = [true,true,109,75,2];

			turretGraphic = "MiscGunLarge";
			//turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-20,-49);
			turretOffsetLeft = new FlxPoint(-20,-49);
			
			tutorialTipData = null
		}
	}
}