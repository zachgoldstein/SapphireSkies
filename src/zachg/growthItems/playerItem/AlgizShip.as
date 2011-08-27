package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Bomb;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class AlgizShip extends PlayerItem
	{
		
		public function AlgizShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconSmallEnemySet1";
			
			growthItemTitle = "Algiz";
			weaponListing = "1. Dual Tac \n2. ARG-152";
			simpleDescription = "Frontline unit of the Corporation"
			description = "From the Forges of the Corporation came the Algiz design gunship. Designed to be produced in large numbers and as the frontline unit of the Corporation. It lacks the armor but wields a Dual-Tac cannon which fires two slow but power shots at once. Also fitted with small ARG shells to bomb ground targets."
			clarityPtsRequired = 3725;
			
			playerMapping.properties.passHealth = 70;
			playerMapping.properties.thrustForce = new Point(1200,1200);
			playerMapping.properties.thrustCost = 0.35;
			playerMapping.properties.shootCost = 1.75;
			playerMapping.properties.equipSize = 0;
			playerMapping.properties.cargoSizeLimit = 6;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			//weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 3;
			weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			weaponMapping.properties.numParallelBullets = 2;			
			weaponMapping.properties.shotDelay = 6;
			weaponMapping.properties.shotDamage = 7;
			
			weaponMapping.properties.secondaryShotDamage = 100;
			weaponMapping.properties.secondaryShotDelay = 70;
			weaponMapping.properties.secondaryBulletClass = Bomb;
			
			weaponMapping.properties.secondaryImage = "bomb3";
			weaponMapping.properties.secondaryImageParams = [true,true,18,10];			
			
			weaponMapping.properties.mineDistance = 1;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon3";
			weaponMapping.properties.shotExplode = "";
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon3Drop"; 
			weaponMapping.properties.secondaryShotExplodeNoise = "SfxPlayerAltWeapon3Explode";
			
			shipGraphic = "PlayerShipSmallEnemySet1";
			shipGraphicParameters = [true, true, 40, 28 ,4];
			
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