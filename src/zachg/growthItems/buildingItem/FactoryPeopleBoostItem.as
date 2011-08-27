package zachg.growthItems.buildingItem
{
	import zachg.components.maps.FactoryPeopleBoostMapping;
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.components.maps.PopulationCenterUnitRateBoostMapping;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.growthItems.GrowthItem;

	public class FactoryPeopleBoostItem extends BuildingItem
	{

		public function FactoryPeopleBoostItem()
		{
			
			propertyMapping = new FactoryPeopleBoostMapping();
			buildingType = Factory;
			buildingLevelRequired = 0;
			playerXPRequired = 100;
			growthItemTitle = "Factory People Boost";
			description = "Gives the factory plenty of people."
			iconName = "Factory";
			
		}
		
	}
}