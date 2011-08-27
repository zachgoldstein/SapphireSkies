package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.MiningBot;
	import zachg.growthItems.playerItem.PlayerItem;

	public class FastMiner extends PlayerItem
	{
		
		public function FastMiner(Id:int)
		{
			super(Id);
			requiredResearch = 400;
			playerXPRequired = 100;
			isWeapon = true;
			growthItemTitle = "Fast Mining Ship";
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			weaponMapping.properties.isShotGunMode = false;
			weaponMapping.properties.shotDamage = 20;
			weaponMapping.properties.secondaryBulletClass = MiningBot;
			
			playerMapping = new Mapping(); 
			playerMapping.properties.thrustForce = new Point(4000,4000);
			playerMapping.properties.passHealth = 100;
		
			description = "Weak, but fast. Has mining bots for increased monetary value."
			weaponListing = "1. Machinegun \n 2. Mining Bots";
			iconName = "ImgPlayer";
			shipGraphic = "ShipSmallEnemy";
			shipGraphicParameters = [59,50]; 
			
			
			tutorialTipData = [
				[
					"Blah Blah Ship tutorial for secondary weapon goes here"
				],
				[null],
				[new Point(200,(450/2)-(135/2))]
			];			
		}
	}
}