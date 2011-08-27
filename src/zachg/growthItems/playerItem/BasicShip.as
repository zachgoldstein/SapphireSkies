package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class BasicShip extends PlayerItem
	{
		
		public function BasicShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			
			iconName = "DefaultPlayerShipIcon";
			
			growthItemTitle = "Tikki";
			weaponListing = "1. Peashooter";
			simpleDescription = "Basic ship, only good to get from point A to B."
			description = "The tiny gyrocopter is one of the first chassis designs created by the Islander Machineries. By chance you have found one of the first prototypes stashed for transport in the HMS Sapphire and decided to name it Gumball for its round appearance. Mounted with a peashooter turret that fires slow .30mm rounds, it cannot give much of a fight, but it’s better than nothing."
			clarityPtsRequired = 300;
			
			playerMapping.properties.passHealth = 50;
			playerMapping.properties.thrustForce = new Point(1000,1000);
			playerMapping.properties.thrustCost = 0.25;
			playerMapping.properties.shootCost = 1.25;
			playerMapping.properties.equipSize = 0;
			playerMapping.properties.cargoSizeLimit = 5;
			//playerMapping.properties.isMiningEnabled = false;
			
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			//weaponMapping.properties.isFanShot = false;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 3;
			//weaponMapping.properties.isParallelShot = false;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 3;			
			weaponMapping.properties.shotDelay = 20
			weaponMapping.properties.shotDamage = 10;
			
			weaponMapping.properties.secondaryShotDamage = 0;
			
			weaponMapping.properties.mineDistance = 1;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon0";
			weaponMapping.properties.shotExplode = "";
			weaponMapping.properties.secondaryShotNoise = ""; 
			weaponMapping.properties.secondaryShotExplodeNoise = ""; 
			
			shipGraphic = "ShipDefaultPlayer";
			shipGraphicParameters = [true, true, 42, 30, 4]; 
			//shipGraphicParameters = [true, true, 110, 80];
			//shipGraphicParameters = [true, true, 70, 55];
			
			turretGraphic = "MiscGunSmall";
			turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			//turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-25,-17);
			turretOffsetLeft = new FlxPoint(-28,-17);
			
			tutorialTipData = null	
		}
	}
}