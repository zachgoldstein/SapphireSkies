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
	import zachg.gameObjects.Village;
	import zachg.growthItems.GrowthItem;

	public class VillageResourceBoostItem extends BuildingItem
	{

		public function VillageResourceBoostItem()
		{
			
			propertyMapping = new Mapping();
			propertyMapping.properties.availableResources = 999;
			buildingType = Village;
			buildingLevelRequired = 0;
			clarityPtsRequired = 10;
			growthItemTitle = "Resource Bonus";
			description = "Village has more resources at the start."
			iconName = "Fortress";
			
		}
		
	}
}