package zachg.growthItems.playerItem
{
	import flash.geom.Point;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class MediocreBalancedShip extends PlayerItem
	{
		
		public function MediocreBalancedShip(Id:int)
		{
			super(Id);
			requiredResearch = 400;
			playerXPRequired = 100;
			isWeapon = true;
			growthItemTitle = "Balanced Ship";
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = true;
			weaponMapping.properties.isShotGunMode = false;
			weaponMapping.properties.shotDamage = 50;
			weaponMapping.properties.bulletClass = Rocket;
			
			playerMapping = new Mapping();
			playerMapping.properties.thrustForce = new Point(2000,2000);
			playerMapping.properties.passHealth = 500;
		
			description = "Balanced ship that fires rockets Balanced ship that fires rockets Balanced ship that fires rockets Balanced ship that fires rockets Balanced ship that fires rockets Balanced ship that fires rockets "
			simpleDescription = "Balanced ship that fires rockets Balanced ship that fires rockets Balanced ship that fires rockets"
			weaponListing = "1. Machinegun \n 2. Rockets";
			iconName = "ImgPlayer";
			shipGraphic = "ShipSmallEnemy";
			shipGraphicParameters = [59,50]; 
			
			clarityPtsRequired = 100;
			
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