package zachg.growthItems.buildingItem
{
	import zachg.components.maps.FactoryPeopleBoostMapping;
	import zachg.components.maps.FactoryResourceBoostMapping;
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.components.maps.PopulationCenterUnitRateBoostMapping;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.gameObjects.Shop;
	import zachg.growthItems.GrowthItem;

	public class ShopResourceBoostItem extends BuildingItem
	{

		public function ShopResourceBoostItem()
		{
			
			propertyMapping = new FactoryResourceBoostMapping();
			buildingType = Shop;
			buildingLevelRequired = 0;
			playerXPRequired = 100;
			growthItemTitle = "Resource Bonus";
			description = "Give the research lab resources to send."
			iconName = "Shop";
			
		}
		
	}
}