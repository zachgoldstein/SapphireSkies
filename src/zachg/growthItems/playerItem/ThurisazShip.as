package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class ThurisazShip extends PlayerItem
	{
		
		public function ThurisazShip(Id:int)
		{
			super(Id);
			
			isWeapon = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			iconName = "PlayerShipIconMediumEnemySet1";
			
			growthItemTitle = "Thurisaz";
			weaponListing = "1. Shafrir Missiles \n2. Dual Shock";
			simpleDescription = "Feared for its incredible firepower"
			description = "The Thurisaz Gunship is the answer to the enemies larger craft. Fitted with the new heat seeking Shafrir missiles it is a danger to any slower ships on the battlefield. Thurisaz also houses a prototype weapon mounted on its nose, Dual shock whiskers that cause shock damage to any ship close by."
			clarityPtsRequired = 5774;
			
			playerMapping.properties.passHealth = 150;
			playerMapping.properties.thrustForce = new Point(1050,1050);
			playerMapping.properties.thrustCost = 0.75;
			playerMapping.properties.shootCost = 3.75;
			playerMapping.properties.equipSize = 1;
			playerMapping.properties.cargoSizeLimit = 11;			
			
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			//weaponMapping.properties.isLaserMode = true;
			//weaponMapping.properties.isFanShot = true;
			//weaponMapping.properties.fanAngleRange= 15;
			//weaponMapping.properties.numFanBullets = 3;
			//weaponMapping.properties.isParallelShot = true;
			//weaponMapping.properties.parallelBulletSpacing = 10;
			//weaponMapping.properties.numParallelBullets = 2;			
			weaponMapping.properties.shotDelay = 30
			weaponMapping.properties.shotDamage = 45;
			
			weaponMapping.properties.mineDistance = 2;
			weaponMapping.properties.miningLifespan = 150;			
			weaponMapping.properties.miningImage = "MiscMiningBot";			
			
			weaponMapping.properties.bulletClass = Rocket;
			weaponMapping.properties.shotMass = 50;
			
			weaponMapping.properties.canRam = true;
			weaponMapping.properties.secondaryShotDamage = 50;
			weaponMapping.properties.secondaryShotDelay = 0;
			
			weaponMapping.properties.bulletImageClass = "MiscRocket1";
			weaponMapping.properties.bulletImageParams = [true,true,12,5];
			
			weaponMapping.properties.shotNoise = "SfxPlayerWeapon4Explode";
			weaponMapping.properties.shotExplode = "SfxPlayerWeapon4Launch";
			weaponMapping.properties.secondaryShotNoise = "SfxPlayerAltWeapon4"; 
			weaponMapping.properties.secondaryShotExplodeNoise = "";						

			shipGraphic = "PlayerShipMediumEnemySet1";
			//shipGraphicParameters = [true, true, 40, 30]; 
			shipGraphicParameters = [true,true,72,49,4];
			//shipGraphicParameters = [true, true, 110, 80];

			turretGraphic = "MiscGunMedium";
			//turretGraphicParameters = [false, false, 10, 6];
			turretGraphicParameters = [false, false, 13, 8];
			//turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-45,-13);
			turretOffsetLeft = new FlxPoint(-45,-13);
			
			tutorialTipData = [
				[
					"This ship is equipped with a ram...",
					"Rams are passive, simply collide with enemy ships and bases to cause damage",
					"Collide at higher velocity to do more damage",
					"Not all ships have rams, check out the ship details in the hangar"
				],
				[
					"GameTutorialsRam1",
					"GameTutorialsRam2",
					"GameTutorialsRam3",
					"GameTutorialsRam4"
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