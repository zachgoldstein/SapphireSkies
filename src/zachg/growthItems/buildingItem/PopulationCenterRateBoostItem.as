package zachg.growthItems.buildingItem
{
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.components.maps.PopulationCenterRateBoostMapping;
	import zachg.gameObjects.PopulationCenter;
	import zachg.growthItems.GrowthItem;

	public class PopulationCenterRateBoostItem extends BuildingItem
	{

		public function PopulationCenterRateBoostItem()
		{
			
			propertyMapping = new PopulationCenterRateBoostMapping();
			buildingType = PopulationCenter;
			buildingLevelRequired = 0;
			playerXPRequired = 100;
			growthItemTitle = "Population Rate Boost";
			description = "Create more people each cycle."
			iconName = "Apartment";
		}
		
	}
}