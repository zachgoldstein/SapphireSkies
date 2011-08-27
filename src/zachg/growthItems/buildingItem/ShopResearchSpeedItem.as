package zachg.growthItems.buildingItem
{
	import zachg.components.maps.FactoryPeopleBoostMapping;
	import zachg.components.maps.FactoryResourceBoostMapping;
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.components.maps.PopulationCenterUnitRateBoostMapping;
	import zachg.components.maps.ShopResearchSpeedMapping;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.gameObjects.Shop;
	import zachg.growthItems.GrowthItem;

	public class ShopResearchSpeedItem extends BuildingItem
	{

		public function ShopResearchSpeedItem()
		{
			
			propertyMapping = new ShopResearchSpeedMapping();
			buildingType = Shop;
			buildingLevelRequired = 0;
			playerXPRequired = 100;
			growthItemTitle = "Research Speed";
			description = "Researching goes twice as fast."
			iconName = "Shop";
			
		}
		
	}
}