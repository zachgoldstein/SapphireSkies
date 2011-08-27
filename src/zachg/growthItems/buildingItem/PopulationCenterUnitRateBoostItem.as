package zachg.growthItems.buildingItem
{
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.components.maps.PopulationCenterUnitRateBoostMapping;
	import zachg.gameObjects.PopulationCenter;
	import zachg.growthItems.GrowthItem;

	public class PopulationCenterUnitRateBoostItem extends BuildingItem
	{

		public function PopulationCenterUnitRateBoostItem()
		{
			
			propertyMapping = new PopulationCenterUnitRateBoostMapping();
			buildingType = PopulationCenter;
			buildingLevelRequired = 0;
			playerXPRequired = 100;
			growthItemTitle = "Unit Rate Boost";
			description = "Sends units faster."
			iconName = "Apartment";
			
		}
		
	}
}