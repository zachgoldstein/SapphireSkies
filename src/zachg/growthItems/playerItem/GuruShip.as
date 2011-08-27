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

	public class GuruShip extends PlayerItem
	{
		
		public function GuruShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			
			iconName = "PlayerShipIconMediumFriendlySet1";
			
			growthItemTitle = "Guru";
			weaponListing = "1. Nordenfelt Gun \n2. Firecracker";
			simpleDescription = "A prototype VTOL used by the Islanders."
			description = "The Guru is a prototype VTOL used by the Islanders. It has slightly more armor than an ordinary fighter and an upgraded turret called the Nordenfelt gun, which fires two rounds at a time causing double damage. As a secondary the firecracker is a simple but effective ground attack bomb."
			playerMapping.properties.passHealth = 110;
			playerMapping.properties.thrustForce = new Point(875,875);
			clarityPtsRequired = 1550;
			
			playerMapping.properties.thrustCost = 0.55;
			playerMapping.properties.shootCost = 2.75;
			playerMapping.properties.cargoSizeLimit = 5;
			playerMapping.properties.equipSize = 1;
			playerMapping.properties.cargoSizeLimit = 10;
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			//weaponMapping.properties.isFanShot = false;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 3;
			weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			weaponMapping.properties.numParallelBullets = 2;			
			weaponMapping.properties.shotDelay = 40
			weaponMapping.properties.shotDamage = 16.5;
			
			weaponMapping.properties.mineDistance = 2;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.secondaryShotDamage = 20;
			weaponMapping.properties.secondaryShotDelay = 50;
			weaponMapping.properties.secondaryBulletClass = Bomb;
			
			weaponMapping.properties.secondaryImage = "bomb1";
			weaponMapping.properties.secondaryImageParams = [true,true,12,9];
				
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon1";
			weaponMapping.properties.shotExplode = "";
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon1Drop"; 
			weaponMapping.properties.secondaryShotExplodeNoise = "SfxPlayerAltWeapon1Explode"; 			
			
			shipGraphic = "PlayerShipMediumFriendlySet1";
			//shipGraphicParameters = [true, true, 40, 30]; 
			shipGraphicParameters = [true,true,72,49,4];
			//shipGraphicParameters = [true, true, 110, 80];
			
			turretGraphic = "MiscGunMedium";
			//turretGraphicParameters = [false, false, 10, 6];
			turretGraphicParameters = [false, false, 13, 8];
			//turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-43,-40);
			turretOffsetLeft = new FlxPoint(-48,-40);

			tutorialTipData = [
				[
					"This ship is equipped with bombs...",
					"Press E or Ctrl to release a bomb",
					"They will fall and detonate on contact with anything, damaging everything nearby",
					"Bombs will fall differently depending on your speed and direction"
				],
				[
					"GameTutorialsBomb1",
					"GameTutorialsBomb2",
					"GameTutorialsBomb3",
					"GameTutorialsBomb4",
					"GameTutorialsBomb5"
				],
				[
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2))
				]
			]
		}
	}
}