package zachg.growthItems.buildingItem
{
	import zachg.components.maps.FactoryPeopleBoostMapping;
	import zachg.components.maps.FactoryResourceBoostMapping;
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.components.maps.PopulationCenterUnitRateBoostMapping;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.growthItems.GrowthItem;

	public class FactoryResourceBoostItem extends BuildingItem
	{

		public function FactoryResourceBoostItem()
		{
			
			propertyMapping = new FactoryResourceBoostMapping();
			buildingType = Factory;
			buildingLevelRequired = 0;
			playerXPRequired = 100;
			growthItemTitle = "Factory Resource Boost";
			description = "Gives the factory plenty of resources."
			iconName = "Factory";
			
		}
		
	}
}