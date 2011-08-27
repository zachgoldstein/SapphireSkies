package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Bomb;
	import zachg.growthItems.playerItem.PlayerItem;

	public class LaserShip extends PlayerItem
	{
		
		public function LaserShip(Id:int)
		{
			super(Id);
			requiredResearch = 400;
			playerXPRequired = 100;
			isWeapon = true;
			growthItemTitle = "LAZORS";
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			weaponMapping.properties.shotDamage = 5;
			weaponMapping.properties.isLaserMode = true;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
			
			description = "LAZORS"
			simpleDescription = "LAZORSLAZORSLAZORSLAZORSLAZORSLAZORSLAZORSLAZORSLAZORSLAZORSLAZORSLAZORSOOOOOOLAZORSLAZORSLAZORSLAZORSLAZORSLAZORS"
			weaponListing = "1. LAZOR";
			iconName = "ImgPlayer";
			
			shipGraphic = "ShipBigFriendlySet1";
			//shipGraphicParameters = [true, true, 40, 30];
			shipGraphicParameters = [true, true, 110, 80];
			turretGraphic = "MiscGunLarge";
			//turretGraphicParameters = [false, false, 10, 6];
			//turretGraphicParameters = [false, false, 13, 8];
			turretGraphicParameters = [false, false, 21, 10];	
			turretOffsetRight = new FlxPoint(-51,-59);
			turretOffsetLeft = new FlxPoint(-55,-59);
			
			tutorialTipData = null	
			
			clarityPtsRequired = 100;

			tutorialTipData = [
				[
					"LAZORS. Shoot to kill, ooRa."
				],
				[null],
				[new Point(200,(450/2)-(135/2))]
			]
			
		}
	}
}