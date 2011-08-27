package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Bomb;
	import zachg.growthItems.playerItem.PlayerItem;

	public class SlowFortress extends PlayerItem
	{
		
		public function SlowFortress(Id:int)
		{
			super(Id);
			requiredResearch = 400;
			playerXPRequired = 100;
			isWeapon = true;
			growthItemTitle = "Flying Fortress";
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			weaponMapping.properties.isShotGunMode = true;
			weaponMapping.properties.shotDamage = 30;
			weaponMapping.properties.secondaryBulletClass = Bomb;
			
			playerMapping = new Mapping(); 
			playerMapping.properties.thrustForce = new Point(800,800);
			playerMapping.properties.passHealth = 1000;
		
			description = "Shotgun of devestation, bombs of oblivion. Slow as shit and strong as hell."
			simpleDescription = "of devestation, bombs of oblivion. Slow as shit and strong as hell."				
			weaponListing = "1. Shotgun \n 2. Bombs"; 
			iconName = "ImgPlayer";
			
			shipGraphic = "ShipSmallEnemy";
			shipGraphicParameters = [59,50]; 
			
			
			isPremium = true;
			
			tutorialTipData = [
				[
					"Blah Blah Ship tutorial for secondary weapon goes here"
				],
				[null],
				[new Point(200,(450/2)-(135/2))]
			]
			
		}
	}
}