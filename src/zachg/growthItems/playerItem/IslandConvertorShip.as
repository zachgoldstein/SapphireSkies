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
			growthItemTitle = "Peace Pipe";
			weaponMapping = new Mapping();
			weaponMapping.properties.isSingleShotMode = false;
			weaponMapping.properties.isShotGunMode = true;
			weaponMapping.properties.shotDamage = 30;
			
			playerMapping = new Mapping(); 
			playerMapping.properties.thrustForce = new Point(800,800);
			playerMapping.properties.passHealth = 1000;
		
			description = "This ship will convert enemy islands after close exposure to them for a period of time."
			iconName = "ImgPlayer";
			
			tutorialTipData = [
				[
					"Enemy? Maybe not.... Keep this ship close to an enemy" +
					" village and they'll be fighting for your lovable self in no time at all." +
					"NOTE: this is a passive ability, you don't have to shoot at any bullshit for this to work." +
					"  Just keep the enemy close and all will be well."
				],
				[null],
				[new Point(200,(450/2)-(135/2))]
			]
			
		}
	}
}