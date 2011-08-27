package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Bomb;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class MamiShip extends PlayerItem
	{
		
		public function MamiShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconBigFriendlySet1";
			
			growthItemTitle = "Mami";
			weaponListing = "1. Flak Gun \n2. Grand Slam";
			simpleDescription = "Zeppelin class ship carries a whole fortress on its belly"
			description = "Mamy is a cargo zeppelin transformed into a battleship. Fitted with a massive flak cannon that fires three explosive rounds designed to take down any smaller target. This heavy and slow ship carries a whole fortress on its belly along with an arsenal of Grand Slam bombs designed to wipe out entire villages."
			clarityPtsRequired = 2403;
			
			playerMapping.properties.passHealth = 200;
			playerMapping.properties.thrustForce = new Point(750,750);
			playerMapping.properties.thrustCost = 1;
			playerMapping.properties.shootCost = 5;
			playerMapping.properties.equipSize = 2;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			weaponMapping.properties.numFanBullets = 3;
			//weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 2;			
			weaponMapping.properties.shotDelay = 40
			weaponMapping.properties.shotDamage = 20;
			
			playerMapping.properties.cargoSizeLimit = 15;
			weaponMapping.properties.mineDistance = 3;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.secondaryImage = "bomb2";
			weaponMapping.properties.secondaryImageParams = [true,true,13,7];
			
			weaponMapping.properties.secondaryShotDamage = 75;
			weaponMapping.properties.secondaryShotDelay = 60;
			weaponMapping.properties.secondaryBulletClass = Bomb;
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon2";
			weaponMapping.properties.shotExplode = "";
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon2Drop"; 
			weaponMapping.properties.secondaryShotExplodeNoise = "SfxPlayerAltWeapon2Explode";			
			
			shipGraphic = "PlayerShipBigFriendlySet1";
			//shipGraphicParameters = [true, true, 40, 30]; 
			//shipGraphicParameters = [true, true, 70, 55];
			shipGraphicParameters = [true,true,106,78,7];

			turretGraphic = "MiscGunLarge";
			//turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-52,-61);
			turretOffsetLeft = new FlxPoint(-52,-61);
			
			tutorialTipData = null
		}
	}
}